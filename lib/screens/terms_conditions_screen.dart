import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:translate_app/models/data/initial_terms_conditions.dart';
import 'package:translate_app/widgets/terms_conditions_list_item.dart';

class TermsConditionsScreen extends StatelessWidget {
  TermsConditionsScreen({super.key});

  final modelManager = OnDeviceTranslatorModelManager();

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
    //Downloading the model if it's not already available
    downloadModel();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Translation App"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: "Add More",
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: initialTermsConditions.length,
              itemBuilder: (context, index) => TermsConditionsListItem(
                termsCondition:
                    initialTermsConditions[index]["value"].toString(),
              ),
            ),
          ),
          //ElevatedButton(onPressed: () {}, child: Text("Add More"))
        ],
      ),
    );
  }
}
