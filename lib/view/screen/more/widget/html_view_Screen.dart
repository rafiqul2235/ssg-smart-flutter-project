import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';

class HtmlViewScreen extends StatelessWidget {

  final String title;
  final String url;
  const HtmlViewScreen({Key? key, required this.url, required this.title}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Column(
        children: [
          CustomAppBar(title: title),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              physics: const BouncingScrollPhysics(),
              child: Html(
                data: url,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
