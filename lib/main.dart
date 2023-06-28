import 'package:flutter/material.dart';
import 'package:voice_assisant/constants/pallete.dart';
import 'package:voice_assisant/home_page.dart';
import 'package:provider/provider.dart';
import 'package:voice_assisant/providers/textToSpeech_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>AssitantProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(
          useMaterial3: true,
        ).copyWith(
            scaffoldBackgroundColor: Pallete.whiteColor,
            appBarTheme: const AppBarTheme(backgroundColor: Pallete.whiteColor)),
        home: const MyHomePage(),
      ),
    );
  }
}
