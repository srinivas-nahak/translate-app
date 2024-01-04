import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TermsConditionsListItem extends StatefulWidget {
  const TermsConditionsListItem({super.key, required this.termsCondition});

  final String termsCondition;

  @override
  State<TermsConditionsListItem> createState() {
    return _TermsConditionsListItemState();
  }
}

class _TermsConditionsListItemState extends State<TermsConditionsListItem> {
  @override
  void initState() {
    super.initState();
    receivedTermsCondition = widget.termsCondition;
  }

  String receivedTermsCondition = "";
  String hindiTermsCondition = "";
  bool showHindiText = false;

  final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.hindi);

  List<Widget> getHindiText() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Text(
          hindiTermsCondition,
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    receivedTermsCondition,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (showHindiText) ...getHindiText(),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => {
                            if (showHindiText)
                              {
                                setState(() {
                                  showHindiText = !showHindiText;
                                })
                              }
                            else
                              {
                                onDeviceTranslator
                                    .translateText(receivedTermsCondition)
                                    .then((value) => setState(() {
                                          hindiTermsCondition = value;
                                          showHindiText = true;
                                        }))
                              }
                          },
                      child: const Text("Read In Hindi")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    //Releasing the translation resources
    onDeviceTranslator.close();
  }
}
