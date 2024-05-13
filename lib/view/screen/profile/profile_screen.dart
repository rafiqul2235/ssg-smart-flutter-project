import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/user_provider.dart';
import 'package:ssg_smart2/provider/theme_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:ssg_smart2/view/basewidget/button/custom_button.dart';
import 'package:ssg_smart2/view/basewidget/textfield/custom_password_textfield.dart';
import 'package:ssg_smart2/view/basewidget/textfield/custom_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../utill/app_constants.dart';
import '../home/dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  File? file;
  final _picker = ImagePicker();
  bool firstTime = true;

  String workingAreaName = '';


  void _choose() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 400, maxWidth: 400);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

 /* _updateUserAccount() async {

    String _firstName = _firstNameController.text.trim();
    String _lastName = _firstNameController.text.trim();
    String _email = _emailController.text.trim();
    String _phoneNumber = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

    if(Provider.of<UserProvider>(context, listen: false).userInfoModel?.firstName == _firstNameController.text
        && Provider.of<UserProvider>(context, listen: false).userInfoModel?.lastName == _lastNameController.text
        && Provider.of<UserProvider>(context, listen: false).userInfoModel?.photoUrl == _phoneController.text && file == null
        && _passwordController.text.isEmpty && _confirmPasswordController.text.isEmpty) {
      //showCustomSnackBar('Change something to update', context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Change something to update'), backgroundColor: ColorResources.RED));
    }else if (_firstName.isEmpty || _lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('NAME_FIELD_MUST_BE_REQUIRED', context)), backgroundColor: ColorResources.RED));
    }else if (_email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('EMAIL_MUST_BE_REQUIRED', context)), backgroundColor: ColorResources.RED));
    }else if (_phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('PHONE_MUST_BE_REQUIRED', context)), backgroundColor: ColorResources.RED));
    } else if((_password.isNotEmpty && _password.length < 3)
        || (_confirmPassword.isNotEmpty && _confirmPassword.length < 3)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Password should be at least 3 character'), backgroundColor: ColorResources.RED));
    } else if(_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('PASSWORD_DID_NOT_MATCH', context)), backgroundColor: ColorResources.RED));
    }else {

      UserInfoModel updateUserInfoModel = Provider.of<UserProvider>(context, listen: false).userInfoModel!;

      updateUserInfoModel.method = 'put';
      updateUserInfoModel.firstName = _firstNameController.text ?? "";
      updateUserInfoModel.lastName = _lastNameController.text ?? "";
      updateUserInfoModel.mobileNo = _phoneController.text ?? '';
      updateUserInfoModel.email = _emailController.text ?? '';
      updateUserInfoModel.address = '';
      String pass = _passwordController.text ?? '';

      await Provider.of<UserProvider>(context, listen: false).updateUserInfo(
        updateUserInfoModel, pass, file, Provider.of<AuthProvider>(context, listen: false).getUserToken(),
      ).then((response) {
        Provider.of<UserProvider>(context, listen: false).hideLoading();
        if(response.isSuccess) {
          Provider.of<UserProvider>(context, listen: false).getUserInfo(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated Successfully'), backgroundColor: Colors.green));
          _passwordController.clear();
          _confirmPasswordController.clear();
          setState(() {});
        }else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message), backgroundColor: Colors.red));
        }
      });
    }
  }
*/
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).resetLoading();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<UserProvider>(
              builder: (context, profile, child) {

                if(firstTime) {
                  _firstNameController.text = profile.userInfoModel?.firstName ?? '';
                  _lastNameController.text = profile.userInfoModel?.lastName??'';
                  _emailController.text = profile.userInfoModel?.email??'';
                  _phoneController.text = profile.userInfoModel?.mobileNo??'';
                  firstTime = false;
                }


                return Stack(
                  clipBehavior: Clip.none,
                  children: [

                    Image.asset(
                      Images.toolbar_background, fit: BoxFit.fill, height: height / 2.5,
                      color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : null,
                    ),

                    Container(
                      padding: EdgeInsets.only(top: 35, left: 15),
                      child: Row(children: [
                        CupertinoNavigationBarBackButton(
                          onPressed: () => Navigator.of(context).pop(),
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(getTranslated('PROFILE', context), style: titilliumRegular.copyWith(fontSize: 20, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        IconButton(
                          icon: const Icon(Icons.home, size: Dimensions.ICON_SIZE_DEFAULT, color: Colors.white),
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));
                          },
                        )
                      ]),
                    ),

                    Container(
                      padding: EdgeInsets.only(top: 55),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(color: Colors.white, width: 3),
                                  shape: BoxShape.circle,
                                ),
                                child: InkWell(
                                  onTap: _choose,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: file == null
                                            ? FadeInImage.assetNetwork(
                                                placeholder: Images.placeholder, width: 100, height: 100, fit: BoxFit.cover,
                                                /*image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profile.userInfoModel!=null?profile.userInfoModel.image ?? '':''}''',*/
                                                image: '${AppConstants.BASE_URL}/${profile.userInfoModel?.photoUrl??""}',
                                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, width: 100, height: 100, fit: BoxFit.cover),
                                              )
                                            : Image.file(file!, width: 100, height: 100, fit: BoxFit.fill),
                                      ),
                                      const Positioned(
                                        bottom: 0,
                                        right: -10,
                                        child: CircleAvatar(
                                          backgroundColor: ColorResources.LIGHT_SKY_BLUE,
                                          radius: 14,
                                          child: Icon(Icons.edit, color: ColorResources.WHITE, size: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                '${profile.userInfoModel!=null?profile.userInfoModel?.firstName??'':'Saiful'} ${profile.userInfoModel!=null?profile.userInfoModel?.lastName??'':'Islam'}',
                                style: titilliumSemiBold.copyWith(color: ColorResources.WHITE, fontSize: 16.0),
                              ),

                              //Text('$workingAreaName :', style: titilliumRegular.copyWith(color: ColorResources.WHITE)):SizedBox.shrink(),
                            ],
                          ),

                          SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorResources.getIconBg(context),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                                    topRight: Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                                  )),
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                children: [
                                  //for name
                                  Container(
                                    margin: EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.person, color: ColorResources.getPrimary(context), size: 20),
                                                const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                                Text(getTranslated('FIRST_NAME', context), style: titilliumRegular)
                                              ],
                                            ),
                                            const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                            CustomTextField(
                                              textInputType: TextInputType.name,
                                              focusNode: _fNameFocus,
                                              nextNode: _lNameFocus,
                                              hintText: profile.userInfoModel!=null?profile.userInfoModel?.firstName ?? '':'',
                                              controller: _firstNameController,
                                            ),
                                          ],
                                        )),
                                        SizedBox(width: 15),
                                        Expanded(
                                            child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.person, color: ColorResources.getPrimary(context), size: 20),
                                                const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                                Text(getTranslated('LAST_NAME', context), style: titilliumRegular)
                                              ],
                                            ),
                                            const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                            CustomTextField(
                                              textInputType: TextInputType.name,
                                              focusNode: _lNameFocus,
                                              nextNode: _emailFocus,
                                              hintText: profile.userInfoModel!=null?profile.userInfoModel?.lastName??'':'',
                                              controller: _lastNameController,
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),

                                  // for Email
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: Dimensions.MARGIN_SIZE_DEFAULT,
                                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.alternate_email, color: ColorResources.getPrimary(context), size: 20),
                                            const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL,),
                                            Text(getTranslated('EMAIL', context), style: titilliumRegular)
                                          ],
                                        ),
                                        const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                        CustomTextField(
                                          textInputType: TextInputType.emailAddress,
                                          focusNode: _emailFocus,
                                          nextNode: _phoneFocus,
                                          hintText: profile.userInfoModel!=null?profile.userInfoModel?.email ?? '':'',
                                          controller: _emailController,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // for Phone No
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: Dimensions.MARGIN_SIZE_DEFAULT,
                                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.call, color: ColorResources.getPrimary(context), size: 20),
                                            const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                            Text(getTranslated('PHONE_NO', context), style: titilliumRegular)
                                          ],
                                        ),
                                        const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                        CustomTextField(
                                          textInputType: TextInputType.number,
                                          focusNode: _phoneFocus,
                                          hintText: profile.userInfoModel!=null?profile.userInfoModel?.mobileNo ?? "":'',
                                          nextNode: _addressFocus,
                                          controller: _phoneController,
                                          isPhoneNumber: true,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // for Password
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: Dimensions.MARGIN_SIZE_DEFAULT,
                                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.lock_open, color: ColorResources.getPrimary(context), size: 20),
                                            const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                            Text(getTranslated('PASSWORD', context), style: titilliumRegular)
                                          ],
                                        ),
                                        const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                        CustomPasswordTextField(
                                          controller: _passwordController,
                                          focusNode: _passwordFocus,
                                          nextNode: _confirmPasswordFocus,
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // for  re-enter Password
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: Dimensions.MARGIN_SIZE_DEFAULT,
                                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.lock_open, color: ColorResources.getPrimary(context), size: 20),
                                            const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                            Text(getTranslated('RE_ENTER_PASSWORD', context), style: titilliumRegular)
                                          ],
                                        ),
                                        const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                        CustomPasswordTextField(
                                          controller: _confirmPasswordController,
                                          focusNode: _confirmPasswordFocus,
                                          textInputAction: TextInputAction.done,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.MARGIN_SIZE_LARGE, vertical: Dimensions.MARGIN_SIZE_SMALL),
                            child: !Provider.of<UserProvider>(context).isLoading
                                ? CustomButton(onTap: (){}, buttonText: getTranslated('UPDATE_PROFILE', context))
                                : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
