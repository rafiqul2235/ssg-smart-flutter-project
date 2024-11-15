import 'package:ssg_smart2/data/model/body/sales_order.dart';
import 'package:ssg_smart2/data/model/response/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:ssg_smart2/helper/date_converter.dart';
import 'package:ssg_smart2/localization/language_constrants.dart';
import 'package:ssg_smart2/provider/notification_provider.dart';
import 'package:ssg_smart2/provider/sales_order_provider.dart';
import 'package:ssg_smart2/utill/color_resources.dart';
import 'package:ssg_smart2/utill/custom_themes.dart';
import 'package:ssg_smart2/utill/dimensions.dart';
import 'package:ssg_smart2/utill/images.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../data/model/dropdown_model.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/button/custom_button_with_icon.dart';
import '../../basewidget/custom_dropdown_button.dart';
import '../../basewidget/custom_loading.dart';
import '../../basewidget/mandatory_text.dart';
import '../../basewidget/textfield/custom_date_time_textfield.dart';
import '../../basewidget/textfield/custom_textfield.dart';
import '../home/dashboard_screen.dart';

class SalesOrderScreen extends StatefulWidget {

  final bool isBackButtonExist;

  const SalesOrderScreen({Key? key, this.isBackButtonExist = true}):super(key: key);

  @override
  State<SalesOrderScreen> createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {

  TextEditingController? _orgNameController;
  TextEditingController? _depositDateController;
  TextEditingController? _qtyController;
  TextEditingController? _deliverySiteDetailController;
  DropDownModel? _selectedCustomer;
  List<DropDownModel> _customerList = [];

  bool _selectCompanyError = false;
  bool isViewOnly = false;

  @override
  void initState() {
    super.initState();
    _orgNameController = TextEditingController();
    _depositDateController = TextEditingController();
    _qtyController = TextEditingController();
    _deliverySiteDetailController = TextEditingController();
    _intData();
  }

  void _intData() async{
    Provider.of<SalesOrderProvider>(context, listen: false).getCustomerAndItemListAndOthers(context);
    Provider.of<SalesOrderProvider>(context, listen: false).getCustomerShipToLocation(context,'2491');
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(children: [

        CustomAppBar(title: 'Sales Order', isBackButtonExist: widget.isBackButtonExist,
          icon: Icons.home,onActionPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));}),

        Expanded(
          child: Consumer<SalesOrderProvider>(
            builder: (context, provider, child) {

              if(_customerList == null || _customerList.isEmpty) {
                _customerList = [];
                _customerList.add(
                    DropDownModel(code: "120", name: "Customer 1"));
              }

              return ListView(
                  children: [
                    provider.isLoading? Padding (
                      padding: const EdgeInsets.only(left: 16.0,right: 10.0,bottom: 5.0),
                      child: CustomTextLoading(),
                    ):const SizedBox.shrink(),
                    // for Org Name
                    Container(
                      margin: const EdgeInsets.only(
                          left: Dimensions.MARGIN_SIZE_DEFAULT,
                          right: Dimensions.MARGIN_SIZE_DEFAULT),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.home_outlined, color: ColorResources.getPrimary(context), size: 20),
                              const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              MandatoryText(text:'Org Name   ', textStyle: titilliumRegular,mandatoryText: '*',)
                            ],
                          ),
                          const SizedBox(width: Dimensions.MARGIN_SIZE_SMALL),
                          Expanded(
                            child: CustomTextField(
                              height: 50,
                              controller: _orgNameController,
                              hintText:'Org Name',
                              borderColor:Colors.black12,
                              textInputType: TextInputType.text,
                              readOnly: true,
                              textInputAction: TextInputAction.done,
                            ),
                          )
                        ],
                      ),
                    ),

                    // for Customer
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.MARGIN_SIZE_SMALL,
                          left: Dimensions.MARGIN_SIZE_DEFAULT,
                          right: Dimensions.MARGIN_SIZE_DEFAULT),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: ColorResources.getPrimary(context), size: 20),
                              const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              MandatoryText(text:'Customer   ', textStyle: titilliumRegular,mandatoryText: '*',)
                            ],
                          ),
                          const SizedBox(width: Dimensions.MARGIN_SIZE_SMALL),
                          Expanded(
                            child:  CustomDropdownButton(
                              buttonHeight: 45,
                              buttonWidth: double.infinity,
                              dropdownWidth: width - 40,
                              hint:'Select Customer',
                              hintColor: Colors.black87,
                              dropdownItems: _customerList,
                              value: _selectedCustomer,
                              buttonBorderColor:Colors.black12,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCustomer = value;
                                 /* _survey = value.name;
                                  _isCampaignError = false;*/
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),

                    // for Customer PO Number
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.MARGIN_SIZE_SMALL,
                          left: Dimensions.MARGIN_SIZE_DEFAULT,
                          right: Dimensions.MARGIN_SIZE_DEFAULT),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.confirmation_num_outlined, color: ColorResources.getPrimary(context), size: 20),
                              const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              MandatoryText(text:'PO Number', textStyle: titilliumRegular,mandatoryText: '',)
                            ],
                          ),
                          const SizedBox(width: Dimensions.MARGIN_SIZE_SMALL),
                          Expanded(
                            child: CustomTextField(
                              height: 50,
                              controller: _orgNameController,
                              hintText:'Enter Customer PO Number',
                              borderColor:Colors.black12,
                              textInputType: TextInputType.text,
                              readOnly: false,
                              textInputAction: TextInputAction.done,
                            ),
                          )
                        ],
                      ),
                    ),
                    // for Customer PO Number
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.MARGIN_SIZE_SMALL,
                          left: Dimensions.MARGIN_SIZE_DEFAULT,
                          right: Dimensions.MARGIN_SIZE_DEFAULT),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.confirmation_num_outlined, color: ColorResources.getPrimary(context), size: 20),
                              const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                              MandatoryText(text:'Order Date ', textStyle: titilliumRegular,mandatoryText: '*',)
                            ],
                          ),
                          const SizedBox(width: Dimensions.MARGIN_SIZE_SMALL),
                          Expanded(
                            child:  CustomDateTimeTextField(
                              controller: _depositDateController,
                              hintTxt: 'Select Deposit Date',
                              //focusNode: _depositDateFocus,
                              borderColor: Colors.black12,
                              textInputAction: TextInputAction.next,
                              isTime: false,
                              readyOnly: false,
                              isHideBackDate: false,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0,right: 16.0,top: 16.0,bottom: 8.0),
                      child: Center(child: Text('- Order Details - ', style: titilliumBold.copyWith(color: Colors.purple,fontSize: 15))),
                    ),

                    // for order / item details
                    Container(
                      color: Colors.red.withOpacity(0.3),
                      margin: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 0.0, bottom: 10.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            headingRowColor: WidgetStateColor.resolveWith(
                                    (states) => Colors.red.withOpacity(0.2)),
                            columnSpacing: 8,
                            horizontalMargin: 2,
                            border: TableBorder.all(width: 0.5, color: Colors.grey),
                            showCheckboxColumn: false,
                            columns: _tableHeader(),
                            rows: [
                              if(!isViewOnly)...[
                                _inputDataRow(),
                              ],
                              if (provider.salesOrder != null &&
                                  provider.salesOrder.orderItemDetail != null) ...[
                                for (var item in provider.salesOrder.orderItemDetail!)
                                  _dataRow(item)
                              ]
                            ]),
                      ),
                    )
                ]
              );
            },
          ),
        ),

        // for Submit Button
        Container(
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.MARGIN_SIZE_LARGE, vertical: Dimensions.MARGIN_SIZE_SMALL),
          child: !Provider.of<SalesOrderProvider>(context).isLoading
              ? Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  child: Text('Clear'),
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
        )//:const SizedBox.shrink(),

      ]),
    );
  }

  /*  Table Header */
  List<DataColumn> _tableHeader() {
    return [
      DataColumn(
          label: Expanded(
            child: Container(
              width: 150,
              height: 50,
              child: Center(
                child: Text(
                  'Item Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                ),
              ),
            ),
          )),
      DataColumn(
          label: Expanded(
            child: Container(
              width: 100,
              height: 50,
              child: Center(
                child: Text(
                  'Qty',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                ),
              ),
            ),
          )),
      DataColumn(
          label: Expanded(
            child: Container(
              width: 100,
              height: 50,
              child: Center(
                child: Text(
                  'Unit Price',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                ),
              ),
            ),
          )),
      DataColumn(
          label: Expanded(
            child: Container(
              width: 100,
              height: 50,
              child: Center(
                child: Text(
                  'Total Price',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                ),
              ),
            ),
          )),
      DataColumn(
          label: Expanded(
            child: Container(
              width: 100,
              height: 50,
              child: Center(
                child: Text(
                  'Ship To Location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                ),
              ),
            ),
          )),
      DataColumn(
          label: Expanded(
            child: Container(
              width: 100,
              height: 50,
              child: Center(
                child: Text(
                  'Vehicle Type',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                ),
              ),
            ),
          )),
      DataColumn(
          label: Expanded(
            child: Container(
              width: 200,
              height: 50,
              child: Center(
                child: Text(
                  'Delivery Site Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                ),
              ),
            ),
          )),
      DataColumn(
          label: Expanded(
            child: Container(
              width: 100,
              height: 50,
              child: Center(
                child: Text(
                  'Action',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
                ),
              ),
            ),
          )),
    ];
  }

  /* Data Row */
  DataRow _dataRow(ItemDetail itemDetails) {
    TextEditingController qtyController = TextEditingController();
    TextEditingController deliverySiteDetailController = TextEditingController();

    qtyController.text = '${itemDetails.quantity}';
    deliverySiteDetailController.text = '${itemDetails.primaryShipTo}';

    return DataRow(cells: [
      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(child: Text('${itemDetails.itemName}')),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(
            child: itemDetails.isEditable
                ? CustomTextField(
              controller: qtyController,
              width: 100,
              height: 50,
              hintText: 'Qty',
              borderColor: Colors.black12,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                itemDetails.quantity = value.isEmpty ? '0' : value;
              },
            ): Text('${itemDetails.quantity}')),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(
            child:Text('${itemDetails.unitPrice}')),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(
            child:Text('${itemDetails.totalPrice}')),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(
            child: Text('${itemDetails.shipToLocation}')),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(
            child: Text('${itemDetails.vehicleType}')),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
        child: Center(
            child: itemDetails.isEditable
                ? CustomTextField(
              controller: deliverySiteDetailController,
              width: 200,
              height: 50,
              maxLine: 3,
              hintText: 'Delivery Site Details',
              borderColor: Colors.black12,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                itemDetails.primaryShipTo =  value;
              },
            ) : Text('${itemDetails.primaryShipTo}')),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.only(right: 2.0, top: 5.0, bottom: 5.0),
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (itemDetails.isEditable) ...[
                  InkWell(
                      onTap: () => _editItemDetail(itemDetails.itemId,
                          itemDetails.itemId, itemDetails.customerId, false),
                      child: Icon(
                        Icons.done,
                        color: Colors.green,
                      ))
                ] else ...[
                  InkWell(
                      onTap: () => _editItemDetail(itemDetails.itemId,
                          itemDetails.orgId, itemDetails.customerId, true),
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                      )),
                  InkWell(
                      onTap: () => _deleteItemDetail(itemDetails.itemId,
                          itemDetails.itemId, itemDetails.customerId),
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ]
              ],
            )),
      ))
    ]);
  }

  /* Input Data Row */
  DataRow _inputDataRow() {

    return DataRow(
        color: WidgetStateColor.resolveWith(
                (states) => Colors.blueAccent.withOpacity(0.3)),
        cells: [
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: CustomDropdownButton(
              buttonHeight: 45,
              buttonWidth: 150,
              dropdownWidth: 200,
              hint: 'Select Item',
              hintColor: Colors.black87,
              dropdownItems: _customerList,
              value: _selectedCustomer,
              buttonBorderColor:
              _selectCompanyError ? Colors.red : Colors.black87,
              onChanged: (value) {
                setState(() {
                  _selectCompanyError = false;
                  _selectedCustomer = value;
                });
              },
            ),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: CustomTextField(
              width: 100,
              height: 50,
              controller: _qtyController,
              hintText: 'Qty',
              //focusNode: _qtyNode,
              //nextNode: _unitPriceNode,
              borderColor: Colors.black12,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: Center(child: Text('632')),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: Center(child: Text('521541')),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: CustomDropdownButton(
              buttonHeight: 45,
              buttonWidth: 150,
              dropdownWidth: 200,
              hint: 'Select Ship Name',
              hintColor: Colors.black87,
              dropdownItems: _customerList,
              value: _selectedCustomer,
              buttonBorderColor:
              _selectCompanyError ? Colors.red : Colors.black87,
              onChanged: (value) {
                setState(() {
                  _selectCompanyError = false;
                  _selectedCustomer = value;
                });
              },
            ),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: CustomDropdownButton(
              buttonHeight: 45,
              buttonWidth: 150,
              dropdownWidth: 200,
              hint: 'Select Vehicle Type',
              hintColor: Colors.black87,
              dropdownItems: _customerList,
              value: _selectedCustomer,
              buttonBorderColor:
              _selectCompanyError ? Colors.red : Colors.black87,
              onChanged: (value) {
                setState(() {
                  _selectCompanyError = false;
                  _selectedCustomer = value;
                });
              },
            ),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: CustomTextField(
              width: 200,
              height: 50,
              maxLine: 3,
              controller: _deliverySiteDetailController,
              hintText: 'Delivery Site Details',
              //focusNode: _qtyNode,
              //nextNode: _unitPriceNode,
              borderColor: Colors.black12,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          )),
          DataCell(Padding(
            padding: const EdgeInsets.only(right: 2.0, top: 5.0, bottom: 5.0),
            child: CustomButtonWithIcon(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                //_addItem();
              },
              color: Colors.transparent,
              buttonText: '',
              icon: Icons.add,
            ),
          ))
        ]);
  }

  _editItemDetail(masterId, detailsId, company, bool bool) {

  }

  _deleteItemDetail(masterId, detailsId, company) {

  }


  _submitButton() {

  }
}
