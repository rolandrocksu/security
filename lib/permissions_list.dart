import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import './permission_detail_page.dart';

class PermissionList extends StatefulWidget {
  const PermissionList({Key? key}) : super(key: key);

  @override
  _PermissionListState createState() => _PermissionListState();
}

class _PermissionListState extends State<PermissionList> {
  List<Permission> _permissions = [];

  @override
  void initState() {
    super.initState();
    _getPermissions();
  }

  void _openPermissionDetailPage(Permission permissionName) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PermissionDetailPage(
        permission: permissionName,
      ),
    ));
  }

  Future<void> _getPermissions() async {
    final permissions = await Permission.values
        .where((permission) => permission != Permission.unknown)
        .toList();
    setState(() {
      _permissions = permissions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions'),
      ),
      body: ListView.builder(
        itemCount: _permissions.length,
        itemBuilder: (context, index) {
          final permission = _permissions[index];
          return ListTile(
            title: Text(describeEnum(permission)),
            subtitle: Text(permission.toString()),
            onTap: () {
              _openPermissionDetailPage(permission);
            },
            trailing: FutureBuilder<PermissionStatus>(
              future: permission.status,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final status = snapshot.data!;
                if (status.isGranted) {
                  return const Icon(Icons.check, color: Colors.green);
                } else if (status.isDenied) {
                  return const Icon(Icons.close, color: Colors.red);
                } else {
                  return const Icon(Icons.help, color: Colors.grey);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
