import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/basewidget/no_internet_screen.dart';

import '../../../data/model/response/user_info_model.dart';
import '../../../provider/wppf_provider.dart';
import '../../../utill/user_data_storage.dart';
import '../../basewidget/custom_app_bar.dart';
import '../home/dashboard_screen.dart';

class WppfLedgerScreen extends StatefulWidget {
  final bool isBackButtonExist;

  const WppfLedgerScreen({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  _WppfLedgerScreenState createState() => _WppfLedgerScreenState();
}

class _WppfLedgerScreenState extends State<WppfLedgerScreen> {
  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    UserInfoModel? userInfo = await UserDataStorage.getUserInfo();
    print("Ledger: $userInfo");
    if (userInfo != null) {
      Provider.of<WppfProvider>(context, listen: false).fetchWppfLedger(userInfo.employeeId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'WPPF Ledger',
        isBackButtonExist: widget.isBackButtonExist,
        icon: Icons.home,
        onActionPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));
        },
      ),
      body: Consumer<WppfProvider>(
        builder: (context, wppfProvider, child) {
          if (wppfProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (wppfProvider.error.isNotEmpty) {
            return NoInternetOrDataScreen(isNoInternet: false);
          } else {
            return ListView.builder(
              itemCount: wppfProvider.wppfLedgers.length,
              itemBuilder: (context, index) {
                final ledger = wppfProvider.wppfLedgers[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(
                        '${ledger.fiscalYear}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      backgroundColor: Colors.white,
                      collapsedBackgroundColor: Colors.grey[50],
                      childrenPadding: EdgeInsets.all(16),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Disbursement Amount', '৳${ledger.eachEmpEarningAmt}'),
                        _buildDetailRow('Distributed Amount', '৳${ledger.eachEmpNetAmt}'),
                        _buildDetailRow('Investment', '৳${ledger.investProfitPayable}'),
                        _buildDetailRow('Profit from Investment', '৳${ledger.investProfit}'),
                        _buildDetailRow('Total Payable', '৳${ledger.eachEmpInvestmentAmt}'),
                      ],
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

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          Text(value ?? ''),
        ],
      ),
    );
  }
}