import 'package:flutter/material.dart';

import '../../data/model/dropdown_model.dart';
import '../../utill/color_resources.dart';
import '../../utill/custom_themes.dart';

class CustomAutoComplete extends StatelessWidget {

  final List<DropDownModel> dropdownItems;
  final String value;
  final String hint;
  final Icon? icon;
  final bool readyOnly;
  final double? dropdownHeight,dropdownWidth;
  final double? height, width;
  final ValueChanged<DropDownModel> onChanged;
  final Function? onClearPressed;
  final Function? onReturnTextController;
  final Color? borderColor;
  final Color? hintColor;

  CustomAutoComplete({
    required this.dropdownItems,
    required this.onChanged,
    this.onClearPressed,
    this.onReturnTextController,
    this.height,
    this.width,
    this.value = '',
    this.hint = '',
    this.readyOnly = false,
    this.icon,
    this.dropdownHeight,
    this.dropdownWidth,
    this.borderColor,
    this.hintColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.0),
      height: height??45,
      width: width??200,
      decoration:BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset:  Offset(0, 1)) // changes position of shadow
        ],
        border: Border.all(
          color: borderColor??Colors.black12,
        ),
      ),
      child: Autocomplete<DropDownModel>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          return dropdownItems
              .where((DropDownModel continent) =>
              continent.name!.toLowerCase().contains(textEditingValue.text.toLowerCase()))
              .toList();
        },

        /*optionsBuilder: (TextEditingValue textEditingValue) {
          return dropdownItems
              .where((DropDownModel continent) => continent.name!.toLowerCase()
              .startsWith(textEditingValue.text.toLowerCase())
          ).toList();
        },*/
        displayStringForOption: (DropDownModel option) => option.name!,

        fieldViewBuilder: (
            BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted){

            if(onReturnTextController!=null) {
              onReturnTextController!(fieldTextEditingController);
            }

            /*fieldTextEditingController.text = value;*/

            fieldTextEditingController.text = value;
            fieldTextEditingController.selection = TextSelection.fromPosition(TextPosition(offset: fieldTextEditingController.text.length));

            return TextField (
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              readOnly: readyOnly,
              //style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                suffixIcon: fieldTextEditingController.text.isEmpty? icon:IconButton(
                  icon: Icon(Icons.clear, color: ColorResources.getChatIcon(context)),
                  onPressed: () {
                    if(readyOnly) {return;}
                    if(onClearPressed!=null){
                      onClearPressed!();
                    }
                    fieldTextEditingController.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
                hintText: hint??'',
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                isDense: true,
                filled: true,
                fillColor: Theme.of(context).highlightColor,
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                hintStyle: titilliumRegular.copyWith(color:hintColor??Theme.of(context).hintColor),
                 //border: InputBorder.none
                border: OutlineInputBorder(borderSide:BorderSide(color:borderColor??Colors.black12)),
            ),
          );
        },
        onSelected: (DropDownModel selection) {
          onChanged(selection);
        },
        optionsViewBuilder: ( BuildContext context,
            AutocompleteOnSelected<DropDownModel> onSelected,
            Iterable<DropDownModel> options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: Container(
                width: dropdownWidth??300,
                height: dropdownHeight??200,
                // color: Colors.white,
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset:  Offset(0, 1)) // changes position of shadow
                  ],
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DropDownModel option = options.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text('${option.name} ${option.description!=null&&option.description!.isNotEmpty?'('+option!.description!+')':''}', style: const TextStyle(color: Colors.black)),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
