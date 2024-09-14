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

    var info1 = 'A man of strict religious values, yet a believer in progressive dynamism, and a dreamer who thought nothing is impossible – Late A C Abdur Rahim overcame numerous challenges and obstacles to become one of the most accomplished entrepreneurs of this country. Born on the 20th of January 1915, he lost both his parents by the time he was seven years of age. Deprived of formal schooling and a typically comfortable childhood, he grew up as a man with strong determination, hardworking diligence, and humane compassion.';
    var info2 = 'By the early 1940s, Mr. Rahim started small scale commercial trading on his own. He moved to Chittagong in 1947 and stared afresh with very little capital in hand, but with a whole world of courage and faith. In 1950, he established the small trading concern dealing in various items. This proprietary business was formally incorporated on April 15, 1954 as Rahimafrooz & Co. Till date, Rahimafrooz Group commemorates this as its “Foundation Day”.';
    var info3 = 'The childhood hardship and the struggle in his young years only made Mr. Rahim a strong individual, a faithful human being, and a leader full of compassion and humanity. He was a caring father and an affectionate person throughout his life. Whoever, in his lifetime, came in touch with Mr. Rahim, fondly remembers him as a man of tremendous humility, dignity, and trustworthiness. His passion for continuously improving himself and his religious and ethical righteousness, and his dedication to please his customers – are still prevalent in today’s Rahimafrooz culture – shaping the Group’s present and its future.';
    var info4 = 'Today’s Rahimafrooz is a dream that Mr. A C Abdur Rahim turned into reality. The business growth, the social commitment, and the great diversity in today’s Rahimafrooz are the outcome of one lifetime of hard work and compassion from Mr. Rahim. He breathed his last on March 14, 1982 in London. But his work and his virtue have kept him alive forever. May Allah grant him with eternal peace.';


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

                  Center(child: Text('A.C. Abdur Rahim', style: titilliumBold.copyWith(fontSize: 18, color: Colors.black))),
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
