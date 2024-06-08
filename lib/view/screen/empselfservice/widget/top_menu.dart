import 'package:flutter/material.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';

class TopMenuItem extends StatelessWidget {

  final String image;
  final String menuName;
  final Widget? navigateTo;

  TopMenuItem({required this.image, required this.menuName, required this.navigateTo});

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

      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          border:Border.all(color: Colors.deepPurple,width: 2),
          borderRadius: BorderRadius.all(
              Radius.circular(10.0) //                 <--- border radius here
          ),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 5, spreadRadius: 1)]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipOval(
                child: Image.asset(image)
              ),
            ),
            SizedBox(
              //height: (MediaQuery.of(context).size.width/4) * 0.3,
              child: Center(child: Text(
                '$menuName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
