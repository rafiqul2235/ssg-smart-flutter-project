import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/data/model/body/login_model.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/auth_provider.dart';
import 'package:ssg_smart2/provider/banner_provider.dart';
import 'package:ssg_smart2/provider/notification_provider.dart';
import 'package:ssg_smart2/provider/user_provider.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/view/basewidget/button/custom_button.dart';
import 'package:ssg_smart2/view/basewidget/textfield/custom_password_textfield.dart';
import 'package:ssg_smart2/view/basewidget/textfield/custom_textfield.dart';
import 'package:ssg_smart2/view/screen/auth/forget_password_screen.dart';
import 'package:provider/provider.dart';
import '../../../../data/repository/auth_repo.dart';
import '../../../basewidget/animated_custom_dialog.dart';
import '../../../basewidget/my_dialog.dart';
import '../../home/dashboard_screen.dart';
import 'dart:developer' as developer;

class SignInWidget extends StatefulWidget {

  const SignInWidget({Key? key}) : super(key: key);

  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {

  TextEditingController? _userController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;

  bool _isErrorUserCode = false;
  bool _isErrorPassword = false;

  final FocusNode _userNode = FocusNode();
  final FocusNode _passNode = FocusNode();

  LoginModel? loginBody;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _userController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _userController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  void loginUser() async {

    _isErrorUserCode = false;
    _isErrorPassword = false;

    FocusScope.of(context).requestFocus(FocusNode());

    if (_formKeyLogin!.currentState!.validate()) {

      // _userController!.text = '390';
      // _passwordController!.text = '123456';

      String _user = _userController!.text.trim();
      String _password = _passwordController!.text.trim();


      if (_user.isEmpty) {

        setState(() {
          _isErrorUserCode = true;
          FocusScope.of(context).requestFocus(_userNode);
        });

        _showMessage(getTranslated('USER_MUST_BE_REQUIRED', context), true);

      }else if (_password.isEmpty) {

        setState(() {
          _isErrorPassword = true;
          FocusScope.of(context).requestFocus(_passNode);
        });

        _showMessage(getTranslated('PASSWORD_MUST_BE_REQUIRED', context), true);

      }else {

        loginBody = LoginModel();
        loginBody?.userName = _user;
        loginBody?.password = _password;


        /* developer.log(
        'log me',
        name: 'my.app.category',
        error: loginBody?.toLoginBodyJson()
       );*/


       // var loginControlerObj = AuthProvider(AuthRepo(Dio(),Share));

        Provider.of<AuthProvider>(context,listen: false).login(context, loginBody!, (bool isSuccess,String message){

          if (isSuccess) {

            //Call User Menu API
            Provider.of<UserProvider>(context,listen: false).getUserMenu(context);

            Timer(const Duration(seconds: 1), () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>  DashBoardScreen()), (route) => false);
            });

          } else {
            showAnimatedDialog(context, MyDialog(
              icon: Icons.warning,
              description: message,
              rotateAngle: 0,
              positionButtonTxt: 'Ok',
              //negativeButtonTxt: 'cancel',
              isFailed: true, title: '',
            ), dismissible: false);

          }
        });

       /* Timer(const Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (_) =>
          const DashBoardScreen(willAppearAppVersionUpdateDialog: false,
              isSoftUpdate: false, isNeededUpdateBaseLocation: false)), (
              route) => false);
        });*/
      }

    }
  }

  _showMessage(String message, bool isError){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError?Colors.red:Colors.green,
    ));
  }

  loginCallback(bool isSuccess,String message) async {

    if (isSuccess) {
        //Provider.of<UserProvider>(context, listen: false).getUserDefault();
        Timer(const Duration(seconds: 1), () {
           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>  DashBoardScreen()), (route) => false);
        });

    } else {
       showAnimatedDialog(context, MyDialog(
        icon: Icons.warning,
        description: message,
        rotateAngle: 0,
        positionButtonTxt: 'Ok',
        //negativeButtonTxt: 'cancel',
        isFailed: true, title: '',
      ), dismissible: false);

    }
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKeyLogin,
      child: Column(
        children: [
          // for User Name
          Container(
              margin:
              const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_LARGE, right: Dimensions.MARGIN_SIZE_LARGE, bottom: Dimensions.MARGIN_SIZE_SMALL),
              child: CustomTextField(
                hintText: getTranslated('ENTER_YOUR_USER', context),
                //validatorMessage: 'Field Empty',
                //isValidator: true,
                borderColor: _isErrorUserCode?Colors.red:Colors.black12,
                focusNode: _userNode,
                nextNode: _passNode,
                textInputType: TextInputType.emailAddress,
                controller: _userController,
                textInputAction: TextInputAction.next,
              )),

          // for Password
          Container(
              margin:
              const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_LARGE, right: Dimensions.MARGIN_SIZE_LARGE, bottom: Dimensions.MARGIN_SIZE_DEFAULT),
              child: CustomPasswordTextField(
                hintTxt: getTranslated('ENTER_YOUR_PASSWORD', context),
                borderColor: _isErrorPassword?Colors.red:Colors.black12,
                textInputAction: TextInputAction.done,
                focusNode: _passNode,
                controller: _passwordController,
              )),

          // for remember and forgetpassword
          Container(
            margin: const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_SMALL, right: Dimensions.MARGIN_SIZE_SMALL),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgetPasswordScreen())),
                  child: Text(getTranslated('FORGET_PASSWORD', context), style: titilliumRegular.copyWith(color: Theme.of(context).primaryColor)),
                ),
              ],
            ),
          ),

          // for signin button
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
            child: Provider.of<AuthProvider>(context).isLoading!
                ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ):CustomButton(onTap: loginUser, buttonText: getTranslated('SIGN_IN', context)),
          ),

        ],
      ),
    );
  }

}
