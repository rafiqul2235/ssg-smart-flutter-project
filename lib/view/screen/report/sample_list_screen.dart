import 'package:flutter/material.dart';
import '../../../helper/date_converter.dart';
import '../../../localization/language_constrants.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/button/expand_collupse_button.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/textfield/custom_date_time_textfield.dart';
import '../home/dashboard_screen.dart';

class SampleReportListScreen extends StatefulWidget {
  const SampleReportListScreen({Key? key}) : super(key: key);
  @override
  State<SampleReportListScreen> createState() => _SampleReportListScreenState();
}

class _SampleReportListScreenState extends State<SampleReportListScreen> {

  String searchText = '';
  String influencerCategory = 'ALL';
  bool isFirstTime = true;
  bool _isLoading = false;
  bool isExpanded = true;
  int initialPage = 0;
  bool isBackButtonExist = false;
 // List<SalesModel> _salesReprots = [];

  bool _isSearchableData = false;
  int startRecord = 1;
  int totalStockItems = 0;
  int pageSize = 50;
  int pageNo = 0;

  final FocusNode _fromDateFocus = FocusNode();
  final FocusNode _toDateFocus = FocusNode();

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();


  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _fromDateController.text = DateConverter.estimatedDate(DateTime(now.year, now.month, 1));
    _toDateController.text = DateConverter.estimatedDate(now);

