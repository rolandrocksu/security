import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './permission_model.dart';
import './permission_card.dart';

class PermissionRecommendationsPage extends StatefulWidget {
  const PermissionRecommendationsPage({Key? key}) : super(key: key);

  @override
  _PermissionRecommendationsPageState createState() =>
      _PermissionRecommendationsPageState();
}

class _PermissionRecommendationsPageState
    extends State<PermissionRecommendationsPage> {
  late List<PermissionModel> permissions;

  @override
  void initState() {
    super.initState();
    permissions = [
      PermissionModel(
        name: 'Camera',
        icon: Icons.camera_alt,
        status: PermissionStatus.denied,
      ),
      PermissionModel(
        name: 'Location',
        icon: Icons.location_on,
        status: PermissionStatus.denied,
      ),
      PermissionModel(
        name: 'Microphone',
        icon: Icons.mic,
        status: PermissionStatus.denied,
      ),
      PermissionModel(
        name: 'Storage',
        icon: Icons.storage,
        status: PermissionStatus.denied,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permission Recommendations'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Recommended Permissions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              children: permissions
                  .map(
                    (permission) => PermissionCard(
                      permission: permission,
                      onGrant: () => _onGrant(permission),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _onGrant(PermissionModel permission) async {
    final status = await permission.status.request();
    setState(() {
      permission.status = status;
    });
  }
}
