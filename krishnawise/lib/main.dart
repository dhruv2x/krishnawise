import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatGPTPage extends StatefulWidget {
  @override
  _ChatGPTPageState createState() => _ChatGPTPageState();
}

class _ChatGPTPageState extends State<ChatGPTPage> {
  final TextEditingController scenarioController = TextEditingController();

  String _response = '';

  Future<String> sendMessageToChatGpt(String scenario) async {
    Uri uri = Uri.parse(
        "https://krishnawise-api-production.up.railway.app/krishnawise_api");

    Map<String, dynamic> body = {
      "scenario": scenario,
    };

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(body),
    );

    Map<String, dynamic> parsedResponse = json.decode(response.body);

    String reply = parsedResponse['event_description'];
    return reply;
  }

  void onSendMessage() {
    String scenario = scenarioController.text;

    if (scenario.isEmpty) {
      setState(() {
        _response = "Please provide scenario";
      });
      return;
    }

    scenarioController.clear();

    sendMessageToChatGpt(scenario).then((response) {
      setState(() {
        _response = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('KrishnaWise')),
        backgroundColor: Colors.blue[900],
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/background.jpg",
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: scenarioController,
                    decoration: InputDecoration(
                      labelText: 'ex. I failed my school exam.',
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: onSendMessage,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[900],
                    ),
                    child: Text(
                      'Ask Krishna',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      'Note : Let Krishna think 5-10 seconds.',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    _response,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatGPTPage(),
  ));
}
