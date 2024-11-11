import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/provider/user_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/view/basewidget/button/custom_button.dart';
import 'package:ssg_smart2/view/basewidget/mandatory_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/basewidget/textfield/custom_textfield.dart';
import 'package:ssg_smart2/view/screen/attachment/attachment_provider.dart';
import '../../../data/model/dropdown_model.dart';
import '../../../provider/leave_provider.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/custom_dropdown_button.dart';
import '../../basewidget/textfield/custom_date_time_textfield.dart';
import '../home/dashboard_screen.dart';

class AITAutomationScreen extends StatefulWidget {
  final bool isBackButtonExist;

  const AITAutomationScreen({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  _AITAutomationScreenState createState() => _AITAutomationScreenState();
}

class _AITAutomationScreenState extends State<AITAutomationScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool _isButtonDisable = false;

  final FocusNode _customerFocus = FocusNode();
  final FocusNode _challanNoFocus = FocusNode();
  final FocusNode _invoiceNoFocus = FocusNode();
  final FocusNode _aitAmountFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();

  final TextEditingController _challanNoController = TextEditingController();
  final TextEditingController _invoiceAmountController =
      TextEditingController();
  final TextEditingController _aitAmountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // image picker variable
  final ImagePicker _picker = ImagePicker();
  XFile? _attachmentFile;

  final List<DropDownModel> _customer = [
    DropDownModel(id: 1, name: "Customer A"),
    DropDownModel(id: 2, name: "Customer B"),
    DropDownModel(id: 3, name: "Customer C"),
    DropDownModel(id: 4, name: "Customer D"),
  ];

  // file picker variable
  List<PlatformFile>? _attachmentFiles = [];
  final List<String> _allowedExtensions = [
    'pdf',
    'doc',
    'docx',
    'jpg',
    'jpeg',
    'png'
  ];

  final int _maxFileSize = 5 * 1024 * 1024;

  String workingAreaName = '';

  DropDownModel? selectedCustomerName;

  bool isCustomerNameFieldError = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Provider.of<UserProvider>(context, listen: false).resetLoading();

    Provider.of<LeaveProvider>(context, listen: false).getLeaveType(context);

    _intData();
  }

