import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_apps/device_apps.dart';
import 'package:permission_handler/permission_handler.dart';


class PermissionsOverview extends StatefulWidget {
  @override
  _PermissionsOverviewState createState() => _PermissionsOverviewState();
}

class _PermissionsOverviewState extends State<PermissionsOverview> {
  Map<Permission, PermissionStatus> _permissions = {};
  Map<Permission, List<Application>> _permissionApps = {};

  void initState() {
    super.initState();
    _fetchPermissions();
    Permission.values.forEach((permission) {
      _fetchPermissionApps(permission);
    });
  }


  void _fetchPermissions() async {
    final permissions = await Permission.values;
    final statuses = await Future.wait(permissions.map((permission) => permission.status));
    setState(() {
      _permissions = Map.fromIterables(permissions, statuses);
    });
  }

  void _fetchPermissionApps(Permission permission) async {
  final apps = await DeviceApps.getInstalledApplications(
    includeAppIcons: true,
    includeSystemApps: true,
  );

    setState(() {
      _permissionApps[permission] = apps
          .where((app) =>
              app.packageName.isNotEmpty &&
              _hasPermission(app.packageName!, permission))
          .toList();
    });
  }


  bool _hasPermission(String packageName, Permission permission) {
    if (_permissionApps.containsKey(permission)) {
      final apps = _permissionApps[permission];
      return apps!.any((app) => app.packageName == packageName);
    }
    return false;
  }


  void _requestPermission(Permission permission) async {
    final status = await permission.request();
    if (status == PermissionStatus.granted) {
      _fetchPermissionApps(permission);
    }
  }



  void _openAppSettings() {
    openAppSettings();
  }

  Widget _buildPermissionTile(Permission permission) {
  final status = _permissions[permission];
  final apps = _permissionApps[permission];

  IconData icon;
  Color iconColor;

  if (permission.toString().contains("location")) {
    icon = Icons.location_on;
    iconColor = Colors.blue;
  } else if (permission.toString().contains("camera")) {
    icon = Icons.camera_alt;
    iconColor = Colors.orange;
  } else if (permission.toString().contains("contacts")) {
    icon = Icons.contacts;
    iconColor = Colors.green;
  } else if (permission.toString().contains("microphone")) {
    icon = Icons.mic;
    iconColor = Colors.red;
  } else if (permission.toString().contains("storage")) {
    icon = Icons.sd_card;
    iconColor = Colors.deepPurple;
  } else if (permission.toString().contains("calendar")) {
    icon = Icons.calendar_today;
    iconColor = Colors.teal;
  } else if (permission.toString().contains("phone")) {
    icon = Icons.phone;
    iconColor = Colors.indigo;
  } else if (permission.toString().contains("sms")) {
    icon = Icons.sms;
    iconColor = Colors.amber;
  } else {
    icon = Icons.info;
    iconColor = Colors.grey;
  }


  return ExpansionTile(
    leading: Icon(icon, color: iconColor),
    title: Text(permission.toString().substring(permission.toString().indexOf('.') + 1)),
    subtitle: Text(status.toString().substring(status.toString().indexOf('.') + 1)),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () => _requestPermission(permission),
          child: Text("Grant"),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _openAppSettings(),
          child: Text("Revoke"),
        ),
      ],
    ),
    children: apps != null
        ? apps.map((app) => ListTile(
            leading: Icon(Icons.info), // Use a placeholder icon
            title: Text(app.appName ?? ""),
            subtitle: Text(app.packageName ?? ""),
          )).toList()
        : [],
  );
}



  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text("Permissions Overview"),
  ),
  body: ListView(
  children: Permission.values
  .map((permission) => _buildPermissionTile(permission))
  .toList(),
  ),
  );
  }
}

// class AppListPage extends StatelessWidget {
//   final List<Application>? apps;

//   const AppListPage({Key? key, this.apps}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("App List"),
//       ),
//       body: ListView.builder(
//         itemCount: apps?.length ?? 0,
//         itemBuilder: (context, index) {
//           final app = apps![index];
//           return ListTile(
//             leading: app.icon != null ? Image.memory(app.icon!) : SizedBox(),
//             title: Text(app.appName ?? ""),
//             subtitle: Text(app.packageName ?? ""),
//           );
//         },
//       ),
//     );
//   }
// }
