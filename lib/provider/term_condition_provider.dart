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

    //Changing the value at the particular index
    for (var i = 0; i < tempList.length; i++) {
      if (tempList[i]["id"] == tempId) {
        tempList[i] = {
          ...tempList[i],
          "value": editedValue,
        };
      }
    }

    state = [...tempList];
  }
}

final termsConditionsProvider =
    StateNotifierProvider<TermsConditionsNotifier, List<Map<String, Object>>>(
        (ref) => TermsConditionsNotifier());
