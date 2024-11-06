import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/provider/theme_provider.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final isBackButtonExist;
  final IconData? icon;
  final IconData? secondIcon;
  final Widget? widget;
  final Function? onActionPressed;
  final Function? onSecondActionPressed;
  final Function? onBackPressed;

  CustomAppBar({ required this.title, this.isBackButtonExist = true, this.icon,
    this.secondIcon, this.widget, this.onActionPressed, this.onSecondActionPressed, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
        child: Image.asset(
          Images.toolbar_background, fit: BoxFit.fill,
          height: 50+MediaQuery.of(context).padding.top, width: MediaQuery.of(context).size.width,
          color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : null,
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        height: 50,
        alignment: Alignment.center,
        child: Row(children: [

          isBackButtonExist ? IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
            onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.of(context).pop(),
          ) : SizedBox.shrink(),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

          Expanded(
            child: Text(
              title, style: titilliumRegular.copyWith(fontSize: 20, color: Colors.white),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
          ),
          widget != null ? widget!: const SizedBox.shrink(),
          secondIcon != null ? IconButton(
            icon: Icon(secondIcon, size: Dimensions.ICON_SIZE_DEFAULT, color: Colors.white),
            onPressed:()=> onSecondActionPressed!(),
          ) :const SizedBox.shrink(),
          icon != null ? IconButton(
            icon: Icon(icon, size: Dimensions.ICON_SIZE_DEFAULT, color: Colors.white),
            onPressed: ()=> onActionPressed!(),
          ) :const SizedBox.shrink(),
        ]),
      ),
    ]);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
