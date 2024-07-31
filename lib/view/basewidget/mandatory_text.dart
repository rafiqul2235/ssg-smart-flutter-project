import 'package:flutter/material.dart';

class MandatoryText extends StatelessWidget {

  final String text;
  final String mandatoryText;
  final TextStyle? textStyle;

  MandatoryText({this.text='', this.mandatoryText='', this.textStyle});

  @override
  Widget build(context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: textStyle,
        children: <TextSpan>[
          TextSpan(
              text: ' $mandatoryText',
              style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
        ],
      ),
    );
  }
}
