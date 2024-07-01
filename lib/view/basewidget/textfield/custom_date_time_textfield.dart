import 'package:flutter/material.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import '../../../helper/date_converter.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CustomDateTimeTextField extends StatefulWidget {

  final TextEditingController? controller;
  final String hintTxt;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isTime;
  final bool readyOnly;
  final bool isHideBackDate;
  final Color borderColor;
  final ValueChanged<String>? onChanged;
  final DateTime? minTime;
  final DateTime? maxTime;
  final FormFieldValidator<String>? validator;


  CustomDateTimeTextField({this.controller, this.hintTxt= '', this.focusNode,this.minTime,this.maxTime, this.validator, this.nextNode, this.textInputAction,
    this.isTime = false,this.readyOnly = false, this.onChanged,this.isHideBackDate = false,this.borderColor = Colors.black12});

  @override
  _CustomDateTimeTextFieldState createState() => _CustomDateTimeTextFieldState();
}

class _CustomDateTimeTextFieldState extends State<CustomDateTimeTextField> {

  // Toggles the password show status
  void _toggle() {

    setState(() {
      if(widget.isTime){
        /*DatePicker.showTimePicker(context, showTitleActions: true,
            onChanged: (date) {
              print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
              widget.controller.text = DateConverter.estimatedTime(date);
            }, onConfirm: (date) {
              print('confirm $date');
            }, currentTime: DateTime.now());*/

          DatePicker.showTime12hPicker(context,
              showTitleActions: true,
            onChanged: (date) {
              /*print('change $date in time zone ' +
                  date.timeZoneOffset.inHours.toString());*/
              var starData = DateConverter.estimatedTime(date);
              widget.controller?.text = starData;
              if(widget.onChanged!=null){widget.onChanged!(starData);}
            }, onConfirm: (date) {
              //print('confirm $date');
            },
            currentTime: DateTime.now(),
            //pickerModel: CustomPicker(currentTime: DateTime.now()),
            locale: LocaleType.en);

      }else {

        DatePicker.showDatePicker(context,
            showTitleActions: true,
            minTime: widget.isHideBackDate?DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day):widget.minTime,
            maxTime: widget.isHideBackDate?DateTime(DateTime.now().year +1, 12, 31):widget.maxTime,
            onChanged: (date) {
              var starData = DateConverter.estimatedDate(date);
              widget.controller?.text = starData;
              if(widget.onChanged!=null){widget.onChanged!(starData);}
            },
            onConfirm: (date) {
              //print('confirm $date');
            },
            currentTime:widget.controller!=null&&widget.controller!.text.isNotEmpty?DateConverter.estimatedDateBy(widget.controller!.text):DateTime.now(),
            locale: LocaleType.en);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45.0,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: widget.borderColor,
        ),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1)) // changes position of shadow
        ],
      ),
      child: TextFormField(
        cursorColor: Theme.of(context).primaryColor,
        readOnly: true,
        onTap: ()=> widget.readyOnly?null:_toggle(),
        controller: widget.controller,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          setState(() {
            widget.textInputAction == TextInputAction.done
                ? FocusScope.of(context).consumeKeyboardToken()
                : FocusScope.of(context).requestFocus(widget.nextNode);
          });
        },
        validator: widget.validator,
        // validator: (value) {
        //   return null;
        // },
        /*onChanged: (v){if(widget.onChanged!=null){widget.onChanged(v);}},*/
        decoration: InputDecoration(
          suffixIcon: Icon(widget.isTime? Icons.access_time: Icons.date_range),
          hintText: widget.hintTxt ?? '',
          contentPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
          isDense: true,
          filled: true,
          fillColor: Theme.of(context).highlightColor,
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          hintStyle: titilliumRegular.copyWith(color: Theme.of(context).hintColor),
          // border: InputBorder.none
          border: OutlineInputBorder(borderSide:BorderSide(color: widget.borderColor)),
        ),
      ),
    );
  }
}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        this.currentLeftIndex(),
        this.currentMiddleIndex(),
        this.currentRightIndex())
        : DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        this.currentLeftIndex(),
        this.currentMiddleIndex(),
        this.currentRightIndex());
  }
}
