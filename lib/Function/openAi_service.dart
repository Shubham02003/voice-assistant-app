import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voice_assisant/secrets.dart';

class OpenAiService {
  final List<Map<String,String>> message=[];
  Future<String> isArtPromptAPI(String prompt) async {
    final res = await chatGptApi(prompt);
      return res;
  }

  Future<String> chatGptApi(String prompt) async {
    message.add({
      'role':"user",
      'content':prompt,
    });
    try {
      final responce = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openAPIKey"
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": message,
        }),
      );
      print(responce.body);
      if (responce.statusCode == 200) {
        String content =
            jsonDecode(responce.body)['choices'][0]['message']["content"];
        content = content.trim();
        message.add({
          'role':'assistant',
          'content':content
        });
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }
}
