import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'permission_detail_page.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<Permission, PermissionStatus> _status = {};

  @override
  void initState() {
    super.initState();
    _fetchPermissions();
  }

  void _fetchPermissions() async {
    final permissions = await Permission.values;
    final statusMap = await permissions.request();
    setState(() {
      _status = statusMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Permissions Manager'),
      ),
      body: ListView.builder(
        itemCount: Permission.values.length,
        itemBuilder: (BuildContext context, int index) {
          final permission = Permission.values[index];
          final permissionStatus = _status[permission];
          return ListTile(
            title: Text(
              permission.toString(),
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text(permissionStatus.toString()),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PermissionDetailPage(
                      permission: permission,
                    ),
                  ),
                );
              },
              child: Text('Details'),
            ),
          );
        },
      ),
    );
  }
}