import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/body/saladv_info.dart';
import 'package:ssg_smart2/provider/salaryAdv_provider.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:ssg_smart2/view/screen/salaryloan/widgets/bottomsheetcontent.dart';
import 'package:ssg_smart2/view/screen/salaryloan/widgets/eligible_amount_info.dart';
import 'package:ssg_smart2/view/screen/salaryloan/widgets/loan_data.dart';

import '../../../data/model/response/user_info_model.dart';
import '../../../provider/user_provider.dart';

class SalaryAdvanceScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const SalaryAdvanceScreen({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  _SalaryAdvanceScreenState createState() => _SalaryAdvanceScreenState();
}

class _SalaryAdvanceScreenState extends State<SalaryAdvanceScreen> {

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initData() async {
    final userInfoModel = Provider.of<UserProvider>(context, listen: false).userInfoModel;
    if (userInfoModel != null) {
      await Provider.of<SalaryAdvProvider>(context, listen: false).getSalaryInfo(userInfoModel.employeeNumber!);
      await Provider.of<SalaryAdvProvider>(context, listen: false).getSalaryLoanInfo(userInfoModel.employeeNumber!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Salary Advanced',
        isBackButtonExist: widget.isBackButtonExist,
        icon: Icons.home,
        onActionPressed: () {
          // Your action here
        },
      ),

      body: Consumer<SalaryAdvProvider>(
          builder: (context, salProvider, child) {
            // Check if salaryEligibleInfo is null, if so, set default values
            String? eligibilityStatus = salProvider.salaryEligibleInfo?.eligibilityStatus ?? 'No';
            double eligiblityAmount = double.tryParse(salProvider.salaryEligibleInfo?.eligibilityAmount ?? '0') ?? 0;

            bool isEligible = (eligibilityStatus == 'Yes' && eligiblityAmount > 0);
            final loanInfo = salProvider.salaryLoanData;
            double loanAmt = loanInfo?['taken_loan'].toDouble();
            double paidAmt = loanInfo?['loan_adjusted'].toDouble();
            int totalInstallment = loanInfo?['total_installment'];

            if (salProvider.isLoading) {
              return Center(child: CircularProgressIndicator(),);
            } else if (salProvider.salaryEligibleInfo != null){
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Eligibility and Balance Card
                    if(isEligible)
                      EligibleAmountInfo(eligibleAmount: eligiblityAmount,)
                    else
                      LoanData(totalLoan: loanAmt,paidLoan: paidAmt, totalInstallment: totalInstallment,),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(child: LoanInfoCard(title: 'Eligibility Status', amount: isEligible?'Yes':'No')),
                        SizedBox(width: 10),
                        Expanded(child: LoanInfoCard(title: 'Eligibility Percentage', amount: isEligible?'200%':'0%')),
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
                                  _showBottomSheet(context, eligiblityAmount, totalInstallment);
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
                            salProvider.getSalaryInfo(userInfoModel.employeeNumber!);
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
        return BottomSheetContent(
          salaryAdvInfo: SalaryAdvInfo(maxLoanAmount: maxAmount, maxInstallments: totalInstallment),
        );
      },
    );
  }


}

