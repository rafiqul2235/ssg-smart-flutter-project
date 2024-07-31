import 'package:flutter/material.dart';
import '../../utill/dimensions.dart';

class CustomText extends StatelessWidget {

  final String? text;
  final Color? fillColor;
  final Color borderColor;
  final TextCapitalization? capitalization;
  final TextStyle? style;

   CustomText(
      {this.text, this.style, this.borderColor = Colors.black26,
      this.capitalization = TextCapitalization.none,
      this.fillColor});

  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      height: 45.0,
      padding: const EdgeInsets.only(
          top: Dimensions.MARGIN_SIZE_SMALL,
          bottom: Dimensions.MARGIN_SIZE_SMALL,
          left: Dimensions.MARGIN_SIZE_DEFAULT,
          right: Dimensions.MARGIN_SIZE_DEFAULT),
      decoration: BoxDecoration(
        color: fillColor??Theme.of(context).highlightColor,
        border: Border.all(color: borderColor,width: 1),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color:Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 3)) // changes position of shadow
        ],
      ),
      child: Text( text??'', style: style),
    );
  }
}
