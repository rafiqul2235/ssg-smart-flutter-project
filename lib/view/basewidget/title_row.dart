
import 'package:flutter/material.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TitleRow extends StatelessWidget {
  final String title;
  final Function? icon;
  final Function? onTap;
  final Duration? eventDuration;
  final bool isDetailsPage;
  TitleRow({required this.title,this.icon, this.onTap, this.eventDuration, this.isDetailsPage = false});

  @override
  Widget build(BuildContext context) {
    int days =0, hours=0, minutes=0, seconds=0;
    if (eventDuration != null) {
      days = eventDuration!.inDays;
      hours = eventDuration!.inHours - days * 24;
      minutes = eventDuration!.inMinutes - (24 * days * 60) - (hours * 60);
      seconds = eventDuration!.inSeconds - (24 * days * 60 * 60) - (hours * 60 * 60) - (minutes * 60);
    }

    return Row(children: [
      Text(title, style: robotoBold),
      eventDuration == null
          ? Expanded(child: SizedBox.shrink())
          : Expanded(
              child: Row(children: [
              SizedBox(width: 5),
              TimerBox(time: days),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: hours),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: minutes),
              Text(':', style: TextStyle(color: Theme.of(context).primaryColor)),
              TimerBox(time: seconds, isBorder: true),
            ])),

      icon != null
          ? InkWell(
        onTap: ()=>icon,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child:  SvgPicture.asset(
            Images.filter_image,
            height: Dimensions.ICON_SIZE_DEFAULT,
            width: Dimensions.ICON_SIZE_DEFAULT,
            color: ColorResources.getPrimary(context),
          ),
        )
      )
          : SizedBox.shrink(),

      onTap != null
          ? InkWell(
              onTap:()=> onTap,
              child: Row(children: [
                isDetailsPage == null
                    ? Text(getTranslated('VIEW_ALL', context),
                        style: titilliumRegular.copyWith(
                          color: ColorResources.getPrimary(context),
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                        ))
                    : SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.only(left : Dimensions.PADDING_SIZE_SMALL,top:Dimensions.PADDING_SIZE_SMALL,bottom: Dimensions.PADDING_SIZE_SMALL),
                  child: Icon(Icons.arrow_forward_ios,
                    color: isDetailsPage == null ? ColorResources.getPrimary(context) : Theme.of(context).hintColor,
                    size: Dimensions.FONT_SIZE_SMALL,
                  ),
                ),
              ]),
            )
          : SizedBox.shrink(),
    ]);
  }
}

class TimerBox extends StatelessWidget {
  final int time;
  final bool isBorder;

  TimerBox({required this.time, this.isBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1),
      padding: EdgeInsets.all(isBorder ? 0 : 2),
      decoration: BoxDecoration(
        color: isBorder ? null : ColorResources.getPrimary(context),
        border: isBorder ? Border.all(width: 2, color: ColorResources.getPrimary(context)) : null,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Text(time < 10 ? '0$time' : time.toString(),
          style: robotoBold.copyWith(
            color: isBorder ? ColorResources.getPrimary(context) : Theme.of(context).highlightColor,
            fontSize: Dimensions.FONT_SIZE_SMALL,
          ),
        ),
      ),
    );
  }
}


class TitleCardBar extends StatelessWidget {

  final String title;
  final bool isBorder;
  final double height;
  final Widget navigateTo;

  TitleCardBar({required this.title, required this.navigateTo, this.height = 46.0, this.isBorder = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap:() => navigateTo==null?null: Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo)),
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.all(6),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            height: height,
            padding: EdgeInsets.only(left: 10,right: 10),
            decoration: BoxDecoration(
              color: isBorder ? Colors.white : ColorResources.getPrimary(context).withOpacity(0.9),
              border: isBorder ? Border.all(width: 2, color: ColorResources.getPrimary(context)) : null,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(title,
                    style: robotoBold.copyWith(
                      color: isBorder ? ColorResources.getPrimary(context) : Theme.of(context).highlightColor,
                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                    ),
                  ),
                ),
                Icon(Icons.arrow_right_alt,color: isBorder ?ColorResources.getPrimary(context):Colors.white,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}