import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../../../provider/theme_provider.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/images.dart';

class ContactUsScreen extends StatefulWidget {

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _exitApp,
      child: Scaffold(
        //backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: [
            CustomAppBar(title: 'Contact Us'),

            Expanded(
              child: ListView(
                children: [
                  Center(child: Text('Address', style: titilliumBold.copyWith(fontSize: 18, color: Colors.black))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Arzed Chamber, 13 Mohakhali, Dhaka 1212', style: titilliumRegular.copyWith(fontSize: 14, color: Colors.black87))),
                  ),

                  Center(child: Text('Phone', style: titilliumBold.copyWith(fontSize: 18, color: Colors.black))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('+88-022222-93442-3 or 16213', style: titilliumRegular.copyWith(fontSize: 14, color: Colors.black87))),
                  ),

                  Center(child: Text('Email', style: titilliumBold.copyWith(fontSize: 18, color: Colors.black))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('raco@rahimafrooz.com', style: titilliumRegular.copyWith(fontSize: 14, color: Colors.black87))),
                  ),

                  //_isLoading ? CustomLoader(color: Theme.of(context).primaryColor) : SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _exitApp() async {
    /*if(controllerGlobal != null) {
      if (await controllerGlobal.canGoBack()) {
        controllerGlobal.goBack();
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    }else {
      return Future.value(true);
    }*/
    return true;
  }
}
