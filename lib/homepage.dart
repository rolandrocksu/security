import 'package:flutter/material.dart';
import './permissions_log_page.dart';
import './permission_control_page.dart';
import './permission_recommendations_page.dart';
import './permission_overview_page.dart';
import './list_apps_page.dart';
import 'package:device_apps/device_apps.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  List<Application>? _apps;
//   bool _ismissions();
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

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 0.08),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Permission Manager'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 32.0),
              Image.asset(
                'images/shield.png',
                height: 120.0,
                width: 120.0,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Secure Your App',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    _buildButton(
                      context,
                      'View App Permissions',
                      Icons.visibility,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PermissionsOverview(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildButton(
                      context,
                      'List all apps',
                      Icons.visibility,
                      () async {
                        if (_apps == null) {
                          return;
                        }
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppListPage(apps: _apps!,),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _buildButton(
                      context,
                      'Control App Permissions',
                      Icons.settings,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PermissionControl(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildButton(
                      context,
                      'View Permission\nRecommendations',
                      Icons.star,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PermissionRecommendationsPage(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildButton(
                      context,
                      'View Permissions Log',
                      Icons.history,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PermissionsLog(),
                        ),
                      ),
                    ),
                  ],
                ),
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
                  _buildButton(
                    context,
                    '',
                    Icons.add,
                    () {
                      // Implement action here
                    },
                  ),
                  const SizedBox(width: 16.0),
                  _buildButton(
                    context,
                    '',
                    Icons.remove,
                    () {
                      // Implement action here
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String label, IconData icon, Function onPressed) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
        height: 80.0,
        decoration: BoxDecoration(
          color: Colors.green[700],
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 3),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              children: <Widget>[
                const SizedBox(width: 32.0),
                Icon(
                  icon,
                  size: 32.0,
                  color: Colors.black,
                ),
                const SizedBox(width: 16.0),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
