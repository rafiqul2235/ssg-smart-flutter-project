import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/body/saladv_info.dart';
import 'package:ssg_smart2/provider/pfloan_provider.dart';
import 'package:ssg_smart2/provider/salaryAdv_provider.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:ssg_smart2/view/screen/pfloan/widgets/eligible_amount_info.dart';
import 'package:ssg_smart2/view/screen/salaryloan/widgets/bottomsheetcontent2.dart';
import 'package:ssg_smart2/view/screen/salaryloan/widgets/eligible_amount_info.dart';
import 'package:ssg_smart2/view/screen/salaryloan/widgets/loan_data.dart';

import '../../../provider/user_provider.dart';

class PfLoanScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const PfLoanScreen({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  _PfLoanScreenState createState() => _PfLoanScreenState();
}

class _PfLoanScreenState extends State<PfLoanScreen> {

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    final userInfoModel = Provider.of<UserProvider>(context, listen: false).userInfoModel;
    if (userInfoModel != null) {
      await Provider.of<PfLoanProvider>(context, listen: false).getPfLoanInfo(userInfoModel.employeeNumber!);
      await Provider.of<PfLoanProvider>(context, listen: false).getPfLoanInfo(userInfoModel.employeeNumber!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'PF Loan',
        isBackButtonExist: widget.isBackButtonExist,
        icon: Icons.home,
        onActionPressed: () {
          // Your action here
        },
      ),

      body: Consumer<PfLoanProvider>(
          builder: (context, pfProvider, child) {
            // Check if salaryEligibleInfo is null, if so, set default values
            // String? eligibilityStatus = salProvider.salaryEligibleInfo?.eligibilityStatus ?? 'No';
            double pfBalance = double.tryParse(pfProvider.pfEligibleInfo?.pfBalance ?? '0') ?? 0;
            String? eligibilityStatus = pfProvider.pfEligibleInfo?.eligibilityStatus ?? 'No';
            String? eligibilityPercent = pfProvider.pfEligibleInfo?.eligibilityPercent ?? '0';
            // double eligiblityAmount = double.tryParse(salProvider.salaryEligibleInfo?.eligibilityAmount ?? '0') ?? 0;
            double eligibilityAmount = double.tryParse(pfProvider.pfEligibleInfo?.eligibilityAmount ?? '0') ?? 0;



            bool isEligible = (eligibilityStatus == 'Yes' && eligibilityAmount > 0);
            final loanInfo = pfProvider.salaryLoanData;
            double loanAmt = (loanInfo?['taken_loan'] ?? 0).toDouble();
            double paidAmt = (loanInfo?['loan_adjusted'] ?? 0).toDouble();
            int totalInstallment = loanInfo?['total_installment'] ?? 0;
            // int totalInstallment = 10;


            if (pfProvider.isLoading) {
              return Center(child: CircularProgressIndicator(),);
            } else if (pfProvider.pfEligibleInfo != null){
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Eligibility and Balance Card
                    if(isEligible)
                      PfEligibleAmountInfo(pfBalance: pfBalance, eligibleAmount: eligibilityAmount,)
                    else
                      LoanData(totalLoan: loanAmt,paidLoan: paidAmt, totalInstallment: totalInstallment,),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(child: PfLoanInfoCard(title: 'Eligibility Status', amount: isEligible?'Yes':'No')),
                        SizedBox(width: 10),
                        Expanded(child: PfLoanInfoCard(title: 'Eligibility Percentage', amount: isEligible? eligibilityPercent:'0%')),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Make a Loan Card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.grey.shade200,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Make a Loan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Request your loan and get your money\nin your balance in just a easy way.",
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: isEligible? () {
                                  _showBottomSheet(context, eligibilityAmount, totalInstallment);
                                }
                                    :null,
                                icon: Icon(Icons.add),
                                label: Text("Create Application"),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white, backgroundColor: Colors.red,
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Failed to load Salary adv info"),
                    ElevatedButton(
                        onPressed: () {
                          final userInfoModel = Provider.of<UserProvider>(context, listen: false).userInfoModel;
                          if (userInfoModel != null){
                            pfProvider.getPfLoanInfo(userInfoModel.employeeNumber!);
                          }
                        },
                        child: Text("Retry"))
                  ],
                ),
              );
            }
          }
      ),
    );
  }

  void _showBottomSheet(BuildContext context, double maxAmount, int totalInstallment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BottomSheetContentTest1(
          salaryAdvInfo: SalaryAdvInfo(maxLoanAmount: maxAmount, maxInstallments: totalInstallment),
        );
      },
    );
  }


}

