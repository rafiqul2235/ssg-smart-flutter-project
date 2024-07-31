import 'package:flutter/material.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/splash_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:provider/provider.dart';

class AppInfoDialog extends StatelessWidget {

  const AppInfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(getTranslated('app_info', context), style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1))],
                      ),
                      child: Icon(Icons.clear, size: 18, color: ColorResources.getYellow(context))),
                ),
              ],
            ),
            Divider(thickness: .1, color: Theme.of(context).primaryColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(getTranslated('VERSION_NAME', context), style: titilliumRegular),
                Text(Provider.of<SplashProvider>(context, listen: false).packageInfo!.buildNumber!, style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ],
            ),
            Divider(thickness: .1, color: Theme.of(context).primaryColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(getTranslated('RELEASE_DATE', context), style: titilliumRegular),
                Text('01 Jan 2021', style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
