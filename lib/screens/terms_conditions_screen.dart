import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:translate_app/models/data/initial_terms_conditions.dart';
import 'package:translate_app/widgets/add_terms_conditions.dart';
import 'package:translate_app/widgets/terms_conditions_list_item.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  final modelManager = OnDeviceTranslatorModelManager();

  final tempTermsConditions = [...initialTermsConditions];

  @override
  void initState() {
    //Downloading the model if it's not already available
    downloadModel();

    super.initState();
  }

  Future<void> downloadModel() async {
    final bool isHindiModelAvailable =
        await modelManager.isModelDownloaded(TranslateLanguage.hindi.bcpCode);
    final bool isEnglishModelAvailable =
        await modelManager.isModelDownloaded(TranslateLanguage.english.bcpCode);

    if (isHindiModelAvailable && isEnglishModelAvailable) {
      return;
    }

    await modelManager.downloadModel(TranslateLanguage.hindi.bcpCode);
    modelManager.downloadModel(TranslateLanguage.english.bcpCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Translation App"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => const AddTermsConditions()).then((value) {
            if (value.toString().isNotEmpty) {
              final random = Random();
              int randomNumber = random.nextInt(16);

              //Adding Task to the list
              setState(() {
                tempTermsConditions.insert(0, {
                  "id": randomNumber,
                  "value": value,
                  "createdAt": DateTime.now().toString(),
                  "updatedAt": DateTime.now().toString(),
                });
              });
            }
          });
        },
        tooltip: "Add More",
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: tempTermsConditions.length,
              itemBuilder: (context, index) => TermsConditionsListItem(
                termsCondition: tempTermsConditions[index]["value"].toString(),
              ),
            ),
          ),
          //ElevatedButton(onPressed: () {}, child: Text("Add More"))
        ],
      ),
    );
  }
}
