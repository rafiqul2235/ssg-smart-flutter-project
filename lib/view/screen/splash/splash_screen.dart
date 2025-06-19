import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart'; // Changed from connectivity/connectivity.dart
import 'package:flutter/material.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/splash_provider.dart';
import 'package:ssg_smart2/provider/theme_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/auth/auth_screen.dart';
import 'package:ssg_smart2/view/screen/splash/widget/splash_painter.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<List<ConnectivityResult>> _onConnectivityChanged; // Changed to List<ConnectivityResult>

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    // Updated to handle List<ConnectivityResult> instead of single ConnectivityResult
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if(!_firstTime) {
        // Check if any connection type is available
        bool isNotConnected = !results.any((result) =>
        result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.ethernet
        );

        isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? getTranslated('no_connection', context) : getTranslated('connected', context),
            textAlign: TextAlign.center,
          ),
        ));

        if(!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    _route();
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  void _route() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => AuthScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Provider.of<SplashProvider>(context).hasConnection ? Stack(
        clipBehavior: Clip.none, children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : ColorResources.getPrimary(context),
          child: CustomPaint(
            painter: SplashPainter(),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Images.splash_logo, fit: BoxFit.fitWidth, width: 300.0,),
            ],
          ),
        ),
      ],
      ) : NoInternetOrDataScreen(isNoInternet: true, child: const SplashScreen()),
    );
  }
}