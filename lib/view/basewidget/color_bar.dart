import 'package:flutter/material.dart';
import 'package:ssg_smart2/provider/theme_provider.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:provider/provider.dart';

class ColorBar extends StatelessWidget {

  final Function? onTap;
  final String? buttonText;
  final double height;
  final double width;
  Color color;

  ColorBar({Key? key, this.onTap, @required this.buttonText, this.color = Colors.black12,this.height = 40,this.width = 120}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    color ??= Theme.of(context).primaryColor;

    return TextButton(
      onPressed:()=> onTap,
      style: TextButton.styleFrom(padding: const EdgeInsets.only(left: 0,right: 0)),
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 6,right:6),
        decoration: BoxDecoration(
            color: color,
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1)), // changes position of shadow
            ],
            gradient: (Provider.of<ThemeProvider>(context).darkTheme || onTap == null) ? null : LinearGradient(colors: [
              color,
              color,
              color,
            ]),
            borderRadius: BorderRadius.circular(7)),
        child: Text(buttonText??'',
            style: titilliumSemiBold.copyWith(
              fontSize: 14,
              color: Theme.of(context).highlightColor,
            )),
      ),
    );
  }
}
