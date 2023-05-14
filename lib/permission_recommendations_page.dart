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
  late List<String> inactivePermissions;
  late List<String> recommendedPermissions;
  List<Permission> _permissions = [];

  @override
  void initState() {
    _getPermissions();
    super.initState();
    inactiveApps = [];
    inactivePermissions = [];
    recommendedPermissions = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permission Recommendations'),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                await getInactivePermissions();
                await getRecommendedPermissions();
              },
              child: Text('Get Permission Recommendations'),
            ),
            SizedBox(height: 20),
            Text(
              'Inactive Apps',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            inactiveApps.isEmpty
                ? Center(child: Text('No inactive apps.'))
                : Column(
                    children: inactiveApps
                        .map((appName) => ListTile(title: Text(appName)))
                        .toList(),
                  ),
            SizedBox(height: 20),
            Text(
              'Inactive Permissions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            inactivePermissions.isEmpty
                ? Center(child: Text('No inactive permissions.'))
                : Column(
                    children: inactivePermissions
                        .map((permission) => ListTile(title: Text(permission)))
                        .toList(),
                  ),
            SizedBox(height: 20),
            Text(
              'Recommended Permissions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            recommendedPermissions.isEmpty
                ? Center(child: Text('No recommended permissions.'))
                : Column(
                    children: recommendedPermissions
                        .map((permission) => ListTile(title: Text(permission)))
                        .toList(),
                  ),
            SizedBox(height: 20),
          ],
        ),
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
    DateTime startDate =
        DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
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

  Future<void> _getPermissions() async {
    final permissions = await Permission.values
        .where((permission) => permission != Permission.unknown)
        .toList();
    setState(() {
      _permissions = permissions;
    });
  }

  Future<void> getInactivePermissions() async {
    inactivePermissions.clear();

    // final List<Permission> permissions = await PermissionHandler()
    //     .requestPermissions([PermissionGroup.location]);
    _permissions.forEach((permission) {
      if (permission == PermissionStatus.denied) {
        inactivePermissions.add(permission.toString());
      }
    });
    setState(() {});
  }

  Future<void> getRecommendedPermissions() async {
    recommendedPermissions.clear();
    final permissionStatus = await Permission.storage.status;
    if (permissionStatus.isDenied) {
      recommendedPermissions.add('Storage');
    }
    final locationPermissionStatus = await Permission.location.status;
    if (locationPermissionStatus.isDenied) {
      recommendedPermissions.add('Location');
    }
    setState(() {});
  }
}
