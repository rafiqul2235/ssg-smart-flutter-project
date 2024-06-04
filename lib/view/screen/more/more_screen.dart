import 'dart:async';

import 'package:ssg_smart2/view/basewidget/custom_loader.dart';
import 'package:ssg_smart2/view/screen/more/widget/about_us.dart';
import 'package:ssg_smart2/view/screen/more/widget/contact_us.dart';
import 'package:ssg_smart2/view/screen/more/widget/currency_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/auth_provider.dart';
import 'package:ssg_smart2/provider/user_provider.dart';
import 'package:ssg_smart2/provider/theme_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:ssg_smart2/view/basewidget/animated_custom_dialog.dart';
import 'package:ssg_smart2/view/screen/more/widget/sign_out_confirmation_dialog.dart';
import 'package:provider/provider.dart';
import '../../../data/model/response/app_update_info.dart';
import '../../../utill/app_constants.dart';
import '../../basewidget/my_dialog.dart';
import '../apkdownload/apk_download_screen.dart';
import '../profile/profile_screen.dart';

class MoreScreen extends StatefulWidget {

  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {

  String? version;

  bool _loading = false;

  @override
  void initState() {
    version = '0.001';
    super.initState();
  }

  void _onClickReload(BuildContext context) async {

    setState(() {
      _loading = true;
    });

    //Provider.of<UserProvider>(context, listen: false).getUserDefault();
    Provider.of<UserProvider>(context, listen: false).getEmployeeInfo(context);

    Timer(const Duration(seconds: 4), () {
      setState(() {
        _loading = false;
      });
      //_updateAppVersion();
    });

  }

  void _updateAppVersion () async {
    AppUpdateInfo appUpdateInfo = Provider.of<UserProvider>(context, listen: false).appUpdateInfo!;
    if(appUpdateInfo!=null && appUpdateInfo.appVersionCode != AppConstants.APP_VERSION_CODE){
      var status = await showAnimatedDialog(context, MyDialog(
        title: 'App Update Available',
        description: 'You can now update this app to new version.',
        rotateAngle: 0,
        negativeButtonTxt: 'Later',
        positionButtonTxt: 'Update',
      ), dismissible: false);
      if(status!){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ApkDownloadScreen(title: "Apk Downloader", platform: Theme.of(context).platform,)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(children: [
        // Background
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            Images.more_page_header,
            height: 150,
            fit: BoxFit.fill,
            color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : null,
          ),
        ),

        // AppBar
        Positioned(
          top: 40,
          left: Dimensions.PADDING_SIZE_SMALL,
          right: Dimensions.PADDING_SIZE_SMALL,
          child: Consumer<UserProvider>(
            builder: (context, profile, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(Images.logo_with_name_image, height: 40),
                         InkWell(
                           onTap: () {
                             Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
                           },
                           child:profile.userInfoModel == null ? CircleAvatar(child: Icon(Icons.person, size: 35)) : ClipRRect(
                             borderRadius: BorderRadius.circular(15),
                             child: FadeInImage.assetNetwork(
                               placeholder: Images.logo_image, width: 35, height: 35, fit: BoxFit.fill,
                               image: '${AppConstants.BASE_URL}/${/*profile.userInfoModel?.photoUrl??*/''}',
                               imageErrorBuilder: (c, o, s) => CircleAvatar(child: Icon(Icons.person, size: 35)),
                             ),
                           ),
                         ),
                      ]),
                  /*Text( profile.userInfoModel != null ? '${*//*profile.userInfoModel?.firstName??*//*''} ${*//*profile.userInfoModel?.lastName??*//*''} ${selectedTerritory!=null && selectedTerritory.isNotEmpty?'( '+selectedTerritory+' )':''}':'',
                      style: titilliumRegular.copyWith(color: ColorResources.WHITE))*/
                ],
              );
            },
          ),
        ),

