import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDetailPage extends StatefulWidget {
  final Permission permission;
  final String description;

  PermissionDetailPage({
    required this.permission,
    this.description = "Allows the app to access the device's sensitive data",
  });

  @override
  _PermissionDetailPageState createState() => _PermissionDetailPageState();
}

class _PermissionDetailPageState extends State<PermissionDetailPage> {
  late PermissionStatus _status;

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
  }

  void _checkPermissionStatus() async {
    final status = await widget.permission.status;
    setState(() {
      _status = status;
    });
  }

  void _requestPermission() {
    widget.permission.request().then((status) {
      setState(() {
        _status = status;
      });
    });
  }

  void _openAppSettings() {
    openAppSettings();
  }

  Widget _buildPermissionIcon() {
    IconData icon;
    Color iconColor;
    String permissionName = widget.permission.toString();

    if (permissionName.contains("location")) {
      icon = Icons.location_on;
      iconColor = Colors.blue;
    } else if (permissionName.contains("camera")) {
      icon = Icons.camera_alt;
      iconColor = Colors.orange;
    } else if (permissionName.contains("contacts")) {
      icon = Icons.contacts;
      iconColor = Colors.green;
    } else {
      icon = Icons.info;
      iconColor = Colors.grey;
    }

    return Icon(
      icon,
      color: iconColor,
      size: 32,
    );
  }

  Widget _buildPermissionStatus() {
    String statusText;
    Color statusColor;

    if (_status.isGranted) {
      statusText = 'Granted';
      statusColor = Colors.green;
    } else if (_status.isDenied || _status.isPermanentlyDenied) {
      statusText = 'Denied';
      statusColor = Colors.red;
    } else {
      statusText = 'Unknown';
      statusColor = Colors.grey;
    }

    return Text(
      'Permission Status: $statusText',
      style: TextStyle(fontSize: 18, color: statusColor),
    );
  }

  Widget _buildPermissionDescription() {
    return Text(
      widget.description,
      style: TextStyle(fontSize: 16),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to revoke access to this permission?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _openAppSettings();
              },
              child: Text('Revoke'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permission Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildPermissionIcon(),
                SizedBox(width: 8),
                Text(
                  'Permission Name: ${widget.permission.toString()}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildPermissionStatus(),
            SizedBox(height: 16),
                        _buildPermissionDescription(),
            SizedBox(height: 16),
            if (_status.isGranted)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showConfirmationDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: Text('Revoke Access'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'WARNING: Revoking access will prevent the app from using this permission.',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ],
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _requestPermission();
              },
              child: Text('Request Permission'),
            ),
          ],
        ),
      ),
    );
  }
}

