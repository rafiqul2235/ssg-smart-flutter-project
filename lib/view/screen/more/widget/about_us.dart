import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../../../provider/theme_provider.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/images.dart';

class AboutUsScreen extends StatefulWidget {

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    var info1 = 'Shun Shing Group was established in Hong Kong in the year 1988 and since then Group has involved in international import and export trading business dealing with Cement, Clinker, Gypsum, Limestone, Rock Phosphate and Iron ore. They also set up a strong ocean-going dry cargo ship’s operating division to handle own cargo transportation for on-time delivery to all overseas customers.';
    var info2 = 'The first factory of Seven Rings Cement was established at Kaligong, Gazipur, Dhaka in the name of Seven Circle Bangladesh Ltd. (SCBL) on the bank of the river Shitalakha which is only 38 KM away from Dhaka city with the current production capacity of 1.9 Million M/tons per annum to cover the demand of Greater Dhaka, Mymensingh, Sylhet and Cumilla.';
    var info3 = 'The second factory of Seven Rings Cement was established in 2014 in Labanchara, KDA Industrial Area, Khulna under the name Shun Shing Cement Mills Ltd (SSCML) on the bank of Rupsha River which is only 7 KM away from Khulna City Center with production capacity of 1.5 Million M/tons per annum to cover the demand of southwest zone and northern districts of the country.';
    var info4 = 'Another greenfield VRM project construction has been installed on the bank of Shikolbha River mouth towards Karnafuly River at Shikolbha, Chattogram with the capacity of 1.5 Million Tons per annum under a new company Shun Shing Cement Industries Limited to cover the demand of Greater Chattogram and Noakhali.';


    return WillPopScope(
      onWillPop: _exitApp,
      child: Scaffold(
        //backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: [
            CustomAppBar(title: 'About Us'),

            Expanded(
              child: ListView(
                children: [

                  Image.asset(
                    Images.ac, fit: BoxFit.fitHeight, height: 200,
                    color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : null,
                  ),

                  Center(child: Text('Seven Rings Cement', style: titilliumBold.copyWith(fontSize: 18, color: Colors.black))),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(info1, style: titilliumRegular.copyWith(fontSize: 14, color: Colors.black87)),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(info2, style: titilliumRegular.copyWith(fontSize: 14, color: Colors.black87)),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(info3, style: titilliumRegular.copyWith(fontSize: 14, color: Colors.black87)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(info4, style: titilliumRegular.copyWith(fontSize: 14, color: Colors.black87)),
                  )

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
