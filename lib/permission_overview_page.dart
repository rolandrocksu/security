import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsOverview extends StatefulWidget {
  @override
  _PermissionsOverviewState createState() => _PermissionsOverviewState();
}

class _PermissionsOverviewState extends State<PermissionsOverview> {
  Map<Permission, PermissionStatus> _permissions = {};

  @override
  void initState() {
    super.initState();
    _fetchPermissions();
  }

  void _fetchPermissions() async {
    final permissions = await Permission.values;
    final statuses = await Future.wait(permissions.map((permission) => permission.status));
    setState(() {
      _permissions = Map.fromIterables(permissions, statuses);
    });
  }

  Widget _buildPermissionTile(Permission permission) {
    final status = _permissions[permission];
    return ListTile(
      title: Text(permission.toString()),
      subtitle: Text(status.toString()),
      trailing: ElevatedButton(
        onPressed: () {
          permission.request().then((status) {
            setState(() {
              _permissions[permission] = status;
            });
          });
        },
        child: Text("Change"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Permissions Overview"),
      ),
      body: ListView(
        children: Permission.values.map((permission) => _buildPermissionTile(permission)).toList(),
      ),
    );
  }
}
