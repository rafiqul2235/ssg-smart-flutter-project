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
  Widget build(BuildContext context) {
    UserInfoModel? userInfoModel = Provider.of<UserProvider>(context,listen: false).userInfoModel;
    final salProvider = Provider.of<SalaryAdvProvider>(context);
    salProvider.getSalaryInfo(userInfoModel!.employeeNumber!);
    // Check if salaryEligibleInfo is null, if so, set default values
    String? eligibilityStatus = salProvider.salaryEligibleInfo?.eligibilityStatus ?? 'No';
    int eligiblityAmount = int.tryParse(salProvider.salaryEligibleInfo?.eligibilityAmount ?? '0') ?? 0;

    bool isEligible = (eligibilityStatus == 'Yes' && eligiblityAmount > 0);

    print("eligible status: $isEligible");
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Salary Advanced',
        isBackButtonExist: widget.isBackButtonExist,
        icon: Icons.home,
        onActionPressed: () {
          // Your action here
        },
      ),
      body: Center(
        child: salProvider.isLoading
          ? CircularProgressIndicator()
          :salProvider.salaryEligibleInfo != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Eligibility and Balance Card
                  if(isEligible)
                      EligibleAmountInfo()
                  else
                    LoanData(),
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
                                _showBottomSheet(context);
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
             )
          : Center(
            child: Column(
              children: [
                Text ('Loading Error'),
                FloatingActionButton(
                  onPressed: () {
                    salProvider.getSalaryInfo(userInfoModel!.employeeId!);
                  },
                  child: Icon(Icons.refresh),
                ),
              ],
            ),
          )
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BottomSheetContent(
          salaryAdvInfo: SalaryAdvInfo(maxLoanAmount: 120000, maxInstallments: 12),
        );
      },
    );
  }


}

