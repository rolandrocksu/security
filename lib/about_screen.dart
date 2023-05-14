import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('App Version'),
            subtitle: Text('1.0.0'),
          ),
          Divider(),
          ListTile(
            title: Text('Camera Permission'),
            leading: Icon(Icons.camera),
            trailing: FutureBuilder<PermissionStatus>(
              future: Permission.camera.status,
              builder: (BuildContext context, AsyncSnapshot<PermissionStatus> snapshot) {
                return _getPermissionIcon(Permission.camera, snapshot.data);
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Location Permission'),
            leading: Icon(Icons.location_on),
            trailing: FutureBuilder<PermissionStatus>(
              future: Permission.location.status,
              builder: (BuildContext context, AsyncSnapshot<PermissionStatus> snapshot) {
                return _getPermissionIcon(Permission.location, snapshot.data);
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Microphone Permission'),
            leading: Icon(Icons.mic),
            trailing: FutureBuilder<PermissionStatus>(
              future: Permission.microphone.status,
              builder: (BuildContext context, AsyncSnapshot<PermissionStatus> snapshot) {
                return _getPermissionIcon(Permission.microphone, snapshot.data);
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Storage Permission'),
            leading: Icon(Icons.storage),
            trailing: FutureBuilder<PermissionStatus>(
              future: Permission.storage.status,
              builder: (BuildContext context, AsyncSnapshot<PermissionStatus> snapshot) {
                return _getPermissionIcon(Permission.storage, snapshot.data);
              },
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _getPermissionIcon(Permission permission, PermissionStatus? permissionStatus) {
    if (permissionStatus == null) {
      return Icon(Icons.help_outline, color: Colors.grey);
    } else {
      switch (permissionStatus) {
        case PermissionStatus.granted:
          return Icon(Icons.check_circle, color: Colors.green);
        case PermissionStatus.denied:
          return Icon(Icons.cancel, color: Colors.red);
        case PermissionStatus.restricted:
          return Icon(Icons.do_not_disturb_alt, color: Colors.orange);
        case PermissionStatus.permanentlyDenied:
          return Icon(Icons.block, color: Colors.red);
        default:
          return Icon(Icons.help_outline, color: Colors.grey);
      }
    }
  }
}
