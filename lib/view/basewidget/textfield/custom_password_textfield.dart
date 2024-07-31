import 'package:flutter/material.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';

class CustomPasswordTextField extends StatefulWidget {

  final TextEditingController? controller;
  final String hintTxt;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final Color? borderColor;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  CustomPasswordTextField({this.controller, this.hintTxt= '', this.focusNode, this.textInputType,
    this.nextNode, this.textInputAction,this.borderColor = Colors.black12,this.onChanged,this.readOnly = false,});

  @override
  _CustomPasswordTextFieldState createState() => _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
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
        border: Border.all(
          color: widget.borderColor??Colors.black12,
        ),
      ),
      child: TextFormField(
        readOnly: widget.readOnly,
        cursorColor: Theme.of(context).primaryColor,
        controller: widget.controller,
        obscureText: _obscureText,
        focusNode: widget.focusNode,
        keyboardType: widget.textInputType ?? TextInputType.text,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        onChanged: (v){if(widget.onChanged!=null)widget.onChanged!(v);},
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
            suffixIcon: IconButton(icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility), onPressed: _toggle),
            hintText: widget.hintTxt ?? '',
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
            isDense: true,
            filled: true,
            fillColor: Theme.of(context).highlightColor,
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            hintStyle: titilliumRegular.copyWith(color: Theme.of(context).hintColor),
            //border: InputBorder.none
            border: OutlineInputBorder(borderSide:BorderSide(color: widget.borderColor??Colors.grey)),
        ),
      ),
    );
  }
}
