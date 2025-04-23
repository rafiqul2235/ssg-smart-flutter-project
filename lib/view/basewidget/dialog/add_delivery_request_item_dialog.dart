import 'package:flutter/material.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:provider/provider.dart';
import '../../../data/model/body/sales_order.dart';
import '../../../data/model/dropdown_model.dart';
import '../../../data/model/response/salesorder/item_price.dart';
import '../../../provider/sales_order_provider.dart';
import '../custom_auto_complete.dart';
import '../custom_dropdown_button.dart';
import '../mandatory_text.dart';
import '../textfield/custom_textfield.dart';

class AddDeliveryRequestItemDialog extends StatefulWidget {

  final String positiveButtonText;
  final String headerText;

  AddDeliveryRequestItemDialog({this.positiveButtonText='',this.headerText='Add Item for Delivery Request'});

  @override
  State<AddDeliveryRequestItemDialog> createState() => _AddDeliveryRequestItemDialogState();
}

class _AddDeliveryRequestItemDialogState extends State<AddDeliveryRequestItemDialog> {

  bool _isItemNameFieldError = false,_isShipToLocationFieldError = false,
      _isQtyFieldError = false,_isVehicleTypeFieldError = false,_isVehicleCategoryFieldError = false;
  late FocusNode _nameFocus ;
  late  FocusNode _phoneFocus;
  late  FocusNode _quantityFocus;
  late  FocusNode _addressFocus;
  late  FocusNode _carModelFocus;
  late  FocusNode _deliverySiteDetailsFocus;
  late  FocusNode _deliveryCoLoadFocus;

  late TextEditingController _unitPriceController ;
  late TextEditingController _quantityController ;
  late TextEditingController _coLoadSoController ;
  late TextEditingController _phoneController ;
  late TextEditingController _totalPriceController ;
  late TextEditingController _deliverySiteDetailsController ;

  TextEditingController? _shipToSiteController;

  DropDownModel? _selectedItem;
  bool _customerFieldError = false;
  DropDownModel? _selectedVehicleType;

  List<DropDownModel> _pendingSODropDown=[];
  DropDownModel? _selectedPendingSO;





  List<DropDownModel> _vehicleCatDropDown = [];
  DropDownModel? _selectedVehicleCat;

  String _shipToSiteId = '';
  String _shipToLocation = '';
  String  _primaryShipTo = '';
  String  _salesPersonId = '';
  String _vehicleType ='';
  String _vehicleCate ='';
  int _itemId = 0;
  String  _soNumber='';
  int _selectedItemUnitPrice = 0;

  @override
  void initState() {
    super.initState();

    _unitPriceController = TextEditingController();
    _quantityController = TextEditingController();
    _coLoadSoController = TextEditingController();
    _phoneController = TextEditingController();
    _totalPriceController = TextEditingController();
    _deliverySiteDetailsController = TextEditingController();

    _nameFocus = FocusNode();
    _phoneFocus = FocusNode();
    _quantityFocus = FocusNode();
    _addressFocus = FocusNode();
    _carModelFocus = FocusNode();
    _deliverySiteDetailsFocus = FocusNode();
    _deliveryCoLoadFocus=FocusNode();

    /*String customerName = Provider.of<SalesOrderProvider>(context, listen: false).customerName;
    String customerPhone = Provider.of<SalesOrderProvider>(context, listen: false).customerPhone;
    String customerEmail = Provider.of<SalesOrderProvider>(context, listen: false).customerEmail;
    String customerAddress = Provider.of<SalesOrderProvider>(context, listen: false).customerAddress;
    String carModel = Provider.of<SalesOrderProvider>(context, listen: false).customerCarModel;
    String carRegiNo = Provider.of<SalesOrderProvider>(context, listen: false).customerCarRegiNo;*/

    Provider.of<SalesOrderProvider>(context, listen: false).selectedItemId = '';
    Provider.of<SalesOrderProvider>(context, listen: false).selectedSiteId = '';

    _phoneController.text = '';
    _quantityController.text = '';
    _coLoadSoController.text='';
    _unitPriceController.text = '';
    _totalPriceController.text = '';
    _deliverySiteDetailsController.text = '';
  }

