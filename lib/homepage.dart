// import 'package:device_apps/device_apps.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// import 'list_apps_page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<Application>? _apps;
//   bool _isLoading = true;

//   Future<void> _getApps() async {
//     setState(() {
//       _isLoading = true;
//     });

//     _apps = await DeviceApps.getInstalledApplications(
//       includeAppIcons: true,
//       includeSystemApps: true,
//       onlyAppsWithLaunchIntent: true,
//     );

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   Future<void> _checkCameraPermissions() async {
//     final appPermissionStatus =
//         await Permission.camera.request().isGranted;

//     setState(() {
//       _cameraPermissionStatus = appPermissionStatus;
//     });
//   }

//   bool _cameraPermissionStatus = false;

//   @override
//   void initState() {
//     super.initState();
//     _getApps();
//     _checkCameraPermissions();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Installed apps'),
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : AppListPage(apps: _apps!),
//     );
//   }
// }



import 'package:flutter/material.dart';
import './permissions_log_page.dart';
import './permission_control_page.dart';
import './permission_recommendations_page.dart';
import './permission_overview_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to My App!',
              style: TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PermissionsOverview(),
                  ),
                );
              },
              child: const Text('View App Permissions'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PermissionControl(),
                  ),
                );
              },
              child: const Text('Control App Permissions'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PermissionRecommendationsPage(),
                  ),
                );
              },
              child: const Text('View Permission Recommendations'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PermissionsLog(),
                  ),
                );
              },
              child: const Text('View Permissions Log'),
            ),
            const SizedBox(height: 32.0),
            const Text(
              'Some other actions:',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement action here
                  },
                  child: const Text('Action 1'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Implement action here
                  },
                  child: const Text('Action 2'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
