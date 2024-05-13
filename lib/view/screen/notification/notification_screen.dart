import 'package:ssg_smart2/data/model/response/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/helper/date_converter.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/notification_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../home/dashboard_screen.dart';

class NotificationScreen extends StatelessWidget {

  final bool isBackButtonExist;
  const NotificationScreen({Key? key, this.isBackButtonExist = true}):super(key: key);

  @override
  Widget build(BuildContext context) {

    Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context,1,50);

    return Scaffold(
      body: Column(children: [

        CustomAppBar(title: getTranslated('Message', context), isBackButtonExist: isBackButtonExist,
          icon: Icons.home,onActionPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));}),

        Expanded(
          child: Consumer<NotificationProvider>(
            builder: (context, notification, child) {
              return notification.notificationList != null? notification.notificationList.length != 0 ? RefreshIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                onRefresh: () async {
                  //await Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);
                },
                child: ListView.builder(
                  itemCount: Provider.of<NotificationProvider>(context).notificationList.length,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                  itemBuilder: (context, index) {

                    NotificationModel model = notification.notificationList[index];

                    return InkWell(
                      onTap: () {
                        showDialog(context: context, builder: (context) => NotificationDialog(notificationModel: notification.notificationList[index]));
                        model.changeMessageFlag();
                        Provider.of<NotificationProvider>(context, listen: false).changeMessageReadFlag(context,model.id!);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                        color: ColorResources.getGrey(context),
                        child: ListTile (
                          leading: ClipOval(child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder, height: 50, width: 50, fit: BoxFit.cover,
                            image: '',
                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 50, width: 50, fit: BoxFit.cover),
                          )),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(model.title??'', style: titilliumRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                color:Colors.black.withOpacity(.8),
                                fontWeight:model.isViewed!?FontWeight.normal:FontWeight.bold
                              )),
                              Text(DateConverter.reverseStringToStringDateTime4(model.createdAt??''),
                                  style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.black.withOpacity(.8),
                                  fontWeight:model.isViewed!?FontWeight.normal:FontWeight.bold
                                ),
                              )
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Text(model.description??'',
                                     style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.black.withOpacity(.8),
                                     fontWeight:model.isViewed!?FontWeight.normal:FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              Text(model.sender??'',
                                 style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.black.withOpacity(.8),
                                 fontWeight:model.isViewed!?FontWeight.normal:FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ) : NoInternetOrDataScreen(isNoInternet: false) : const NotificationShimmer();
            },
          ),
        ),

      ]),
    );
  }
}

class NotificationShimmer extends StatelessWidget {

  const NotificationShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
          color: ColorResources.getGrey(context),
          alignment: Alignment.center,
          child: Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey,
            enabled: Provider.of<NotificationProvider>(context).notificationList == null,
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.notifications)),
              title: Container(height: 20, color: ColorResources.WHITE),
              subtitle: Container(height: 10, width: 50, color: ColorResources.WHITE),
            ),
          ),
        );
      },
    );
  }
}

