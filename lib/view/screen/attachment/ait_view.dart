import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/data/model/response/user_info_model.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import 'package:ssg_smart2/view/screen/attachment/ait_details.dart';
import 'package:ssg_smart2/view/screen/attachment/attachment_provider.dart';
import 'package:ssg_smart2/view/screen/home/dashboard_screen.dart';

import '../../../provider/user_provider.dart';

class AitView extends StatefulWidget {
  final bool isBackButtonExist;

  const AitView({Key? key, this.isBackButtonExist = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AitViewState();

}

class _AitViewState extends State<AitView> {
  UserInfoModel? userInfoModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userInfoModel = Provider.of<UserProvider>(context,listen: false).userInfoModel;
      Provider.of<AttachmentProvider>(context, listen: false).fetchAitInfo(userInfoModel!.employeeNumber!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: 'AIT Approval',
            isBackButtonExist: widget.isBackButtonExist,
            icon: Icons.home,
            onActionPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const DashBoardScreen(),
              ));
            },
          ),
          Expanded(
            child: Consumer<AttachmentProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }


                if (provider.aitData.isEmpty) {
                  return const Center(
                    child: Text('No AIT Approvals found'),
                  );
                }

                return ListView.separated(
                  itemCount: provider.aitData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final aitData = provider.aitData[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AitDetailsScreen(headerId: aitData.headerId,notificationId: aitData.notificationId,)
                            )
                        );
                      },
                      child: Card.outlined(
                        color: Colors.orange[50],
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${aitData.customerName}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text('Challan No: ${aitData.challanNo}'),
                                        Text('Challan Date: ${aitData.challanDate}')
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[400],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "Pending",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text('Issued by Md Masum Manzil RSM'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