  _intData() async {
    setState(() {});
  }

// Method to handle file picking
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
        allowMultiple: true,
        withData: true, // Keep file data in memory
      );

      if (result != null) {
        setState(() {
          _attachmentFiles!.addAll(result.files);
        });
      }
    } catch (e) {
      print("Error:$e");
    }
  }

  void _onClickSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isButtonDisable = true;
      });
      Map<String, dynamic> data = {
        'customerName' : selectedCustomerName?.name,
        'challanNo' : _challanNoController.text,
        'invoiceAmount' : _invoiceAmountController.text,
        'aitAmount' : _aitAmountController.text,
        'date' : _dateController.text,
        'attachments' : _attachmentFiles?.map((file) => File(file.path!)).toList()
      };
      final provider = Provider.of<AttachmentProvider>(context, listen: false);
      try {
        await provider.submitAITAutomationForm(data);
        if (provider.aitResponse!.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Successfully Done")),
          );
        }
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error occured")),
        );
        setState(() {
          _isButtonDisable = false;
        });
      }
    }
  }

  void _removeFile(int index) {
    setState(() {
      _attachmentFiles?.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            CustomAppBar(
                title: 'AIT Automation',
                isBackButtonExist: widget.isBackButtonExist,
                icon: Icons.home,
                onActionPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const DashBoardScreen()));
                }),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorResources.getIconBg(context),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              topRight: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                            )),
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          physics: BouncingScrollPhysics(),
                          children: [
                            // for leave type
                            Consumer<LeaveProvider>(
                                builder: (context, leaveProvider, child) {
                              return Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.streetview,
                                            color: ColorResources.getPrimary(
                                                context),
                                            size: 20),
                                        const SizedBox(
                                          width: Dimensions
                                              .MARGIN_SIZE_EXTRA_SMALL,
                                        ),
                                        MandatoryText(
                                            text: 'Customer Name',
                                            mandatoryText: '*',
                                            textStyle: titilliumRegular)
                                      ],
                                    ),
                                    const SizedBox(
                                        height: Dimensions.MARGIN_SIZE_SMALL),
                                    CustomDropdownButton(
                                      buttonHeight: 45,
                                      buttonWidth: double.infinity,
                                      dropdownWidth: width - 40,
                                      hint: 'Select Customer',
                                      //hintColor: Colors.black: null,
                                      dropdownItems: _customer,
                                      value: selectedCustomerName,
                                      buttonBorderColor:
                                          isCustomerNameFieldError
                                              ? Colors.red
                                              : Colors.black12,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCustomerName = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),

                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.numbers_outlined,
                                        color:
                                            ColorResources.getPrimary(context),
                                        size: 20,
                                      ),
                                      Text('Challan Number')
                                    ],
                                  ),
                                  const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL,
                                  ),
                                  CustomTextField(
                                    textInputType: TextInputType.number,
                                    controller: _challanNoController,
                                    focusNode: _challanNoFocus,
                                  )
                                ],
                              ),
                            ),

                            // Date Selection Row (Horizontal Layout)
                            Container(
                              margin: EdgeInsets.only(top: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Start Date
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.newspaper,
                                                color:
                                                    ColorResources.getPrimary(
                                                        context),
                                                size: 20),
                                            const SizedBox(
                                                width: Dimensions
                                                    .MARGIN_SIZE_EXTRA_SMALL),
                                            MandatoryText(
                                                text: 'Invoice Amount',
                                                mandatoryText: '*',
                                                textStyle: titilliumRegular)
                                          ],
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.MARGIN_SIZE_SMALL),
                                        CustomTextField(
                                          textInputType: TextInputType.number,
                                          controller: _invoiceAmountController,
                                          focusNode: _invoiceNoFocus,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16.0),

                                  // End Date
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.money,
                                                color:
                                                    ColorResources.getPrimary(
                                                        context),
                                                size: 20),
                                            const SizedBox(
                                                width: Dimensions
                                                    .MARGIN_SIZE_EXTRA_SMALL),
                                            MandatoryText(
                                                text: 'AIT Amount',
                                                mandatoryText: '*',
                                                textStyle: titilliumRegular)
                                          ],
                                        ),
                                        const SizedBox(
                                            height:
                                                Dimensions.MARGIN_SIZE_SMALL),
                                        CustomTextField(
                                          textInputType: TextInputType.number,
                                          controller: _aitAmountController,
                                          focusNode: _aitAmountFocus,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        size: 20,
                                        color:
                                            ColorResources.getPrimary(context),
                                      ),
                                      Text('Date')
                                    ],
                                  ),
                                  const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL,
                                  ),
                                  CustomDateTimeTextField(
                                    textInputAction: TextInputAction.next,
                                    controller: _dateController,
                                    focusNode: _dateFocus,
                                    isTime: false,
                                  )
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 5.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.attach_file,
                                            color: ColorResources.getPrimary(
                                                context),
                                            size: 20),
                                        const SizedBox(
                                            width: Dimensions
                                                .MARGIN_SIZE_EXTRA_SMALL),
                                        Text('Attachment',
                                            style: titilliumRegular),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: Dimensions.MARGIN_SIZE_SMALL),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black26),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Allowed file types: ${_allowedExtensions.join(', ')}',
                                              style: titilliumRegular.copyWith(
                                                color: Colors.grey[700],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Column(
                                              children: _attachmentFiles != null
                                                  ? _attachmentFiles!
                                                      .map((file) {
                                                      return ListTile(
                                                        title: Text(
                                                          file.name,
                                                          maxLines: 1,
                                                        ),
                                                        subtitle: Text(
                                                          'Size: ${file.size}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        trailing: IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _attachmentFiles!
                                                                    .remove(
                                                                        file);
                                                              });
                                                            },
                                                            icon: Icon(
                                                              Icons.clear,
                                                              color: Colors.red,
                                                            )),
                                                      );
                                                    }).toList()
                                                  : [
                                                      ListTile(
                                                        title: Text(
                                                          'No file chosen',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[700]),
                                                        ),
                                                      )
                                                    ]),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton.icon(
                                              onPressed: _pickFile,
                                              icon: Icon(Icons.upload_file),
                                              label: Text(_attachmentFiles!.isEmpty ?'Choose Files':'Add more'),
                                              style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: Dimensions.MARGIN_SIZE_LARGE,
                          vertical: Dimensions.MARGIN_SIZE_SMALL),
                      child: !Provider.of<AttachmentProvider>(context).isLoading
                          ? CustomButton(
                              onTap: _isButtonDisable
                                ? null
                                : _onClickSubmit,
                              buttonText: 'SUBMIT'
                      )
                          : Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor))),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ));
  }
}