  @override
  void dispose() {
    try{
      _unitPriceController.dispose();
      _quantityController.dispose();
      _coLoadSoController.dispose();
      _phoneController.dispose();
      _totalPriceController.dispose();
      _deliverySiteDetailsController.dispose();

      _nameFocus.dispose();
      _phoneFocus.dispose();
      _quantityFocus.dispose();
      _addressFocus.dispose();
      _carModelFocus.dispose();
      _deliverySiteDetailsFocus.dispose();
      _deliveryCoLoadFocus.dispose();
    }catch(e){}

    super.dispose();
  }

  _onClickOkButton(){

    FocusScope.of(context).requestFocus(FocusNode());

    int error = 0;
    String message = '';
    _isItemNameFieldError = false;
    _isShipToLocationFieldError = false;
    _isQtyFieldError = false;
    _isVehicleTypeFieldError = false;
    _isVehicleCategoryFieldError = false;

    if(_selectedItem == null || _itemId <= 0){
      _isItemNameFieldError = true;
      message = 'Select Item';
      error++;
    }else if(_shipToSiteId.isEmpty){
      _isShipToLocationFieldError = true;
      message = 'Select Ship To Location';
      error++;
    }else if(_quantityController.text.isEmpty){
      _isQtyFieldError = true;
      message = 'Enter Item Qty';
      error++;
    }
    /*else if(_selectedItemUnitPrice<= 0){
      _isQtyFieldError = true;
      message = 'Inactive price, Please contact with Finance department';
      error++;
    }*/
    else if(_vehicleType.isEmpty){
      _isVehicleTypeFieldError = true;
      message = 'Select Vehicle Type';
      error++;
    }
    //Provider.of<SalesOrderProvider>(context, listen: false).clearDeliveryRData();
    setState(() {});

    if(error == 0){

      ItemDetail? itemDetail = ItemDetail();
      itemDetail.soNumber = _soNumber;
      itemDetail.salesPersonId = _salesPersonId;
      itemDetail.customerId = Provider.of<SalesOrderProvider>(context, listen: false).selectedCustId;
      itemDetail.orgId = Provider.of<SalesOrderProvider>(context, listen: false).selectedCustomer?.orgId??'';
      itemDetail.shipToSiteId = _shipToSiteId;
      itemDetail.primaryShipTo = _primaryShipTo;
      itemDetail.shipToLocation = _shipToLocation;
      itemDetail.customerName = Provider.of<SalesOrderProvider>(context, listen: false).selectedCustomer?.customerName??'';

      itemDetail.itemName = _selectedItem?.name;
      itemDetail.itemId = _selectedItem?.id;
      itemDetail.itemUOM = _selectedItem?.code;
      itemDetail.additionalSo = _coLoadSoController.text;
      itemDetail.quantity = _quantityController!=null && _quantityController!.text.isNotEmpty?int.parse(_quantityController!.text):0;
      //itemDetail.unitPrice = int.parse(_unitPriceController.text);
     // itemDetail.totalPrice = double.parse(_totalPriceController.text);
      itemDetail.remarks = _deliverySiteDetailsController?.text;
      itemDetail.primaryShipTo = _shipToSiteId;
      itemDetail.vehicleType = _vehicleType;
      itemDetail.vehicleTypeId = _selectedVehicleType?.id.toString();
      itemDetail.vehicleCate = _vehicleCate;
      itemDetail.vehicleCateId = _selectedVehicleCat?.id.toString();

      Provider.of<SalesOrderProvider>(context, listen: false).addSalesOrderItem(itemDetail);

      //Provider.of<SalesOrderProvider>(context, listen: false).clearDeliveryRData();

    //Provider.of<SalesOrderProvider>(context, listen: false).clearShipToLocationData();
    /* Clear Data */
    _selectedItem = null;
      _soNumber='';
    _shipToLocation='';
      _quantityController.text = '';
      _coLoadSoController.text='';
   // itemPriceInt=0;
   // totalPriceInt=0;
    //_deliverySiteDetailController?.text = '';
    _vehicleType = '';
    _selectedVehicleType = null;
    _vehicleCate = '';
    _selectedVehicleCat = null;

      Navigator.pop(context,true);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _getItemPrice() async {

    if(_selectedItem == null || _itemId <= 0){
      _isItemNameFieldError = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Select Item'),
        backgroundColor: Colors.red,
      ));
    }else if(_shipToSiteId.isEmpty){
      _isShipToLocationFieldError = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Select Ship To Location'),
        backgroundColor: Colors.red,
      ));
    }else{

      final salesProvider = Provider.of<SalesOrderProvider>(context, listen: false);
      ItemPriceModel? itemPriceModel = await salesProvider.getItemPrice(context, Provider.of<SalesOrderProvider>(context, listen: false).selectedCustId,_shipToSiteId,'$_itemId',Provider.of<SalesOrderProvider>(context, listen: false).selectedFreightTerms);
      if(itemPriceModel!=null && itemPriceModel.itemPrice !=null && itemPriceModel.itemPrice > 0){
        _selectedItemUnitPrice = itemPriceModel.itemPrice;
      }

      final String qtyText = _quantityController?.text ?? '0';
      if(qtyText != '' && qtyText != '0' && _selectedItemUnitPrice > 0){
        final int quantity = int.tryParse(qtyText) ?? 0;
        _unitPriceController.text = '$_selectedItemUnitPrice';
        _totalPriceController.text = '${(_selectedItemUnitPrice * quantity).toDouble()}';
      }

    }
  }

  @override
  Widget build(BuildContext context) {

    //double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0,bottom: 10),
      child: Dialog(
        backgroundColor: Theme.of(context).highlightColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          height:height * 0.7 ,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top:Dimensions.PADDING_SIZE_DEFAULT),
              child: Center(child: Text(widget.headerText, style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE))),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:10.0,right: 16.0,top:5.0, bottom: 5.0),
                child: ListView(
                  padding: EdgeInsets.all(0.0),
                  shrinkWrap: true,
                  children: [
                    // for name

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: ColorResources.getPrimary(context), size: 20),
                              //const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              MandatoryText(text:'SO Number', textStyle: titilliumRegular,mandatoryText: '*',),
                            ],
                          ),
                          //const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child: CustomDropdownButton(
                              buttonHeight: 45,
                              buttonWidth: double.infinity,
                              dropdownWidth: 250,
                              hint: 'Select SO Number',
                              hintColor: Colors.black87,
                              dropdownItems: Provider.of<SalesOrderProvider>(context,listen: true).pendingSoDropDown,
                              value: _selectedPendingSO,
                             // buttonBorderColor:_isItemNameFieldError ? Colors.red : Colors.black87,
                              onChanged: (item) {
                                setState(() {
                                  _selectedPendingSO = item;
                                  _soNumber = item?.code??'';

                                  Provider.of<SalesOrderProvider>(context, listen: false).selectedSoNumber = '$_soNumber';

                                  //_getItemPrice();
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: ColorResources.getPrimary(context), size: 20),
                              //const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              MandatoryText(text:'Item Name', textStyle: titilliumRegular,mandatoryText: '*',),
                            ],
                          ),
                          //const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child: CustomDropdownButton(
                              buttonHeight: 45,
                              buttonWidth: double.infinity,
                              dropdownWidth: 250,
                              hint: 'Select Item',
                              hintColor: Colors.black87,
                              dropdownItems: Provider.of<SalesOrderProvider>(context,listen: true).itemsDropDown,
                              value: _selectedItem,
                              buttonBorderColor:_isItemNameFieldError ? Colors.red : Colors.black87,
                              onChanged: (item) {
                                setState(() {
                                  _isItemNameFieldError = false;
                                  _quantityController.text = '';
                                  _selectedItem = item;
                                  _itemId = item?.id??0;
                                  Provider.of<SalesOrderProvider>(context, listen: false).selectedItemId = '$_itemId';

                                  _getItemPrice();
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, color: ColorResources.getPrimary(context), size: 20),
                              //const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              MandatoryText(text:'Ship To Location', textStyle: titilliumRegular,mandatoryText: '*',),
                            ],
                          ),
                          //const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                          CustomAutoComplete(
                            dropdownItems: Provider.of<SalesOrderProvider>(context,listen: true).shipToLocationDropDown,
                            value: _shipToSiteController != null
                                ? _shipToSiteController!.text
                                : '',
                            icon: const Icon(Icons.search),
                            width: double.infinity,
                            dropdownWidth: 250,
                            hint: 'Select Ship Name',
                            hintColor: Colors.black87,
                            borderColor: _isShipToLocationFieldError ? Colors.red : Colors.black87,
                            onReturnTextController: (textController) => _shipToSiteController = textController,
                            onClearPressed: (){
                              Provider.of<SalesOrderProvider>(context, listen: false).selectedSiteId = '';
                              setState(() {
                                _shipToSiteId = '';
                                _quantityController.text = '';
                                _isShipToLocationFieldError = true;});
                              },
                            onChanged: (value) {
                              Provider.of<SalesOrderProvider>(context, listen: false).selectedSiteId = value?.code??'';
                              setState(() {
                                _quantityController.text = '';
                                _isShipToLocationFieldError = false;
                                _shipToSiteId = value?.code??'';
                                _shipToLocation = value?.name??'';
                                _primaryShipTo = value?.nameBl??'';
                                _salesPersonId = value?.description??'';
                                _getItemPrice();
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.money_outlined, color: ColorResources.getPrimary(context), size: 20),
                              //const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              MandatoryText(text:'Quantity', textStyle: titilliumRegular,mandatoryText: '*',)
                            ],
                          ),
                          //const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                          CustomTextField(
                            textInputType: TextInputType.number,
                            focusNode: _quantityFocus,
                            nextNode: _addressFocus,
                            //readOnly: (!_isShipToLocationFieldError && !_isItemNameFieldError) == true ? false : true,
                            borderColor: _isQtyFieldError?Colors.red:Colors.transparent,
                            textInputAction: TextInputAction.next,
                            hintText: 'Enter Qty',
                            controller: _quantityController,
                            onChanged: (value) {
                             if(_isShipToLocationFieldError || _isItemNameFieldError){
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                 content: Text('Select Item And Ship Location'),
                                 backgroundColor: Colors.red,
                               ));
                             }else{
                               print('selectedItemUnitPrice $_selectedItemUnitPrice ');
                               final String qtyText = _quantityController?.text ?? '0';
                               if(qtyText != '' && qtyText != '0' && _selectedItemUnitPrice > 0){
                                 final int quantity = int.tryParse(qtyText) ?? 0;
                                 _unitPriceController.text = '$_selectedItemUnitPrice';
                                 _totalPriceController.text = '${(_selectedItemUnitPrice * quantity).toDouble()}';
                               }else{
                                 _unitPriceController.text = '';
                                 _totalPriceController.text = '';
                               }
                             }
                            }
                          ),
                        ],
                      ),
                    ),
                   /* Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.monetization_on_outlined, color: ColorResources.getPrimary(context), size: 20),
                              const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              Text('Unit Price', style: titilliumRegular)
                            ],
                          ),
                          const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                          CustomTextField(
                            textInputType: TextInputType.number,
                            borderColor: Colors.transparent,
                            textInputAction: TextInputAction.next,
                            hintText: 'Auto',
                            readOnly: true,
                            controller: _unitPriceController,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.monetization_on_outlined, color: ColorResources.getPrimary(context), size: 20),
                              const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              Text('Total Price', style: titilliumRegular)
                            ],
                          ),
                          const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                          CustomTextField(
                            textInputType: TextInputType.number,
                            borderColor: Colors.transparent,
                            textInputAction: TextInputAction.next,
                            hintText: 'Auto',
                            controller: _totalPriceController,
                          ),
                        ],
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.category_outlined, color: ColorResources.getPrimary(context), size: 20),
                              //const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              MandatoryText(text:'Vehicle Type', textStyle: titilliumRegular,mandatoryText: '*',)
                            ],
                          ),
                          //const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                          CustomDropdownButton(
                            buttonHeight: 45,
                            buttonWidth: double.infinity,
                            dropdownWidth: 250,
                            hint: 'Select Vehicle Type',
                            hintColor: Colors.black87,
                            dropdownItems: Provider.of<SalesOrderProvider>(context,listen: true).vehicleTypesDropDown,
                            value: _selectedVehicleType,
                            buttonBorderColor:_isVehicleTypeFieldError ? Colors.red : Colors.black87,
                            onChanged: (value) async{
                              _vehicleCatDropDown =  await Provider.of<SalesOrderProvider>(context, listen: false).getVehicleCategoryByType(value?.code??'');
                              setState((){
                                // _selectCompanyError = false;
                                _vehicleType = value?.name??'';
                                _selectedVehicleType = value;
                                _selectedVehicleCat = null;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.description, color: ColorResources.getPrimary(context), size: 20),
                              //const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              MandatoryText(text:'Vehicle Category', textStyle: titilliumRegular,mandatoryText: '*',)
                            ],
                          ),
                          //const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                          CustomDropdownButton(
                            buttonHeight: 45,
                            buttonWidth: double.infinity,
                            dropdownWidth: 250,
                            hint: 'Select Vehicle Category',
                            hintColor: Colors.black87,
                            dropdownItems: _vehicleCatDropDown,
                            value: _selectedVehicleCat,
                            buttonBorderColor: _isVehicleCategoryFieldError ? Colors.red : Colors.black87,
                            onChanged: (value) {
                              setState(() {
                                // _selectCompanyError = false;
                                _vehicleCate = value?.name??'';
                                _selectedVehicleCat = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.confirmation_num_outlined, color: ColorResources.getPrimary(context), size: 20),
                              //const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              Text('Co-Load SO', style: titilliumRegular)
                            ],
                          ),
                          //const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                          CustomTextField(
                            height: 50,
                            textInputType: TextInputType.text,
                            focusNode: _deliveryCoLoadFocus,
                            borderColor: Colors.transparent,
                            textInputAction: TextInputAction.done,
                            hintText: 'Enter Co-Load SO',
                            maxLine: 2,
                            controller: _coLoadSoController,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.confirmation_num_outlined, color: ColorResources.getPrimary(context), size: 20),
                              //const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              Text('Delivery Site Details', style: titilliumRegular)
                            ],
                          ),
                          //const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                          CustomTextField(
                            height: 50,
                            textInputType: TextInputType.text,
                            focusNode: _deliverySiteDetailsFocus,
                            borderColor: Colors.transparent,
                            textInputAction: TextInputAction.done,
                            hintText: 'Delivery Site Details',
                            maxLine: 2,
                            controller: _deliverySiteDetailsController,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //const Divider(height: Dimensions.PADDING_SIZE_EXTRA_SMALL, color: ColorResources.HINT_TEXT_COLOR),
            Row(children: [
              Expanded(child: TextButton(
                onPressed: () {
                  Provider.of<SalesOrderProvider>(context, listen: false).setSalesOrderItemInformation("", "", "", "","","");
                  Navigator.pop(context,false);
                },
                child: Text(getTranslated('CANCEL', context), style: robotoRegular.copyWith(color: ColorResources.getYellow(context))),
              )),
              Container(
                height: 50,
                width: 2,
                padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: VerticalDivider(width: Dimensions.PADDING_SIZE_EXTRA_SMALL, color: Theme.of(context).hintColor),
              ),
              Expanded(child: TextButton(
                onPressed: () {
                  _onClickOkButton();
                },
                child: Text(getTranslated('ADD_ITEM', context), style: robotoRegular.copyWith(color: ColorResources.getGreen(context))),
              )),
            ]),

          ]),
        ),
      ),
    );
  }
}