        Container(
          margin: EdgeInsets.only(top: 112),
          decoration: BoxDecoration(
            color: ColorResources.getIconBg(context),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      /*
                    // Top Row Items
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      SquareButton(image: Images.shopping_image, title: getTranslated('orders', context), navigateTo: OrderScreen(),count: 1,hasCount: false,),
                      SquareButton(image: Images.cart_image, title: getTranslated('CART', context), navigateTo: CartScreen(),count: Provider.of<CartProvider>(context,listen: false).cartList.length, hasCount: true,),
                      SquareButton(image: Images.offers, title: getTranslated('offers', context), navigateTo: OffersScreen(),count: 0,hasCount: false,),
                      SquareButton(image: Images.wishlist, title: getTranslated('wishlist', context), navigateTo: WishListScreen(),count: Provider.of<AuthProvider>(context, listen: false).isLoggedIn() && Provider.of<WishListProvider>(context, listen: false).wishList != null && Provider.of<WishListProvider>(context, listen: false).wishList.length > 0 ?   Provider.of<WishListProvider>(context, listen: false).wishList.length : 0, hasCount: false,),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    // Buttons
                    TitleButton(image: Images.fast_delivery, title: getTranslated('address', context), navigateTo: AddressListScreen()),
                    TitleButton(image: Images.more_filled_image, title: getTranslated('all_category', context), navigateTo: AllCategoryScreen()),
                    TitleButton(image: Images.notification_filled, title: getTranslated('notification', context), navigateTo: NotificationScreen()),
                    //: seller
                    TitleButton(image: Images.chats, title: getTranslated('chats', context), navigateTo: InboxScreen()),
                    TitleButton(image: Images.settings, title: getTranslated('settings', context), navigateTo: SettingsScreen()),
                    TitleButton(image: Images.preference, title: getTranslated('support_ticket', context), navigateTo: SupportTicketScreen()),
                    TitleButton(image: Images.term_condition, title: getTranslated('terms_condition', context), navigateTo: HtmlViewScreen(
                      title: getTranslated('terms_condition', context),
                      url: Provider.of<SplashProvider>(context, listen: false).configModel.termsConditions,
                    )),
                    TitleButton(image: Images.privacy_policy, title: getTranslated('privacy_policy', context), navigateTo: HtmlViewScreen(
                      title: getTranslated('privacy_policy', context),
                      url: Provider.of<SplashProvider>(context, listen: false).configModel.termsConditions,
                    )),
                    TitleButton(image: Images.help_center, title: getTranslated('faq', context), navigateTo: FaqScreen(
                      title: getTranslated('faq', context),
                      // url: Provider.of<SplashProvider>(context, listen: false).configModel.staticUrls.faq,
                    )),*/

                      TitleButton(image: Images.about_us, title: getTranslated('about_us', context), navigateTo: AboutUsScreen()),

                      TitleButton(image: Images.contact_us, title: getTranslated('contact_us', context), navigateTo: ContactUsScreen()),
                      /*TitleButton(image: Images.contact_us, title: getTranslated('contact_us', context), navigateTo: WebViewScreen(
                      title: getTranslated('contact_us', context),
                      url: 'https://www.rahimafrooz.com/contact-us/',
                    )),*/

                      TitleButton2(
                        image: Images.language,
                        title: getTranslated('choose_language', context),
                        onTap: () { showAnimatedDialog(context, CurrencyDialog(isCurrency: false));},
                      ),

                      TitleButton2(
                        image: Images.ic_refresh_stock,
                        title: getTranslated('Reload', context),
                        onTap: () => _onClickReload(context),
                      ),

                      ListTile(
                        leading: Icon(Icons.app_shortcut, size: 25, color: ColorResources.getPrimary(context)),
                        title: Text(getTranslated('app_info', context), style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                        trailing: const Text('v-${AppConstants.APP_VERSION_NAME}'),
                        onTap: () => {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ApkDownloadScreen(title: "Apk Downloader", platform: Theme.of(context).platform)))
                        },
                      ),

                      ListTile(
                        leading: Icon(Icons.exit_to_app, color: ColorResources.getPrimary(context), size: 25),
                        title: Text(getTranslated('sign_out', context), style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                        onTap: () => showAnimatedDialog(context, SignOutConfirmationDialog(), isFlip: true),
                      ),
                    ]),
              ),
              _loading?CustomLoader(color: Theme.of(context).primaryColor):SizedBox.shrink()
            ],
          ),
        ),
      ]),
    );
  }
}

class SquareButton extends StatelessWidget {
  final String image;
  final String title;
  final Widget navigateTo;
  final int count;
  final bool hasCount;


  SquareButton({required this.image, required this.title, required this.navigateTo, required this.count, required this.hasCount});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 100;
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo)),
      child: Column(children: [
        Container(
          width: width / 4,
          height: width / 4,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorResources.getPrimary(context),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              /*Image.asset(image, color: Theme.of(context).highlightColor),
              hasCount?
              Positioned(top: -4, right: -4,
                child: Consumer<CartProvider>(builder: (context, cart, child) {
                  return CircleAvatar(radius: 7, backgroundColor: ColorResources.RED,
                    child: Text(count.toString(),
                        style: titilliumSemiBold.copyWith(color: ColorResources.WHITE, fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                        )),
                  );
                }),
              ):SizedBox(),*/
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(title, style: titilliumRegular),
        ),
      ]),
    );
  }
}

class TitleButton2 extends StatelessWidget {
  final String image;
  final String title;
  final Function onTap;

  const TitleButton2({Key? key, required this.image, required this.title, required this.onTap}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(image, width: 25, height: 25, fit: BoxFit.fill, color: ColorResources.getPrimary(context)),
      title: Text(title, style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      onTap: ()=> onTap(),
    );
  }
}

class TitleButton extends StatelessWidget {
  final String image;
  final String title;
  final Widget? navigateTo;
  TitleButton({required this.image, required this.title, this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(image, width: 25, height: 25, fit: BoxFit.fill, color: ColorResources.getPrimary(context)),
      title: Text(title, style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      onTap: () {

        if(navigateTo == null) {
          return;
        }

        Navigator.push(
          context,
          /*PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              pageBuilder: (context, animation, secondaryAnimation) => navigateTo,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                animation = CurvedAnimation(parent: animation, curve: Curves.bounceInOut);
                return ScaleTransition(scale: animation, child: child, alignment: Alignment.center);
              },
            ),*/
            MaterialPageRoute(builder: (_) => navigateTo!),
           );

        },
      /*onTap: () => Navigator.push(context, PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => navigateTo,
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        transitionDuration: Duration(milliseconds: 500),
      )),*/
    );
  }
}

