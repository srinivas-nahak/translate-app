import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:translate_app/utils/constants.dart';
import 'package:translate_app/widgets/add_terms_conditions.dart';
import 'package:translate_app/widgets/terms_conditions_list_item.dart';

import '../provider/term_condition_provider.dart';

class TermsConditionsScreen extends ConsumerWidget {
  TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Watching the change in the list
    final termsConditionsList = ref.watch(termsConditionsProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Terms & Conditions",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => const AddTermsConditions());
        },
        tooltip: "Add More",
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: downloadModel(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(10).copyWith(top: 0),
                    itemCount: termsConditionsList.length,
                    itemBuilder: (context, index) => TermsConditionsListItem(
                      termsConditionItem: termsConditionsList[index],
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

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
}
