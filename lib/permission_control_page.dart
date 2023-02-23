import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionControl extends StatefulWidget {
  @override
  _PermissionControlState createState() => _PermissionControlState();
}

class _PermissionControlState extends State<PermissionControl> {
  Map<Permission, bool> _permissionSettings = {};

  @override
  void initState() {
    super.initState();
    _fetchPermissionSettings();
  }

  void _fetchPermissionSettings() async {
    final permissions = await Permission.values;
    final settings = await Future.wait(permissions.map((permission) => permission.isGranted));
    setState(() {
      _permissionSettings = Map.fromIterables(permissions, settings);
    });
  }

  Widget _buildPermissionTile(Permission permission) {
    final value = _permissionSettings[permission];
    return SwitchListTile(
      title: Text(permission.toString()),
      subtitle: Text(permission.toString()),
      value: value ?? false,
      onChanged: (newValue) {
        permission.request().then((status) {
          setState(() {
            _permissionSettings[permission] = status.isGranted;
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Permission Control"),
      ),
      body: ListView(
        children: Permission.values.map((permission) => _buildPermissionTile(permission)).toList(),
      ),
    );
  }
}
