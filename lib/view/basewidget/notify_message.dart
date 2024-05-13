import 'package:flutter/material.dart';
import '../../utill/color_resources.dart';
import '../../utill/custom_themes.dart';
import '../../utill/dimensions.dart';

class NotifyMessage extends StatelessWidget {

  final Color? bgColor;
  final List<String> messages;
  final Color? textColor;
  final bool isBorder;
  final double height;

  NotifyMessage({@required this.bgColor, required this.messages, this.textColor, this.height = 80, this.isBorder = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(6),
        clipBehavior: Clip.none,
        child: Container(
          height: height,
          padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
          decoration: BoxDecoration(
            color: bgColor,
            border: isBorder ? Border.all(width: 2, color: ColorResources.getPrimary(context)) : null,
            borderRadius: BorderRadius.circular(3),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.only(top:10.0, left: 8.0,right: 8.0),
            scrollDirection: Axis.vertical,
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return Text('* ${messages[index]}',
                style: robotoBold.copyWith(
                  color: textColor,
                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
