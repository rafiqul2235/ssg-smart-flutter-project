import 'package:ssg_smart2/view/basewidget/textfield/custom_password_textfield.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/auth_provider.dart';
import 'package:ssg_smart2/provider/theme_provider.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:ssg_smart2/view/basewidget/button/custom_button.dart';
import 'package:provider/provider.dart';
import '../../basewidget/animated_custom_dialog.dart';
import '../../basewidget/my_dialog.dart';
import 'auth_screen.dart';

class ResetPasswordScreen extends StatefulWidget {

  final String? email;
  final String? otp;

  ResetPasswordScreen({this.email, this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final GlobalKey<ScaffoldMessengerState> _key = GlobalKey();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  final FocusNode _passwordNode = FocusNode();
  final FocusNode _rePasswordNode = FocusNode();

  bool isReadOnlyEmailField = false;
  String otpValue = '';

  void resetPassword() {

    print(' click sendOtpToMail');

    if(_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(getTranslated('ENTER_YOUR_PASSWORD', context)),
        backgroundColor: Colors.red,
      ));

    }else if(_rePasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(getTranslated('RE_ENTER_PASSWORD', context)),
        backgroundColor: Colors.red,
      ));

    }else if(_passwordController.text != _rePasswordController.text){

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(getTranslated('PASSWORD_DID_NOT_MATCH', context)),
        backgroundColor: Colors.red,
      ));

    }else {

      print(' Reset Password Call');

      Provider.of<AuthProvider>(context, listen: false).resetPassword(widget.email??'',int.parse(widget.otp??''),_passwordController.text).then((value) async {

        if(value.isSuccess) {

           await showAnimatedDialog(context, MyDialog(
            icon: Icons.done,
            title: ''/*getTranslated('RESET', context)*/,
            description: getTranslated('RESET_SUCCESS', context),
            rotateAngle: 0,
          ), dismissible: false);

          _passwordController.clear();
          _rePasswordController.clear();

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>  AuthScreen()), (route) => false);

        }else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value.message),
            backgroundColor: Colors.red,
          ));

        }
      });
    }
  }

  @override
  void dispose() {

    _passwordController.dispose();
    _rePasswordController.dispose();
    _passwordNode.dispose();
    _rePasswordNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _key,
      body: Container(
        decoration: BoxDecoration(
          image: Provider.of<ThemeProvider>(context).darkTheme ? null : DecorationImage(image: AssetImage(Images.background), fit: BoxFit.fill),
        ),
        child: Column(
          children: [

            SafeArea(child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_outlined),
                onPressed: () => Navigator.pop(context),
              ),
            )),

            Expanded(
              child: ListView(padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE), children: [

                Padding(
                  padding: EdgeInsets.all(50),
                  child: Image.asset(Images.durti_left, height: 120, width: 180),
                ),

                Text(getTranslated('RESET_PASSWORD', context), style: titilliumSemiBold),

                Row(children: [
                  Expanded(flex: 1, child: Divider(thickness: 1, color: Theme.of(context).primaryColor)),
                  Expanded(flex: 2, child: Divider(thickness: 0.2, color: Theme.of(context).primaryColor)),
                ]),

                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                CustomPasswordTextField(
                  controller: _passwordController,
                  focusNode: _passwordNode,
                  nextNode: _rePasswordNode,
                  hintTxt: getTranslated('ENTER_YOUR_PASSWORD', context),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 10),

                CustomPasswordTextField(
                  controller: _rePasswordController,
                  focusNode: _rePasswordNode,
                  hintTxt: getTranslated('RE_ENTER_PASSWORD', context),
                  textInputAction: TextInputAction.done,
                ),

                SizedBox(height: 30),

                Builder(
                  builder: (context) => !Provider.of<AuthProvider>(context).isLoading! ? CustomButton(
                    buttonText: getTranslated('RESET', context),
                    onTap: () {

                      resetPassword();

                    },
                  ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
