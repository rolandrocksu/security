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

  Widget _getPermissionIcon(Permission permission) {
  if (permission == Permission.camera) {
    return Icon(Icons.camera_alt);
  } else if (permission == Permission.calendar) {
    return Icon(Icons.event);
  } else if (permission == Permission.contacts) {
    return Icon(Icons.contacts);
  } else if (permission == Permission.location || permission is PermissionWithService) {
    return Icon(Icons.location_on);
  } else if (permission == Permission.microphone) {
    return Icon(Icons.mic);
  } else if (permission == Permission.photos) {
    return Icon(Icons.photo);
  } else if (permission == Permission.storage) {
    return Icon(Icons.sd_storage);
  } else {
    return const Icon(Icons.help, color: Colors.grey);
  }
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
            leading: _getPermissionIcon(permission),
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
