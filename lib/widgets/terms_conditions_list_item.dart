import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:translate_app/utils/constants.dart';
import 'package:translate_app/widgets/add_terms_conditions.dart';
import 'package:translate_app/widgets/show_hindi_btn.dart';

class TermsConditionsListItem extends StatefulWidget {
  const TermsConditionsListItem({super.key, required this.termsConditionItem});

  final Map<String, Object> termsConditionItem;

  @override
  State<TermsConditionsListItem> createState() {
    return _TermsConditionsListItemState();
  }
}

class _TermsConditionsListItemState extends State<TermsConditionsListItem> {
  @override
  void initState() {
    super.initState();
    _receivedTermsCondition = widget.termsConditionItem["value"].toString();
  }

  String _receivedTermsCondition = "";
  String _hindiTermsCondition = "";
  bool _showHindiText = false;
  bool _showProgress = false;

  final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.hindi);

  List<Widget> getHindiText() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Text(
          _hindiTermsCondition,
          style: kBodyTextStyle.copyWith(color: Colors.black.withOpacity(0.4)),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ];
  }

  void _showHindiClickHandler() {
    if (_showHindiText) {
      setState(() {
        _showHindiText = !_showHindiText;
      });
    } else {
      //Showing Loader
      setState(() {
        _showProgress = true;
      });

      onDeviceTranslator
          .translateText(_receivedTermsCondition)
          .then((value) => setState(() {
                //Hiding progressbar
                _showProgress = false;

                //Showing hindi text
                _hindiTermsCondition = value;
                _showHindiText = true;
              }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) => AddTermsConditions(
                    termConditionItem: widget.termsConditionItem));
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _receivedTermsCondition,
                    style: kBodyTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (_showProgress)
                    const Center(
                      child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          )),
                    ),
                  if (_showHindiText) ...getHindiText(),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ShowHindiBtn(
                        onPressed: _showHindiClickHandler,
                      ))
                ],
              ),
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
