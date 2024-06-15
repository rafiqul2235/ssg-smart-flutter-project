import 'package:ssg_smart2/view/screen/home/widget/banners_view.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/auth_provider.dart';
import 'package:ssg_smart2/provider/user_provider.dart';
import 'package:ssg_smart2/provider/theme_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:provider/provider.dart';
import '../../../data/model/response/user_menu.dart';
import '../../../utill/app_constants.dart';
import '../empselfservice/self_service.dart';
import '../managementdashboard/management_dashbboard_screen.dart';
import '../notification/notification_screen.dart';
import '../pdf/pdf_list_screen.dart';
import '../profile/profile_screen.dart';
import '../report/report_dashboard_screen.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String version = "";

  @override
  void initState() {
    _initData();
    version = '0.001';
    super.initState();
  }

  _initData() async {
     await Provider.of<UserProvider>(context, listen: false).getUserInfoFromSharedPref();
     Provider.of<UserProvider>(context, listen: false).getEmployeeInfo(context);
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      //backgroundColor: const Color(0xFF043D87),
      body: SizedBox(
        width: width,
        height: height ,
        child: Stack(children: [
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
            )
            ,
          ),

          // AppBar
          Positioned(
            top: 40,
            left: Dimensions.PADDING_SIZE_SMALL,
            right: Dimensions.PADDING_SIZE_SMALL,
            child: Consumer<UserProvider>(
              builder: (context, profile, child) {
                return Row( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Image.asset(Images.logo_with_name_image, height: 40,),
                  //const Expanded(child: SizedBox.shrink()),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                            profile.userInfoModel == null ? CircleAvatar(child: Icon(Icons.person, size: 35)) : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.ic_user_login, width: 35, height: 35, fit: BoxFit.fill,
                                image: '${AppConstants.BASE_URL}/${''}',
                                imageErrorBuilder: (c, o, s) => CircleAvatar(child: Icon(Icons.person, size: 35)),
                              ),
                            ),
                          ]),
                          /*Column(
                              mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                              Text(profile.userInfoModel != null ? '${*//*profile.userInfoModel?.firstName??*//*''} ${*//*profile.userInfoModel?.lastName??*//*''} ${selectedTerritory!=null && selectedTerritory.isNotEmpty?'('+selectedTerritory+' )':''}':'',
                                  style: titilliumRegular.copyWith(color: ColorResources.WHITE)),
                            ]
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ]);
              },
            ),
          ),

          // Menus
          Container(
            margin: const EdgeInsets.only(top: 112),
            decoration: BoxDecoration(
             // color: ColorResources,
              color: ColorResources.getIconBg(context),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                  EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE),
                  child: BannersView(),
                ),
                SizedBox(height: 6),
                Expanded(
                  child:Consumer<UserProvider>(
                    builder: (context,userProvider,child){
                      List<UserMenu> userMenus = userProvider.userMenuList;
                      if(userMenus == null || userMenus.isEmpty ){
                        userProvider.getUserMenu(this.context);
                      }
                      return GridView.builder(
                          primary: false,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: userMenus.length > 4 ? 3:2,
                              childAspectRatio: userMenus.length > 4 ? 1.00:1.36,
                              //crossAxisSpacing: 20,
                              mainAxisSpacing: 16
                          ),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 16),
                          itemCount: userMenus.length,
                          itemBuilder: (BuildContext ctx, index) {

                            UserMenu userMenu = userMenus[index];

                            if(userMenu.id == '1'){
                              return HomeMenuItemCircle(image: Images.salesreport, title: userMenu.name!,navigateTo:ReportDashboardScreen(),count: 0,hasCount: false,bgColor:ColorResources.DARK_BLUE);
                            }else if(userMenu.id == '2'){
                              return HomeMenuItemCircle(image: Images.salesreport, title: userMenu.name!,navigateTo:PDFListScreen(title: getTranslated('PDF_Report', context),platform: TargetPlatform.android),count: 0,hasCount: false,bgColor:ColorResources.DARK_BLUE);
                            }else if(userMenu.id == '4'){
                              return HomeMenuItemCircle(image: Images.ic_communication_email, title:  userMenu.name!, navigateTo: NotificationScreen(),count: 0,hasCount: false,bgColor: ColorResources.DARK_BLUE,);
                            }else if(userMenu.id == '5'){
                              return HomeMenuItemCircle(image: Images.ic_communication_email, title:  userMenu.name!, navigateTo: NotificationScreen(),count: 0,hasCount: false,bgColor: ColorResources.DARK_BLUE,);
                            }else if(userMenu.id == '10'){
                              return HomeMenuItemCircle(image: Images.ic_communication_email, title:  userMenu.name!, navigateTo: NotificationScreen(),count: 0,hasCount: false,bgColor: ColorResources.DARK_BLUE,);
                            }else if(userMenu.id == '11'){
                              return HomeMenuItemCircle(image: Images.ic_communication_email, title:  userMenu.name!, navigateTo: NotificationScreen(),count: 0,hasCount: false,bgColor: ColorResources.DARK_BLUE,);
                            }else if(userMenu.id == '13'){
                              return HomeMenuItemCircle(image: Images.ic_communication_email, title:  userMenu.name!, navigateTo: ManagementDashboard(),count: 0,hasCount: false,bgColor: ColorResources.DARK_BLUE,);
                            }else if(userMenu.id == '19'){
                              return HomeMenuItemCircle(image: Images.ic_communication_email, title:  userMenu.name!, navigateTo: NotificationScreen(),count: 0,hasCount: false,bgColor: ColorResources.DARK_BLUE,);
                            }else if(userMenu.id == '14'){
                              return HomeMenuItemCircle(image: Images.ic_communication_email, title:  userMenu.name!, navigateTo: SelfService(),count: 0,hasCount: false,bgColor: ColorResources.DARK_BLUE,);
                            }else if(userMenu.id == '37'){
                              return HomeMenuItemCircle(image: Images.ic_communication_email, title:  userMenu.name!, navigateTo: NotificationScreen(),count: 0,hasCount: false,bgColor: ColorResources.DARK_BLUE,);
                            }else if(userMenu.id == '40'){
                              return HomeMenuItemCircle(image: Images.ic_communication_email, title:  userMenu.name!, navigateTo: NotificationScreen(),count: 0,hasCount: false,bgColor: ColorResources.DARK_BLUE,);
                            }else if(userMenu.id == '41'){
                              return HomeMenuItemCircle(image: Images.ic_communication_email, title:  userMenu.name!, navigateTo: NotificationScreen(),count: 0,hasCount: false,bgColor: ColorResources.DARK_BLUE,);
                            }else{
                              return HomeMenuItemCircle(image: Images.ic_service_req, title: 'TBD',count: 0,hasCount: false,navigateTo:null, bgColor: ColorResources.DARK_BLUE,);
                            }
                          }
                      );
                    }
                  )
                ),
              ],
            )
          ),
        ]),
      ),
    );
  }
}

class HomeMenuItemCircle extends StatelessWidget {

  final String image;
  final String title;
  final Widget? navigateTo;
  final int count;
  final bool hasCount;
  final Color bgColor;
  final Color badgeColor;

  HomeMenuItemCircle({required this.image, required this.title, required this.navigateTo, required this.count, required this.hasCount, required this.bgColor,this.badgeColor=Colors.green});

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width - 80;
    return InkWell(
      onTap: () {

        if(navigateTo==null){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Coming soon!'),
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 1),
          ));
          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo!));

        //print('title $title');

       /* Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
          isBrand: true,
          id: brandProvider.brandList[index].id.toString(),
          name: brandProvider.brandList[index].name,
          image: brandProvider.brandList[index].image,
        )));*/
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 5, spreadRadius: 1)]
              ),
              child: ClipOval(
                child: Padding (
                  padding: const EdgeInsets.all(8.0),
                  child: hasCount?badges.Badge(
                      stackFit: StackFit.loose,
                      badgeStyle: badges.BadgeStyle(badgeColor:badgeColor),
                      badgeContent: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                            '$count',
                            style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,color: Colors.white),
                        ),
                      ),
                      position: badges.BadgePosition.topEnd(top: 2, end: 2),
                      child: Image.asset(image,color: Colors.white,)
                  ):Image.asset(image,color: Colors.white,),
                ),
              ),
            ),
          ),
          SizedBox(
            height: (MediaQuery.of(context).size.width/4) * 0.3,
            child: Center(child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
            )),
          ),
        ],
      ),
    );
  }
}


