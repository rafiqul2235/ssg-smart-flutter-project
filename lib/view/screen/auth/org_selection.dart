import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssg_smart2/view/basewidget/custom_app_bar.dart';
import '../../../provider/user_provider.dart';
import '../home/dashboard_screen.dart';

class OrganizationSelectionScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const OrganizationSelectionScreen({Key? key, this.isBackButtonExist = true}): super(key:key);
  @override
  _OrganizationSelectionScreenState createState() => _OrganizationSelectionScreenState();
}

class _OrganizationSelectionScreenState extends State<OrganizationSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userInfo = userProvider.userInfoModel;

    print('organization: $userInfo');

    return Scaffold(
      appBar: CustomAppBar(
          title: 'Select Organization',
          isBackButtonExist: widget.isBackButtonExist,
      ),
      body: ListView.builder(
        itemCount: userInfo?.orgs.length ?? 0,
        itemBuilder: (context, index) {
          final org = userInfo!.orgs[index];
          return ListTile(
            title: Text(org.name),
            onTap: () async {
              // Update selected organization
              userInfo.orgId = org.id;
              userInfo.orgName = org.name;
              print("Selected Org: $org");
              await userProvider.setUser(userInfo); // This now updates SharedPreferences too
              await userProvider.loadUser();

              final userProvider2 = Provider.of<UserProvider>(context, listen: false);
              final userInfo2 = userProvider2.userInfoModel;

              print('organization2: $userInfo2');

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => DashBoardScreen()),
                    (route) => false,
              );
            },
          );
        },
      ),
    );
  }
}