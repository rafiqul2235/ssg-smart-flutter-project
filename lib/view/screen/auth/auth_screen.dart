import 'package:flutter/material.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/auth_provider.dart';
import 'package:ssg_smart2/provider/theme_provider.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:ssg_smart2/view/screen/auth/widget/sign_in_widget.dart';
import 'package:provider/provider.dart';
import '../../../provider/localization_provider.dart';
import '../../../utill/app_constants.dart';

class AuthScreen extends StatelessWidget{
  final int initialPage;

  AuthScreen({this.initialPage = 0});

  @override
  Widget build(BuildContext context) {

    Provider.of<AuthProvider>(context, listen: false).isRemember;
    PageController _pageController = PageController(initialPage: initialPage);

    int index = Provider.of<LocalizationProvider>(context, listen: false).languageIndex;

    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // background
          Provider.of<ThemeProvider>(context).darkTheme ? const SizedBox()
              : Image.asset(Images.background, fit: BoxFit.fill, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),
          Consumer<AuthProvider>(
            builder: (context, auth, child) => SafeArea (
              child: SingleChildScrollView(
                child: Column (
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Choose Language
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: Dimensions.MARGIN_SIZE_SMALL, top: Dimensions.MARGIN_SIZE_SMALL),
                          child: InkWell(
                            onTap: () {
                             /* _pageController.animateToPage(
                                  0, duration: Duration(seconds: 1),
                                  curve: Curves.easeInOut);*/

                              index = index==0? 1:0;

                              Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                                AppConstants.languages[index].languageCode!,
                                AppConstants.languages[index].countryCode,
                              ));

                            },
                            child:Container(
                              padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(20))
                                ),
                                child: Text(index==0?'বাংলা':'English', style: titilliumRegular),
                            ),

                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_SMALL,
                          right: Dimensions.MARGIN_SIZE_SMALL),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            //onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgetPasswordScreen())),
                            //trailing: const Text('v-${AppConstants.APP_VERSION_NAME}'),
                            child: Text(('Version : ${AppConstants.APP_VERSION_NAME}'), style: titilliumRegular.copyWith(color: Theme.of(context).primaryColor)),
                          ),
                        ],
                      ),
                    ),

                    // for logo with text
                    Image.asset(Images.druti_int_logo, height: 150, width: 200),

                    // for decision making section like signin or register section
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.MARGIN_SIZE_LARGE),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Consumer<AuthProvider>(
                            builder: (context,authProvider,child)=> Row(
                              children: [
                                InkWell(
                                  onTap: () => _pageController.animateToPage(0, duration: const Duration(seconds: 1), curve: Curves.easeInOut),
                                  child: Column(
                                    children: [
                                      Text(getTranslated('SIGN_IN', context), style: authProvider.selectedIndex == 0 ? titilliumBold : titilliumBold),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SignInWidget()

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

