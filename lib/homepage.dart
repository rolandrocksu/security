import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'list_apps_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Application>? _apps;
  bool _isLoading = true;

  Future<void> _getApps() async {
    setState(() {
      _isLoading = true;
    });

    _apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _checkCameraPermissions() async {
    final appPermissionStatus =
        await Permission.camera.request().isGranted;

    setState(() {
      _cameraPermissionStatus = appPermissionStatus;
    });
  }

  bool _cameraPermissionStatus = false;

  @override
  void initState() {
    super.initState();
    _getApps();
    _checkCameraPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installed apps'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : AppListPage(apps: _apps!),
    );
  }
}
