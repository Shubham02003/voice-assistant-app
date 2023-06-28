
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assisant/Function/openAi_service.dart';

class AssitantProvider extends ChangeNotifier{
  final speechToText = SpeechToText();
  String lastWords = '';
  OpenAiService openAiService = OpenAiService();
  FlutterTts flutterTts = FlutterTts();





  Future<void> initTextTOSpeech() async {
    await flutterTts.setSharedInstance(true);
    notifyListeners();
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
    notifyListeners();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
     notifyListeners();
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    notifyListeners();
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    notifyListeners();
  }

  void onSpeechResult(SpeechRecognitionResult result) {
      lastWords = result.recognizedWords;
      notifyListeners();

  }
  Future<void> stopSpeaking()async{
     await flutterTts.stop();
     notifyListeners();
  }
}