import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:event_management_system/utils/theme.dart'; // Import AppTheme for blue theme

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final String _geminiApiKey =
      'AIzaSyBjfwM9RINPD2e4K6HiZmtFvksd7eYgNHs'; // Replace with your Gemini API key
  final String _geminiApiUrl =
      'https://generativelanguage.googleapis.com/v1beta/{model=models/*}:generateContent'; // Example URL, modify with actual endpoint

  // Send the user message to the chatbot (Gemini API)
  Future<void> _sendMessage() async {
    String userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'message': userMessage});
      _isLoading = true; // Show loading indicator
    });

    _controller.clear();

    // Send message to the Gemini API and get response
    String botResponse = await _getGeminiResponse(userMessage);

    setState(() {
      _messages.add({'role': 'bot', 'message': botResponse});
      _isLoading = false; // Hide loading indicator
    });
  }

  // Function to send request to Gemini API and get response
  Future<String> _getGeminiResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_geminiApiUrl),
        headers: {
          'Authorization':
              'Bearer $_geminiApiKey', // Add the API key to the request header
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prompt': message,
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['text'] ?? 'No response from Gemini';
      } else {
        return 'Error: Unable to fetch response from Gemini API';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  // Widget to build the chat messages
  Widget _buildChatMessages() {
    return ListView.builder(
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        var message = _messages[index];
        bool isUserMessage = message['role'] == 'user';
        return ListTile(
          title: Align(
            alignment:
                isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              decoration: BoxDecoration(
                color: isUserMessage ? AppTheme.primaryColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: SelectableText(
                message['message']!,
                style: TextStyle(
                  color: isUserMessage ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Gemini AI'),
        backgroundColor: AppTheme.primaryColor, // Blue theme for the app bar
      ),
      body: Column(
        children: [
          Expanded(child: _buildChatMessages()),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      labelStyle: TextStyle(
                          color: AppTheme.primaryColor), // Label text color
                      filled: true,
                      fillColor:
                          Colors.grey[100], // Light gray background for input
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: AppTheme.primaryColor, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: AppTheme.primaryColor, width: 2),
                      ),
                    ),
                    style: TextStyle(
                        color: AppTheme.primaryColor), // Input text color
                    onSubmitted: (_) {
                      // Send message when the user presses "Enter"
                      _sendMessage();
                    },
                  ),
                ),
                const SizedBox(
                    width: 8), // Spacing between input and send button
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: AppTheme.primaryColor, // Send button color
                  padding: const EdgeInsets.all(12),
                  splashColor:
                      AppTheme.primaryColor.withOpacity(0.2), // Splash effect
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
