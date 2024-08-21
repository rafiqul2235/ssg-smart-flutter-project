import 'package:flutter/material.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/view/basewidget/button/custom_button.dart';

class MyDialog extends StatelessWidget {

  final bool isFailed;
  final bool isWarning;
  final double rotateAngle;
  final IconData? icon;
  final String? title;
  final String description;
  final String? positionButtonTxt;
  final String? negativeButtonTxt;
  final VoidCallback? onPositiveButtonPressed;

  MyDialog({this.isFailed = false,
  this.isWarning=false,
  this.rotateAngle = 0,
  this.icon, this.title,
  required this.description,
  this.positionButtonTxt,
  this.negativeButtonTxt,
  this.onPositiveButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog (
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Stack(clipBehavior: Clip.none, children: [
          icon==null?const SizedBox.shrink():
          Positioned(
            left: 0, right: 0, top: -55,
            child: Container(
              height: 80,
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: isFailed ? ColorResources.getRed(context):isWarning?ColorResources.getYellow(context): Theme.of(context).primaryColor, shape: BoxShape.circle),
              child: Transform.rotate(angle: rotateAngle, child: Icon(icon, size: 40, color: Colors.white)),
            ),
          ),

          Padding(
            padding:EdgeInsets.only(top:icon==null?20:40),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              title==null||title!.isEmpty? const SizedBox.shrink():Text(title??'', style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              title==null||title!.isEmpty? const SizedBox.shrink():const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Text(description, textAlign: TextAlign.center, style: titilliumRegular.copyWith(fontSize: 15)),
              const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  negativeButtonTxt == null || negativeButtonTxt!.isEmpty ? const SizedBox.shrink():
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      child: CustomButton(buttonText:negativeButtonTxt??'',color: ColorResources.DARK_BLUE.withOpacity(0.4), onTap: () => Navigator.pop(context,false)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      child: CustomButton(
                          buttonText:positionButtonTxt??'Ok',
                          onTap: () {
                            Navigator.pop(context,true);
                            if(onPositiveButtonPressed != null){
                              onPositiveButtonPressed!();
                            }
                          }
                      ),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ]),
      ),
    );
  }
}
