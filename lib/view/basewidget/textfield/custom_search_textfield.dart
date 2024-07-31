import 'package:flutter/material.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CustomSearchTextField extends StatefulWidget {

  final TextEditingController? controller;
  final String hintTxt;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isTime;
  final bool readyOnly;

  CustomSearchTextField({this.controller, this.hintTxt='', this.focusNode, this.nextNode, this.textInputAction, this.isTime = false,this.readyOnly = false});

  @override
  _CustomSearchTextFieldState createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {

  // Toggles the password show status
  void _toggle() {
    setState(() {
      DatePicker.showDatePicker(context,
          showTitleActions: true,
          minTime: DateTime(2018, 3, 5),
          maxTime: DateTime(2019, 6, 7), onChanged: (date) {
            print('change $date');
            widget.controller?.text = date.toIso8601String();
          }, onConfirm: (date) {
            print('confirm $date');
          }, currentTime: DateTime.now(), locale: LocaleType.en);
      //_obscureText = !_obscureText;
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
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: Offset(0, 1)) // changes position of shadow
        ],
      ),
      child: TextFormField(
        cursorColor: Theme.of(context).primaryColor,
        readOnly: widget.readyOnly,
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
        validator: (value) {
          return null;
        },
        decoration: InputDecoration(
            suffixIcon: IconButton(icon:const Icon(Icons.search), onPressed: _toggle),
            hintText: widget.hintTxt ?? '',
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
            isDense: true,
            filled: true,
            fillColor: Theme.of(context).highlightColor,
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            hintStyle: titilliumRegular.copyWith(color: Theme.of(context).hintColor),
           // border: InputBorder.none
            border: OutlineInputBorder(borderSide:BorderSide(color: Colors.black12)),
        ),
      ),
    );
  }
}
