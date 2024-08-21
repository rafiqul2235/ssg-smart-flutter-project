import 'package:flutter/material.dart';
import '../../utill/custom_themes.dart';

class NoRecordFounds extends StatelessWidget {

  final String? message;
  NoRecordFounds({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:<Widget>[
          Icon(
            Icons.hourglass_empty_outlined,
            color: Colors.grey,
            size: 60.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            message??'No records found.',
            style: titilliumSemiBold,
          ),
        ],
      ),
    );
  }
}
