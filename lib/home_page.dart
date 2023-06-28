import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_assisant/constants/pallete.dart';
import 'package:voice_assisant/providers/textToSpeech_provider.dart';
import 'package:voice_assisant/widgets/feature_box.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int start = 200;
  int delay = 200;
  String? generatedContent;
  bool isSpeaking = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    Provider.of<AssitantProvider>(context, listen: false).initSpeechToText();
    Provider.of<AssitantProvider>(context, listen: false).initTextTOSpeech();
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<AssitantProvider>(context, listen: false).speechToText.stop();
    Provider.of<AssitantProvider>(context, listen: false).flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Allen"),
        centerTitle: true,
        leading: const Icon(Icons.menu),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: const BoxDecoration(
                            color: Pallete.assistantCircleColor,
                            shape: BoxShape.circle),
                      ),
                    ),
                    Container(
                      height: 123,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/Images/assistant.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                //chat bubble
                FadeInRight(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 40)
                        .copyWith(top: 30),
                    decoration: BoxDecoration(
                      border: Border.all(color: Pallete.borderColor),
                      borderRadius: BorderRadius.circular(20).copyWith(
                        topLeft: Radius.zero,
                      ),
                    ),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            generatedContent == null
                                ? "Good morning,what task can i do for you?"
                                : generatedContent!,
                            style: TextStyle(
                              fontSize: generatedContent == null ? 25 : 18,
                              color: Pallete.mainFontColor,
                            ),
                          ),
                  ),
                ),
                SlideInLeft(
                  child: Visibility(
                    visible: generatedContent == null,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 22, top: 10),
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        "Here are few features",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Pallete.mainFontColor),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: generatedContent == null,
                  child: Column(
                    children: [
                      SlideInLeft(
                        delay: Duration(milliseconds: start),
                        child: FeatureBox(
                          color: Pallete.firstSuggestionBoxColor,
                          title: 'ChatGPT',
                          description:
                              'A smarter way to stay organized and informed with chatGPT',
                        ),
                      ),
                      SlideInLeft(
                        delay: Duration(milliseconds: start + delay),
                        child: FeatureBox(
                          color: Pallete.secondSuggestionBoxColor,
                          title: 'Smart Voice Assistant',
                          description:
                              'Get the best of worlds with voice assistant powered by  ChatGPT',
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Consumer<AssitantProvider>(
            builder: (context, value, child) => Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  ZoomIn(
                    child: GestureDetector(
                      onTap: () {
                        if (isSpeaking) {
                          value.stopSpeaking();
                          isSpeaking = false;
                        } else {
                          value.systemSpeak(generatedContent!);
                          isSpeaking = true;
                        }
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.all(size.width * 0.05),
                        width: size.width * 0.7,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: generatedContent == null
                                ? Pallete.whiteColor
                                : Pallete.secondSuggestionBoxColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          isSpeaking ? 'STOP SPEAKING' : "START SPEAKING",
                          style: TextStyle(
                            color: generatedContent == null
                                ? Pallete.whiteColor
                                : Pallete.blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ZoomIn(
                    child: FloatingActionButton(
                      backgroundColor: Pallete.firstSuggestionBoxColor,
                      onPressed: () async {
                        if (await value.speechToText.hasPermission &&
                            value.speechToText.isNotListening) {
                          await value.stopSpeaking();
                          await value.startListening();
                        } else if (value.speechToText.isListening) {
                          setState(() {
                            isLoading = true;
                          });
                          final speech = await value.openAiService
                              .chatGptApi(value.lastWords);
                          setState(() {
                            isLoading = false;
                          });
                          generatedContent = speech;
                          value.systemSpeak(speech);
                          setState(() {
                            isSpeaking = true;
                          });
                          await value.stopListening();
                        } else {
                          await value.initSpeechToText();
                        }
                      },
                      child: Icon(
                        value.speechToText.isListening ? Icons.stop : Icons.mic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
