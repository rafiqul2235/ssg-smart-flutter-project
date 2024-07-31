import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';

class CustomTextFieldWithExpandablePopup extends StatefulWidget {

  TextEditingController? controller;
  final String? hintTxt;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final TextInputAction? textInputAction;
  final bool isTime;
  final bool readyOnly;
  final bool isHideBackDate;
  final Color borderColor;
  final ValueChanged<String>? onChanged;
  final Function? onSelectedReason;

  CustomTextFieldWithExpandablePopup({this.controller, this.hintTxt, this.focusNode, this.nextNode, this.textInputAction,
    this.onSelectedReason,this.isTime = false,this.readyOnly = false, this.onChanged,this.isHideBackDate = false,this.borderColor = Colors.black12});

  @override
  _CustomTextFieldWithExpandablePopupState createState() => _CustomTextFieldWithExpandablePopupState();
}

class _CustomTextFieldWithExpandablePopupState extends State<CustomTextFieldWithExpandablePopup> {

  //Map<String, List<MarketingIssueItem>> _marketingList = {};

  @override
  void initState() {
    super.initState();
   /* _marketingList = Provider.of<InventoryProvider>(context, listen: false).marketingIssueList as Map<String, List<MarketingIssueItem>>;
    if(widget.controller==null){
      widget.controller = TextEditingController();
    }*/
  }

  // Toggles the password show status
  void _toggle() {
    showDialog (
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        bool isEditedField = false;
        //String selectedItemName = selectedItem;
        return Dialog(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 400,
            child:Column(
              children:[
                Padding(
                  padding:EdgeInsets.only(top: 8.0,bottom: 8.0),
                  child: Text('Select Issue List',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorResources.DARK_BLUE)
                  ),
                ),
                /*Expanded(
                  child: ListView(
                    children:_marketingList.entries.map((e) => ExpansionTile(
                        leading: Icon(Icons.add_card),
                        title: Text(
                          e.key,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        //backgroundColor: Colors.grey.withOpacity(0.2),
                        expandedAlignment: Alignment.center,
                        children: e.value.map((e) => Align(
                          alignment: Alignment.topLeft,
                          child: ListTile(
                            tileColor: Colors.grey.withOpacity(0.2),
                            title: Text(e.name??''),
                            onTap: (){
                              Navigator.pop(context);
                              widget.controller?.text = e.name??'';
                              widget.onSelectedReason!(e);
                            },
                            leading: Icon(Icons.arrow_right),
                          ),
                        )).toList()
                    )).toList(),
                  ),
                )*/
              ]
            )
          ),
        );
      },
    );
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
        validator: (value) {
          return null;
        },
        /*onChanged: (v){if(widget.onChanged!=null){widget.onChanged(v);}},*/
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.arrow_drop_down_outlined,size: 28,),
          hintText: widget.hintTxt ?? '',
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
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

