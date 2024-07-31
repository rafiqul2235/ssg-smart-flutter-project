import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';

class CustomTextFieldWithEdit extends StatelessWidget {

  final double? height;
  final TextEditingController? controller;
  final Function? onClickEditButton;
  final String? hintText;
  final TextInputType? textInputType;
  final int? maxLine;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isPhoneNumber;
  final bool isValidator;
  final String? validatorMessage;
  final Color? fillColor;
  final Color borderColor;
  final TextCapitalization capitalization;
  final bool readOnly;

  CustomTextFieldWithEdit(
      {
        this.height,
        this.controller,
        this.onClickEditButton,
        this.hintText,
        this.textInputType,
        this.maxLine,
        this.focusNode,
        this.nextNode,
        this.textInputAction,
        this.isPhoneNumber = false,
        this.isValidator=false,
        this.validatorMessage,
        this.capitalization = TextCapitalization.none,
        this.fillColor,
        this.borderColor = Colors.black12,
        this.readOnly = false});

  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      height: height?? 45.0,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: isPhoneNumber ? const BorderRadius.only(topRight: Radius.circular(6), bottomRight: Radius.circular(6)) : BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1)) // changes position of shadow
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLine ?? 1,
        textCapitalization: capitalization,
        maxLength: isPhoneNumber ? 15 : null,
        focusNode: focusNode,
        style: readOnly?titilliumRegular.copyWith(color: Theme.of(context).hintColor):titilliumRegular.copyWith(color:Colors.black),
        keyboardType: textInputType ?? TextInputType.text,
        //keyboardType: TextInputType.number,
        initialValue: null,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nextNode);
        },
        //autovalidate: true,
        inputFormatters: [isPhoneNumber ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter],
        validator: (input){
          if(input!.isEmpty){
            if(isValidator){
              return validatorMessage??"";
            }
          }
          return null;

        },
        decoration: InputDecoration(
          suffixIcon: readOnly? IconButton(icon: const Icon(Icons.edit), onPressed:()=> onClickEditButton):
          IconButton(icon: const Icon(Icons.clear), onPressed:()=>controller?.clear()),
          hintText: hintText ?? '',
          filled: fillColor != null,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          isDense: true,
          counterText: '',
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
          hintStyle: titilliumRegular.copyWith(color: Theme.of(context).hintColor),
          errorStyle: const TextStyle(height: 1.5),
          //border: InputBorder.none,
          border: OutlineInputBorder(borderSide:BorderSide(color: borderColor)),
        ),
      ),
    );
  }
}
