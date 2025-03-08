import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/approval_flow.dart';
import 'package:ssg_smart2/data/model/response/cashpayment_model.dart';
import 'package:ssg_smart2/data/model/response/rsm_approval_flow_model.dart';
import 'package:ssg_smart2/provider/approval_provider.dart';
import 'package:ssg_smart2/provider/cashpayment_provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';
import 'package:ssg_smart2/view/screen/msd_report/msd_report_model.dart';
import 'package:ssg_smart2/view/screen/salesOrder/confirmation_dialog_soBooked.dart';
import '../../../data/model/response/user_info_model.dart';
import '../../../provider/user_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../basewidget/animated_custom_dialog.dart';
import '../../basewidget/custom_app_bar.dart';
import '../../basewidget/mandatory_text.dart';
import '../../basewidget/my_dialog.dart';
import '../cashpayment/cash_pay_akg_history_screen.dart';

class MsdNotificationScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const MsdNotificationScreen({Key? key, this.isBackButtonExist = true})
      : super(key: key);
  @override
  State<MsdNotificationScreen> createState() => _MsdNotificationScreenState();
}

class _MsdNotificationScreenState extends State<MsdNotificationScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();
  String? employeeNumber;

  // final TextEditingController _commentController = TextEditingController();
  final Map<String, TextEditingController> _commentControllers = {};

  List<String> _reportTypes = [
    'Collection',
    'Sales',
    'Delivery Request',
    'Pending SO',
    'Customer PI, Cr. Memo etc.'
  ];
  String? _selectedReportType;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final FocusNode _startDateFocus = FocusNode();
  final FocusNode _endDateFocus = FocusNode();


  @override
  void initState() {
    super.initState();
    _intData();
    DateTime now = DateTime.now();
    _endDateController.text = DateFormat('dd-MM-yyyy').format(now);
    /*DateTime startDate = DateTime(now.year, now.month - 1, 26);
    if (now.day >= 26) {
      startDate = DateTime(now.year, now.month, 26);
    }*/
    _startDateController.text = DateFormat('dd-MM-yyyy').format(now);

   /* WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceProvider>(context, listen: false)
          .clearAttendanceData();
    });*/

  }

  void _reloadPage() {
    setState(() {
      _intData();
    });
  }
  @override
  void dispose() {
    _commentControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  _intData() async {
    setState(() {});
    UserInfoModel? userInfoModel = Provider.of<UserProvider>(context,listen: false).userInfoModel;
    employeeNumber = userInfoModel?.employeeNumber ?? '';
    //Provider.of<CashPaymentProvider>(context, listen: false).fetchSalesNotification("100002083","","2024-05-26","2024-06-30","Sales");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'MSD Report for Salesperson ',
          isBackButtonExist: widget.isBackButtonExist
      ),

      body: Consumer<CashPaymentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
         else if (provider.error.isNotEmpty) {
            return NoInternetOrDataScreen(isNoInternet: false);
          }
          else {
            return ListView.builder(
              itemCount: provider.salesNotification.length,
              itemBuilder: (context, index) {
                final approval = provider.salesNotification[index];
                //_commentControllers.putIfAbsent(approval.salesorderMstId, () => TextEditingController());
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.blue,
                    child: InkWell(
                      splashColor: Colors.blue.withOpacity(0.1),
                      onTap: () {
                        debugPrint("Card is pressed");
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          top(context,approval),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget top(BuildContext context,MsdReportModel msdReportModel) {

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[50]!, Colors.orange[50]!],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${msdReportModel.msg_date}",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, color: Colors.black),
                    ),
                    Text(
                      "${msdReportModel.msg}",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
             // SizedBox(height: 18),
            ],
          ),
          SizedBox(height: 8),

        ],
      ),
    );
  }

}

