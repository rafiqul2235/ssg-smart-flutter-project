import 'package:flutter/material.dart';

class CustomTextLoading extends StatelessWidget{

  final Color bgColor;
  final Color textColor;
  final text;

  CustomTextLoading({this.text = 'Loading...',this.textColor=Colors.red,this.bgColor=Colors.transparent});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.all(0),
        alignment:Alignment.topLeft,
        height: 40,
        width: width - 40,
        color: bgColor,
        child: Padding(
            child: Text(
              text,
              style: TextStyle(
                  color:Colors.red,
                  fontSize: 15
              ),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.only(bottom: 0)
        )
    );
  }
}