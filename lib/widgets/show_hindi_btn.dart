import 'package:flutter/material.dart';

class ShowHindiBtn extends StatelessWidget {
  const ShowHindiBtn(
      {super.key, this.onPressed, this.btnTitle = "Read In Hindi"});

  final void Function()? onPressed;
  final String btnTitle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: const ButtonStyle(
          visualDensity: VisualDensity.compact,
        ),
        onPressed: onPressed,
        child: Text(btnTitle ?? ""));
  }
}
