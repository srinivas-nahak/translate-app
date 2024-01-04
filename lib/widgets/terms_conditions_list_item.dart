import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:translate_app/utils/constants.dart';
import 'package:translate_app/widgets/show_hindi_btn.dart';

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
    _receivedTermsCondition = widget.termsCondition;
  }

  String _receivedTermsCondition = "";
  String _hindiTermsCondition = "";
  bool _showHindiText = false;

  final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.hindi);

  List<Widget> getHindiText() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Text(
          _hindiTermsCondition,
          style: kBodyTextStyle,
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    _receivedTermsCondition,
                    style: kBodyTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_showHindiText) ...getHindiText(),
                Align(
                    alignment: Alignment.centerRight,
                    child: ShowHindiBtn(
                      onPressed: () => {
                        if (_showHindiText)
                          {
                            setState(() {
                              _showHindiText = !_showHindiText;
                            })
                          }
                        else
                          {
                            onDeviceTranslator
                                .translateText(_receivedTermsCondition)
                                .then((value) => setState(() {
                                      _hindiTermsCondition = value;
                                      _showHindiText = true;
                                    }))
                          }
                      },
                    ))
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
