import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _apiKey =
      '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';
  static const String _apiUrl = 'https://api.openai.com/v1/completions';

  // Method to send a message to the OpenAI API and receive a response
  Future<String> sendMessage(String prompt) async {
    // Create the request payload
    final Map<String, dynamic> body = {
      'model': 'text-davinci-003', // You can change the model here if needed
      'prompt': prompt,
      'max_tokens': 150, // Adjust the response length here
      'temperature': 0.7, // Controls randomness of the response
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey', // Set the OpenAI API key
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['choices'][0]['text'].trim();
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
