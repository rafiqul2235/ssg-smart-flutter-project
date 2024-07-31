import 'dart:async';
import 'package:ssg_smart2/helper/email_checker.dart';
import 'package:ssg_smart2/view/screen/auth/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/auth_provider.dart';
import 'package:ssg_smart2/provider/theme_provider.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:ssg_smart2/view/basewidget/button/custom_button.dart';
import 'package:ssg_smart2/view/basewidget/textfield/custom_textfield.dart';
import 'package:provider/provider.dart';
import '../../basewidget/textfield/custom_textfield_with_edit.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final GlobalKey<ScaffoldMessengerState> _key = GlobalKey();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final FocusNode _emailNode = FocusNode();
  final FocusNode _otpNode = FocusNode();

  bool isReadOnlyEmailField = false;
  String otpValue = '';

  Timer? timer;
  bool isTimerRunning = false;
  int timerTime = 120;
  String timerMessage = "Didn\'t receive OTP Code!";


  void startTimer() {
    timerTime = 120;
    isTimerRunning = true;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec,(Timer timer) {
        if (timerTime == 0) {
          cancelTimer();
          setState(() {
            timerMessage = "Didn\'t receive OTP Code!";
          });
        } else {
          setState(() {
            timerTime--;
            timerMessage = 'Resend code in $timerTime sec.';
          });
        }
      },
    );
  }

  void cancelTimer(){
    if(timer!=null){
      timer!.cancel();
      setState(() {
        isTimerRunning = false;
      });
    }
  }

  void sendOtpToMail() {

    print(' click sendOtpToMail');

    if(_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(getTranslated('EMAIL_MUST_BE_REQUIRED', context)),
        backgroundColor: Colors.red,
      ));

    }else if(!_emailController.text.isValidEmail()){

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Enter Valid Eamil Address'),
        backgroundColor: Colors.red,
      ));

    }else {

    /*  showAnimatedDialog(context, MyDialog(
        icon: Icons.send,
        title: getTranslated('sent', context),
        description: "${getTranslated('SENT_OTP_TO_MAIL', context)} \n ${_emailController.text}",
        rotateAngle: 5.0,
      ), dismissible: false);*/

      startTimer();

      Provider.of<AuthProvider>(context, listen: false).sendOtpToEmail(_emailController.text).then((value) {

        if(value.isSuccess) {
          /*FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }*/
          //_controller.clear();
          otpValue = value.message;

          setState(() {
            isReadOnlyEmailField = true;
            _otpController.clear();
            _otpNode.requestFocus();
          });

        }else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(value.message),
            backgroundColor: Colors.red,
          ));
          /*_key.currentState.showSnackBar(SnackBar(content: Text(value.message), backgroundColor: Colors.red));*/
        }
      });
    }
  }

  void otpVerify() {

    print(' click otpVerify');

    cancelTimer();

    if(_otpController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Enter Your OTP'),
        backgroundColor: Colors.red,
      ));
    }else if (otpValue != _otpController.text){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Enter Valid OTP"),
        backgroundColor: Colors.red,
      ));
    }else{
      print(' Go Reset Password Page');

      Navigator.push(context, MaterialPageRoute(builder: (_) => ResetPasswordScreen(email:_emailController.text, otp: _otpController.text,)));

    }

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

                Text(getTranslated('FORGET_PASSWORD', context), style: titilliumSemiBold),

                Row(children: [
                  Expanded(flex: 1, child: Divider(thickness: 1, color: Theme.of(context).primaryColor)),
                  Expanded(flex: 2, child: Divider(thickness: 0.2, color: Theme.of(context).primaryColor)),
                ]),

                Text(getTranslated('enter_email_for_password_reset', context), style: titilliumRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                CustomTextFieldWithEdit(
                  controller: _emailController,
                  focusNode: _emailNode,
                  nextNode: _otpNode,
                  hintText: getTranslated('ENTER_YOUR_EMAIL', context),
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.emailAddress,
                  readOnly: isReadOnlyEmailField,
                  onClickEditButton: (){
                    setState(() {
                      isReadOnlyEmailField = false;
                      cancelTimer();
                    });
                  },
                ),
                SizedBox(height: 10),
                isReadOnlyEmailField?
                CustomTextField(
                  controller: _otpController,
                  focusNode: _otpNode,
                  hintText: getTranslated('ENTER_YOUR_OTP', context),
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.number,
                ):SizedBox.shrink(),
                SizedBox(height: 5),
                isReadOnlyEmailField?
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(timerMessage, style:isTimerRunning?titilliumRegular.copyWith(color: Colors.black):titilliumRegular.copyWith(color: Colors.grey)),
                    SizedBox(width: 16,),
                    InkWell(
                      onTap: () {
                        if(!isTimerRunning){
                          FocusScope.of(context).requestFocus(new FocusNode());
                           sendOtpToMail();
                          }
                        },
                      child: Text(
                        'Resend',
                        style: isTimerRunning?titilliumRegular.copyWith(color: Colors.grey):titilliumRegular,
                      ),
                    ),
                  ],
                ):SizedBox.shrink(),

                SizedBox(height: 30),

                Builder(
                  builder: (context) => !Provider.of<AuthProvider>(context).isLoading! ? CustomButton(
                    buttonText: getTranslated('Continue', context),
                    onTap: () {
                      if(isReadOnlyEmailField && otpValue.isNotEmpty){
                        otpVerify();
                      }else {
                        sendOtpToMail();
                      }
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
