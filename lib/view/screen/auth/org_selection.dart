import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/user_provider.dart';
import '../home/dashboard_screen.dart';


class OrganizationSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userInfo = userProvider.userInfoModel;

    print('organization: $userInfo');

    return Scaffold(
      appBar: AppBar(title: const Text('Select Organization')),
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

              await userProvider.setUser(userInfo); // This now updates SharedPreferences too
              await userProvider.loadUser();

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
