import 'package:flutter/material.dart';

import '../../../localization/language_constrants.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/custom_app_bar.dart';
import '../home/dashboard_screen.dart';

class SelfService extends StatefulWidget {
  final bool isBackButtonExist;
  const SelfService({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  State<SelfService> createState() => _SelfServiceState();
}

class _SelfServiceState extends State<SelfService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
              title: 'Emp Self Service',
              isBackButtonExist: widget.isBackButtonExist,
              icon: Icons.home,
              onActionPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const DashBoardScreen()));
              }),

            Expanded(child: SingleChildScrollView(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Menu list'),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 10.0 ),
                  child: Text('Application List',style: titilliumBold,),
                ),

                ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: 3,
                    itemBuilder: (context,index){

                      return Padding(
                        padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 10.0),
                        child: Container(
                          color: ColorResources.getGrey(context),
                          padding:  EdgeInsets.all( Dimensions.PADDING_SIZE_SMALL),
                          child: Column (

                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                Text('Leave',style: titilliumRegular,),
                                Text('10 day ago',style: titilliumRegular,)
                              ],),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('13-Feb-24',style: titilliumRegular,),
                                  Container(
                                    color: Colors.red,
                                      child: Text('In-Progress',style: titilliumRegular,))
                                ],)
                            ],
                          ),
                        ),
                      );
                    }

                )

            ],
          ),)),
        ],
      ),
    );
  }
}
