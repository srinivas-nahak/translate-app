import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Translation App"),
        backgroundColor: Colors.grey,
      ),
      body: const Center(
          child: Text(
        "Heyy",
        style: TextStyle(fontSize: 30),
      )),
    );
  }
}
