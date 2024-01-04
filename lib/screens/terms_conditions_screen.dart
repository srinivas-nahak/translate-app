import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:translate_app/widgets/add_terms_conditions.dart';
import 'package:translate_app/widgets/terms_conditions_list_item.dart';

import '../provider/term_condition_provider.dart';

class TermsConditionsScreen extends ConsumerStatefulWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TermsConditionsScreen> createState() =>
      _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends ConsumerState<TermsConditionsScreen> {
  final modelManager = OnDeviceTranslatorModelManager();
  final ScrollController _scrollController = ScrollController();
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    downloadModel();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_loadingMore) {
      setState(() {
        _loadingMore = true;
      });

      ref.read(termsConditionsProvider.notifier).loadMoreData();

      setState(() {
        _loadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final termsConditionsList = ref.watch(termsConditionsProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Terms & Conditions",
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => const AddTermsConditions(),
          ).then((animateToTop) {
            if (animateToTop) {
              setState(() {
                //Scrolling to top after adding item
                _scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
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
              controller: _scrollController,
              itemCount: termsConditionsList.length + 1,
              itemBuilder: (context, index) {
                if (index < termsConditionsList.length) {
                  return TermsConditionsListItem(
                    key: UniqueKey(),
                    termsConditionItem: termsConditionsList[index],
                  );
                } else {
                  return _buildLoader();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
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
}
