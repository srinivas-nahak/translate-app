import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translate_app/provider/term_condition_provider.dart';
import 'package:translate_app/utils/constants.dart';
import 'package:translate_app/widgets/show_hindi_btn.dart';

class AddTermsConditions extends ConsumerStatefulWidget {
  const AddTermsConditions({super.key, this.termConditionItem});

  final Map<String, Object>? termConditionItem;

  @override
  ConsumerState<AddTermsConditions> createState() => _AddTermsConditionsState();
}

class _AddTermsConditionsState extends ConsumerState<AddTermsConditions> {
  final TextEditingController _textEditingController = TextEditingController();
  OutlineInputBorder? _errorBorder;

  bool _showHindiText = false;
  String _enteredTermCondition = "";
  String _hindiTermCondition = "";
  late StateSetter _setState;

  final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.hindi);

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    _editItem();
    _initSpeech();
    super.initState();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    //Resetting the last words for next time
    _lastWords = "";

    //Showing Speech Dialog
    _showSpeechDialog(context);

    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();

    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      //Capitalizing the first letter
      _lastWords = result.recognizedWords.substring(0, 1).toUpperCase() +
          result.recognizedWords.substring(1);

      //This setState is for the dialog
      _setState(() {});
    });
  }

  void _editItem() {
    if (widget.termConditionItem != null) {
      _textEditingController.text =
          widget.termConditionItem?["value"].toString() ?? "";
      _enteredTermCondition =
          widget.termConditionItem?["value"].toString() ?? "";
    }
  }

  void _onTermsConditionsSubmit(String task) {
    if (_textEditingController.text.trim().length <= 3) {
      setState(() {
        _errorBorder = OutlineInputBorder(
          borderSide: const BorderSide(width: 1.7, color: Colors.red),
          borderRadius: BorderRadius.circular(20),
        );
      });
      return;
    }

    //Adding terms and conditions

    if (widget.termConditionItem != null) {
      final String tempId = widget.termConditionItem?["id"].toString() ?? "";

      ref.read(termsConditionsProvider.notifier).editTermCondition(
            tempId,
            _textEditingController.text,
          );
    } else {
      final random = Random();
      int randomNumber = random.nextInt(16);

      //Adding Task to the list

      ref.read(termsConditionsProvider.notifier).addTermCondition({
        "id": randomNumber,
        "value": _textEditingController.text,
        "createdAt": DateTime.now().toString(),
        "updatedAt": DateTime.now().toString(),
      });
    }

    Navigator.of(context).pop();
  }

  void _onChangedHandler(String typedText) {
    setState(() {
      _enteredTermCondition = typedText.trim();

      if (_enteredTermCondition.isEmpty) {
        setState(() {
          _showHindiText = !_showHindiText;
        });
      }

      if (_showHindiText) {
        onDeviceTranslator
            .translateText(_enteredTermCondition)
            .then((value) => setState(() {
                  _hindiTermCondition = value;
                  _showHindiText = true;
                }));
      }
    });
    if (typedText.trim().length > 3) {
      setState(() {
        _errorBorder = null;
      });
    }
  }

  List<Widget> _getHindiText() {
    return [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            _hindiTermCondition,
            style:
                kBodyTextStyle.copyWith(color: Colors.black.withOpacity(0.4)),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _textEditingController,
            onChanged: _onChangedHandler,
            maxLines: null,
            onSubmitted: _onTermsConditionsSubmit,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            style: kBodyTextStyle.copyWith(
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.w400),
            decoration: InputDecoration(
                labelText: "Term and Condition",
                labelStyle: kBodyTextStyle.copyWith(
                    color: Colors.black.withOpacity(0.5)),
                hintText: "Add Term and Condition...",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 1.7, color: Theme.of(context).primaryColorDark),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.7,
                    color: Theme.of(context).disabledColor,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                errorBorder: _errorBorder,
                errorText: _errorBorder != null
                    ? "Please enter valid term and condition."
                    : null,
                focusedErrorBorder: _errorBorder,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                    onPressed: _speechToText.isNotListening
                        ? _startListening
                        : _stopListening,
                    icon: Icon(_speechToText.isNotListening
                        ? Icons.mic
                        : Icons.mic_off),
                  ),
                )),
          ),
          const SizedBox(
            height: 5,
          ),
          if (_showHindiText) ..._getHindiText(),
          ShowHindiBtn(
            onPressed: () => {
              if (_textEditingController.text.isNotEmpty)
                {
                  if (_showHindiText)
                    {
                      setState(() {
                        _showHindiText = !_showHindiText;
                      })
                    }
                  else
                    {
                      onDeviceTranslator
                          .translateText(_enteredTermCondition)
                          .then((value) => setState(() {
                                _hindiTermCondition = value;
                                _showHindiText = true;
                              }))
                    }
                }
            },
            btnTitle: "View In Hindi",
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  _onTermsConditionsSubmit("");
                },
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.greenAccent)),
                child: const Text("Submit Terms and Conditions")),
          )
        ],
      ),
    );
  }

  void _showSpeechDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            _setState = setState;

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                _lastWords.isEmpty ? "Listening..." : _lastWords,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 25),
              ),
            );
          }), // Display spoken text in content
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Submit'),
              onPressed: () {
                _textEditingController.text = _lastWords;
                _enteredTermCondition = _lastWords;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                _stopListening();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
