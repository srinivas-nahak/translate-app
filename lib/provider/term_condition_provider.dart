import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:translate_app/models/data/initial_terms_conditions.dart';

class TermsConditionsNotifier extends StateNotifier<List<Map<String, Object>>> {
  TermsConditionsNotifier() : super(initialTermsConditions);

  void addTermCondition(Map<String, Object> newTermCondition) {
    state = [newTermCondition, ...state];
  }

  void editTermCondition(String id, String editedValue) {
    final int tempId = int.parse(id);

    List<Map<String, Object>> tempList = [...state];

    for (final item in tempList) {
      if (item["id"] == tempId) {
        item["value"] = editedValue;
        print(item["id"]);
        break;
      }
    }

    state = [...tempList];
  }
}

final termsConditionsProvider =
    StateNotifierProvider<TermsConditionsNotifier, List<Map<String, Object>>>(
        (ref) => TermsConditionsNotifier());
