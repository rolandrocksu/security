import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import './permission_model.dart';

class PermissionCard extends StatelessWidget {
  final PermissionModel permission;
  final Function() onGrant;

  const PermissionCard({
    Key? key,
    required this.permission,
    required this.onGrant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () async {
          if (permission.status.isRestricted) {
            await onGrant();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                permission.name as String,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(permission.name),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    permission.status.toString().split('.').last,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(permission.status),
                    ),
                  ),
                  if (permission.status.isRestricted)
                    ElevatedButton(
                      onPressed: onGrant,
                      child: Text('Grant'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
