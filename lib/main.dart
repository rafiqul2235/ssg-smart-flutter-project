import 'package:ssg_smart2/provider/approval_hisotry_provider.dart';
import 'package:ssg_smart2/provider/approval_provider.dart';
import 'package:ssg_smart2/provider/attendance_provider.dart';
import 'package:ssg_smart2/provider/cashpayment_provider.dart';
import 'package:ssg_smart2/provider/leave_provider.dart';
import 'package:ssg_smart2/provider/master_data_provider.dart';
import 'package:ssg_smart2/provider/banner_provider.dart';
import 'package:ssg_smart2/provider/mo_provider.dart';
import 'package:ssg_smart2/provider/notification_provider.dart';
import 'package:ssg_smart2/provider/payslip_provider.dart';
import 'package:ssg_smart2/provider/pfloan_provider.dart';
import 'package:ssg_smart2/provider/report_provider.dart';
import 'package:ssg_smart2/provider/salaryAdv_provider.dart';
import 'package:ssg_smart2/provider/sales_order_provider.dart';
import 'package:ssg_smart2/provider/user_provider.dart';
import 'package:ssg_smart2/provider/search_provider.dart';
import 'package:ssg_smart2/provider/user_dashboard_provider.dart';
import 'package:ssg_smart2/provider/wppf_provider.dart';
import 'package:ssg_smart2/theme/dark_theme.dart';
import 'package:ssg_smart2/theme/light_theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/provider/auth_provider.dart';
import 'package:ssg_smart2/provider/localization_provider.dart';
import 'package:ssg_smart2/provider/splash_provider.dart';
import 'package:ssg_smart2/provider/theme_provider.dart';
import 'package:ssg_smart2/utill/app_constants.dart';
import 'package:ssg_smart2/view/screen/empselfservice/self_service.dart';
import 'package:ssg_smart2/provider/attachment_provider.dart';
import 'package:ssg_smart2/view/screen/moveorder/approver/mo_for_approver.dart';
import 'package:ssg_smart2/view/screen/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;
import 'helper/custom_delegate.dart';
import 'localization/app_localization.dart';
import 'utill/global_context.dart';


late bool isFlutterLocalNotificationsInitialized = false;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

 // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
   // await setupFlutterNotifications();
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<UserProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<UserDashboardProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ReportProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LocalizationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<NotificationProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SearchProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<BannerProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<MasterDataProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LeaveProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AttendanceProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ApprovalHistoryProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<ApprovalProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<PaySlipProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<CashPaymentProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SalaryAdvProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<PfLoanProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<WppfProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SalesOrderProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<AttachmentProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<MoveOrderProvider>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  String? initialMessage;
  bool _resolved = false;

  @override
  void initState() {

    // init();

    super.initState();
  }

  /*Future<void> showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@drawable/ic_launcher', //notification_icon
          ),
        ),
      );
    }
  }
  void init() async{
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }
        });
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }*/

  // void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  //   //when user click on notification this method call
  //   /* var route = NavigationHistoryObserver().top;
  //   if(route!=null && route.settings.name!=NotificationScreen.routeName){
  //     NavigationService.navigatorKey.currentState?.pushNamed(NotificationScreen.routeName).then((value) {
  //       FBroadcast.instance().broadcast(
  //         "update_count",
  //         value: 0,
  //       );
  //     });
  //   }
  //   else{
  //     NavigationService.navigatorKey.currentState?.pushReplacementNamed(NotificationScreen.routeName).then((value) {
  //       FBroadcast.instance().broadcast(
  //         "update_count",
  //         value: 0,
  //       );
  //     });
  //   }*/
  // }

  @override
  Widget build(BuildContext context) {

    List<Locale> _locals = [];

    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode??'', language.countryCode));
    });

    return MaterialApp(
      title: AppConstants.APP_NAME,
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
      locale: Provider.of<LocalizationProvider>(context).locale,
      routes: routes,
      localizationsDelegates: [
        AppLocalization.delegate,
       /* GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,*/
        FallbackLocalizationDelegate()
      ],
      supportedLocales: _locals,
      home:  const SplashScreen(),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  //await Firebase.initializeApp();

  /*await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );*/

//  await setupFlutterNotifications();

  /*RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    print('showFlutterNotification 195');

    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@drawable/ic_launcher', //notification_icon
        ),
      ),
    );
  }*/

}

Future<void> setupFlutterNotifications() async {

  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  // channel = const AndroidNotificationChannel(
  //   'high_importance_channel', // id
  //   'High Importance Notifications', // title
  //   description:
  //   'This channel is used for important notifications.', // description
  //   importance: Importance.high,
  // );

  // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //     AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined or has not accepted permission');
  }

  isFlutterLocalNotificationsInitialized = true;

}

final Map<String, WidgetBuilder> routes = {
  '/self-service': (context) => SelfService(),
  // ... other routes
};


