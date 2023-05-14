import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionModel {
  final String name;
  final IconData icon;
  PermissionStatus status;

  PermissionModel({
    required this.name,
    required this.icon,
    required this.status,
  });
}
