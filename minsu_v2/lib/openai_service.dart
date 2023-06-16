import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

const openAIAPIKey = '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';
const apiUrl = 'https://api.openai.com/v1/completions';

class OpenAIService {
  final List<Map<String, String>> messages = [];
  FlutterTts flutterTts = FlutterTts();
  String text ='';

  Future<String> isyesPromptAPI(String prompt) async {
    print(prompt);
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "temperature": 0.5,
          "max_tokens": 1,
          "messages": [
            {'role': 'user', 'content':'Is this reply a positive response to the following question? Q: Are you tired now?  Reply: 피곤해.'},
            {'role': 'assistant', 'content':'Yes.'},
            // {'role': 'user', 'content':'Is this reply a positive response to the following question? Q: Are you tired now?  Reply: 멀쩡해.'},
            // {'role': 'assistant', 'content':'No.'},
            {'role': 'user', 'content':'Is this reply a positive response to the following question? Q: Are you tired now?  Reply: 맞아.'},
            {'role': 'assistant', 'content':'Yes.'},
            {'role': 'user', 'content':'Is this reply a positive response to the following question? Q: Are you tired now?  Reply: 아니.'},
            {'role': 'assistant', 'content':'No.'},
            // {'role': 'user', 'content':'Is this reply a positive response to the following question? Q: Are you tired now?  Reply: 응, 잠 와.'},
            // {'role': 'assistant', 'content':'Yes.'},
            {
              'role': 'user',
              'content':
              'Is this reply a positive response to the following question? Q: Are you tired now?  Reply: $prompt. Just answer yes or no.',
              // " '당신은 지금 피곤하신가요?'라는 질문에 대해서 사용자의 응답이 피곤하다는 의사표시에 해당하는가? 사용자 응답: $prompt. 네, 아니오로만 대답해.",
            }
          ],
        }),
      );
      print(res.body);
      if (res.statusCode == 200){
        text = '';
        String content = jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        print(content);

        switch (content) {
          case 'Yes':
          case 'Yes.':
            text = '잠을 깨실수 있도록 신나는 음악을 틀어 드릴게요';
            break;
          case 'No':
            text = '네, 알겠습니다.';
        }
        return text;

      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "너는 자동차 운전자의 비서야. 질문에 대해 대답해줘."},
            messages
          ],
        }),
      );

      if (res.statusCode == 200) {
        String content =
        jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        await flutterTts.speak(content);
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }
}