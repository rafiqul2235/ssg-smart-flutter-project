import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {

  final double height;
  final double width;
  Color? color;

  CustomDivider({Key? key,this.color, this.height = 2, this.width = double.infinity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    color ??= Theme.of(context).primaryColor;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color,
         /* boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1)), // changes position of shadow
          ],
          gradient: LinearGradient(colors:[
            color,
            color,
            color,
          ])*/
      ),
    );
  }
}
