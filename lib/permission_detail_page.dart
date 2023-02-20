import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDetailPage extends StatefulWidget {
  final Permission permission;

  PermissionDetailPage({required this.permission});

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

  void _requestPermission() async {
    final status = await widget.permission.request();
    setState(() {
      _status = status;
    });
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
            Text(
              'Permission Name: ${widget.permission.toString()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Permission Status: ${_status.toString()}',
              style: TextStyle(fontSize: 18),
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
