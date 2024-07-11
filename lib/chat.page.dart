import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart'; // Importer le fichier de configuration

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> data = [
    {'message': 'Hello', 'type': 'user'},
    {'message': 'How can I help you?', 'type': 'assistant'},
    {'message': 'Give me information about you', 'type': 'user'},
    {'message': 'I am a helpful assistant', 'type': 'assistant'},
  ];

  TextEditingController queryController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void _sendMessage() async {
    String query = queryController.text;
    setState(() {
      data.add({'message': query, 'type': 'user'});
    });
    queryController.clear();

    var response = await http.post(
      Uri.parse(apiEndpoint), // Utiliser l'URL de l'API OpenAI
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': query}
        ],
        'temperature': 0.7,
      }),
    );

    var responseBody = jsonDecode(response.body);
    setState(() {
      data.add({
        'message': responseBody['choices'][0]['message']['content'],
        'type': 'assistant'
      });
    });
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                bool isUser = data[index]['type'] == 'user';
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Row(
                          children: [
                            SizedBox(width: isUser ? 100 : 0),
                            Expanded(
                              child: Card(
                                child: Container(
                                  child: Text(data[index]['message']),
                                  padding: EdgeInsets.all(10),
                                  color: isUser
                                      ? Color.fromARGB(50, 0, 255, 0)
                                      : Color.fromARGB(50, 0, 0, 255),
                                ),
                              ),
                            ),
                            SizedBox(width: isUser ? 0 : 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: queryController,
                    onSubmitted: (value) => _sendMessage(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 1, color: Colors.greenAccent),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
