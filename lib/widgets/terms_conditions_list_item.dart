import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(widget.termsCondition),
    );
  }
}
