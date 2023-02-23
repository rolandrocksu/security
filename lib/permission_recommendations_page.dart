import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usage_stats/usage_stats.dart';

class PermissionRecommendationsPage extends StatefulWidget {
  const PermissionRecommendationsPage({Key? key}) : super(key: key);

  @override
  _PermissionRecommendationsPageState createState() =>
      _PermissionRecommendationsPageState();
}

class _PermissionRecommendationsPageState
    extends State<PermissionRecommendationsPage> {
  late List<String> inactiveApps;

  @override
  void initState() {
    super.initState();
    inactiveApps = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permission Recommendations'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () async {
              await checkPermissionStatus();
            },
            child: Text('Check Permission Status'),
          ),
          ElevatedButton(
            onPressed: () async {
              await getInactiveAppPermissions();
            },
            child: Text('Get Inactive App Permissions'),
          ),
          ElevatedButton(
            onPressed: () async {
              await requestUsagePermission();
            },
            child: Text('Request Usage Permission'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: inactiveApps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(inactiveApps[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkPermissionStatus() async {
    final permissionStatus = await Permission.storage.status;
    if (permissionStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Storage permission is granted.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Storage permission is not granted.'),
        ),
      );
    }
  }

  Future<void> getInactiveAppPermissions() async {
    DateTime endDate = new DateTime.now();
    DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
    inactiveApps.clear();
    if (await UsageStats.checkUsagePermission() == true) {
      final List<UsageInfo> usageStatsList =
          await UsageStats.queryUsageStats(startDate, endDate);
      usageStatsList.forEach((usageInfo) {
        inactiveApps.add(usageInfo.packageName!);
      });
      setState(() {});
    } else {
      await UsageStats.grantUsagePermission();
    }
  }

  Future<void> requestUsagePermission() async {
    if (await UsageStats.checkUsagePermission() == false) {
      await UsageStats.grantUsagePermission();
    }
  }
}
