import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import './permissions_list.dart';
import 'permission_detail_page.dart';

class AppListPage extends StatefulWidget {
  final List apps;

  const AppListPage({Key? key, required this.apps}) : super(key: key);

  @override
  _AppListPageState createState() => _AppListPageState();
}

class _AppListPageState extends State<AppListPage> {
  bool _cameraPermissionStatus = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermissions();
  }

  Future<void> _checkCameraPermissions() async {
    final appPermissionStatus = await Permission.camera.request().isGranted;

    setState(() {
      _cameraPermissionStatus = appPermissionStatus;
    });
  }

  void _openPermissionDetailPage(Permission permissionName) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PermissionDetailPage(
        permission: permissionName,
      ),
    ));
  }

  void _openPermissionListPage(){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PermissionList(
        key: UniqueKey(),
      ),
    ));
  }

  void _openApp(Application app) {
    DeviceApps.openApp(app.packageName);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.apps.length,
      itemBuilder: (context, index) {
        final app = widget.apps[index];
        final icon = app.icon != null
            ? Image.memory(
                app.icon!,
                width: 50,
                height: 50,
              )
            : const Icon(Icons.android);

        return ListTile(
          leading: icon,
          title: Text(app.appName),
          subtitle: Text(app.packageName),
          onLongPress: () {
            _openPermissionListPage();
          },
          onTap: () {
            _openApp(app);
          },
          trailing: _cameraPermissionStatus
              ? IconButton(
                  onPressed: () {
                    _openPermissionDetailPage(Permission.camera);
                  },
                  icon: const Icon(Icons.security),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