    //_loadData();

  }

  @override
  void dispose() {
    super.dispose();
  }

 /* void _loadData() async {

    pageNo += 1;

    setState(() {
      _isLoading = true;
    });

    var _response = await Provider.of<ReportProvider>(context,listen: false).getSalesReportsWithPagination(pageNo,pageSize,'',_fromDateController.text,_toDateController.text);

    if(_response!=null && _response.data !=null){

      //startRecord = ((dataList.pageNo! * dataList.pageSize!) - dataList.pageSize!) + 1;
      totalStockItems = _response.totalRecords!;

      List<SalesModel> salesModels = [];
      for(Map<String, dynamic> json in _response.data!) {
        bool matched = false;
        for(SalesModel salesModel in salesModels) {
          if(json['productCode'] == salesModel.productCode && json['consumerName'] == salesModel.consumerName && json['soldDate'] == salesModel.soldDate){
            matched = true;
            salesModel.addProduct(SalesItem.fromJson(json));
            break;
          }
        }
        if(!matched){
          salesModels.add(SalesModel.fromJson(json));
        }
      }

      if(_isSearchableData) {
        _isSearchableData = false;
        _salesReprots.clear();
        _salesReprots.addAll(salesModels);
      }else{
        if(_response.data!.isNotEmpty) {
          _salesReprots.addAll(salesModels);
        }else{
          _salesReprots.clear();
        }
      }

    }else{
      pageNo -= 1;
      if(pageNo < 0){
        pageNo = 0;
      }
    }
    //_salesReprots
    setState(() {
      _isLoading = false;
    });
  }*/

  void _showReport() async {
    FocusScope.of(context).requestFocus(FocusNode());
    pageNo = 0;
    _isSearchableData = true;
    //_loadData();
  }

  void _showMessage(message, isSuccess){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: isSuccess?Colors.green:Colors.red));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Column (
        children: [
          //Header
          CustomAppBar(
              title: 'Sales Report',
              isBackButtonExist: true,
              secondIcon: Icons.save_alt_outlined,
              onSecondActionPressed:() async {
                _showReport();
              },
              icon: Icons.home,onActionPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));}
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 10.0),
              //physics: BouncingScrollPhysics(),
              children: [
                //isExpanded?SizedBox(height: Dimensions.MARGIN_SIZE_SMALL):SizedBox.shrink(),
                //for Date
                isExpanded?Container(
                  margin: const EdgeInsets.only(left: Dimensions.MARGIN_SIZE_DEFAULT, right: Dimensions.MARGIN_SIZE_DEFAULT),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, color: ColorResources.getPrimary(context), size: 20),
                                  const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                  Text(getTranslated('From_Date', context), style: titilliumRegular)
                                ],
                              ),
                              const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                              CustomDateTimeTextField(
                                controller: _fromDateController,
                                focusNode: _fromDateFocus,
                                nextNode: _toDateFocus,
                                textInputAction: TextInputAction.next,
                                isTime: false,
                                readyOnly: false,
                              )
                            ],
                          )),
                      const SizedBox(width: 15),
                      Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, color: ColorResources.getPrimary(context), size: 20),
                                  const SizedBox(width: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                  Text(getTranslated('To_Date', context), style: titilliumRegular)
                                ],
                              ),
                              const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                              CustomDateTimeTextField(
                                controller: _toDateController,
                                focusNode: _toDateFocus,
                                textInputAction: TextInputAction.next,
                                isTime: false,
                                readyOnly: false,
                              ),
                            ],
                          )),
                    ],
                  ),
                ):SizedBox.shrink(),
                const SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                Row(children: [
                  Expanded(
                    child:isExpanded?Padding(
                      padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                      child: CustomButton(onTap:()=>_showReport(),buttonText: getTranslated('Show_Report', context)),
                    ):Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ExpandCollapseButton(color: ColorResources.getPrimary(context),isNeededSearchIcon: false, onTap: (value){setState(() {isExpanded = value;});}),
                  ),
                ],),
                const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                Divider(
                  color: Colors.grey.withOpacity(0.6),
                  height: 0.0,
                  thickness: 1.0,
                  indent: 0.0,
                  endIndent: 0.0,
                ),
                SizedBox(height: 10,),
                true?
                Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Total Records : ',
                      style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                      children:<TextSpan>[
                        TextSpan(text:'$startRecord - 10} from $totalStockItems', style: titilliumSemiBold.copyWith(color: ColorResources.BLACK)),
                      ],
                    ),
                  ),
                ): const SizedBox.shrink(),
                _isLoading?Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Loading...',style: TextStyle(color:Colors.red,fontSize: 14.0,fontWeight: FontWeight.bold)),
                ):const SizedBox.shrink(),
                /*true?
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0,bottom: 16.0),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _salesReprots.length,
                    itemBuilder:(context, index){
                      return Padding(
                        padding: const EdgeInsets.only(top: 3.0,bottom: 3.0),
                        child: ExpansionTile(
                          collapsedBackgroundColor: Color(0xff043D87).withOpacity(0.8),
                          backgroundColor: const Color(0xff043D87).withOpacity(0.8),
                          textColor: ColorResources.YELLOW,
                          collapsedTextColor: ColorResources.YELLOW,
                          collapsedIconColor: Colors.white,
                         // trailing: null,
                          iconColor: Colors.white,
                          //leading: Text('${index+1}'),
                          title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Text(_salesReprots[index].soldDate??'',
                                              style: titilliumSemiBold.copyWith(
                                                  color: ColorResources.WHITE)),),
                                      Text('${_salesReprots[index].salesType??''}',
                                          style: titilliumSemiBold.copyWith(
                                              color: ColorResources.GREEN))
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Text(_salesReprots[index].productName??'',
                                              style: titilliumSemiBold.copyWith(
                                                  color: ColorResources.GOLD))),
                                      *//*Text('${_salesReprots[index].salesItems?.length}',
                                          style: titilliumSemiBold.copyWith(
                                              color: ColorResources.ORANGE))*//*
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Customer : ',
                                            style: titilliumSemiBold.copyWith(
                                                color: ColorResources.WHITE),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: _salesReprots[index].consumerName??'',
                                                  style: titilliumRegular.copyWith(
                                                      color: ColorResources.GOLD)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Mobile : ',
                                          style: titilliumSemiBold.copyWith(
                                              color: ColorResources.WHITE),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: _salesReprots[index].consumerPhone??'',
                                                style: titilliumRegular.copyWith(
                                                    color: ColorResources.GOLD)),
                                          ],
                                        ),
                                      )
                                    ]),
                                RichText(
                                  text: TextSpan(
                                    text: 'Address : ',
                                    style: titilliumSemiBold.copyWith(
                                        color: ColorResources.WHITE),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: _salesReprots[index].consumerAddress??'',
                                          style: titilliumSemiBold.copyWith(
                                              color: ColorResources.CHAT_ICON_COLOR)),
                                    ],
                                  ),
                                )
                              ]),
                          trailing: Text('${_salesReprots[index].salesItems?.length}',
                              style: titilliumBold.copyWith(
                                  color: ColorResources.YELLOW)),
                          children:[_buildProductList(_salesReprots[index].salesItems!)],
                        ),
                      );
                    },
                  ),
                ): const SizedBox.shrink()*/
               /* ,_isLoading? Padding (
                  padding: const EdgeInsets.all(16.0),
                  child: CustomLoader(color: Theme.of(context).primaryColor),
                ): const SizedBox.shrink(),
                if(_salesReprots.isNotEmpty && _salesReprots.length < totalStockItems)...[
                  !_isLoading && !_isSearchableData? Padding(
                    padding: const EdgeInsets.only(left:16.0,right: 16.0,bottom: 10.0),
                    child: ElevatedButton(
                      onPressed: _loadData,
                      child: Text('Load More ($startRecord - ${_salesReprots.length} from $totalStockItems)'),
                    ),
                  ):SizedBox.shrink(),
                ]else...[
                  !_isLoading || _salesReprots.length < totalStockItems ? NoRecordFounds():const SizedBox.shrink()
                ],*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*Widget _buildProductList(List<SalesItem> salesItem) {
    return ListView.builder(
        padding: const EdgeInsets.all(0.0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: salesItem.length,
        itemBuilder:(context, index){
          return Container(
            margin: const EdgeInsets.only(top: 3.0,bottom: 0.0),
            padding: const EdgeInsets.only(left : 12.0,top: 3.0,bottom: 3.0,right: 12.0),
            decoration: const BoxDecoration(
              color: Color(0xFF517091),
            ),
            child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'SL ',
                      style: titilliumSemiBold.copyWith(
                          color: ColorResources.WHITE),
                      children: <TextSpan>[
                        TextSpan(
                            text: salesItem[index].serial??'',
                            style: titilliumRegular.copyWith(
                                color: ColorResources.GOLD)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Customer ',
                      style: titilliumSemiBold.copyWith(
                          color: ColorResources.WHITE),
                      children: <TextSpan>[
                        TextSpan(
                            text: salesItem[index].consumerType=='1'?'CONSUMER':'TRADER',
                            style: titilliumRegular.copyWith(
                                color: ColorResources.GOLD)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Reg.  ',
                      style: titilliumSemiBold.copyWith(
                          color: ColorResources.WHITE),
                      children: <TextSpan>[
                        TextSpan(
                            text: salesItem[index].isRegistered?'Yes':'No',
                            style: titilliumRegular.copyWith(
                                color: ColorResources.GOLD)),
                      ],
                    ),
                  )
                ]),
          );
        }
    );
  }
*/
}