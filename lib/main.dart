import 'package:flutter/material.dart';
import 'package:translate_app/screens/terms_conditions_screen.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent);
var kDarkColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xff202020));

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translation App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.all(10),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer, elevation: 0),
        ),
      ),
      home: TermsConditionsScreen(),
    );
  }
}
