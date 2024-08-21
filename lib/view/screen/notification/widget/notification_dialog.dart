import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/response/notification_model.dart';
import 'package:ssg_smart2/provider/splash_provider.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:provider/provider.dart';

class NotificationDialog extends StatelessWidget {
  final NotificationModel notificationModel;

  const NotificationDialog({Key? key, required this.notificationModel}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          /*
          Container(
            height: MediaQuery.of(context).size.width-130, width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholder,
                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.notificationImageUrl}/${notificationModel.image}',
                height: MediaQuery.of(context).size.width-130, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                imageErrorBuilder: (c, o, s) => Image.asset(
                  Images.placeholder, height: MediaQuery.of(context).size.width-130,
                  width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                ),
              ),
            ),
          ),
           */
          //const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Text(
              notificationModel?.title??'',
              textAlign: TextAlign.center,
              style: titilliumSemiBold.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Dimensions.FONT_SIZE_LARGE,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text(
              notificationModel?.description??'',
              textAlign: TextAlign.center,
              style: titilliumRegular,
            ),
          ),

        ],
      ),
    );
  }
}
