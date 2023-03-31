import 'package:flutter/material.dart';
import './db_helper/database_helper.dart';

class PermissionsLog extends StatefulWidget {
  @override
  _PermissionsLogState createState() => _PermissionsLogState();
}

class _PermissionsLogState extends State<PermissionsLog> {
  late List<Map<String, dynamic>> _logs;

  @override
  void initState() {
    super.initState();
    _getLogs();
  }

  Future<void> _insertLog(String permission, bool isGranted) async {
    await DatabaseHelper.instance.insertLog(permission, isGranted);
    _getLogs();
  }

  Future<void> _getLogs() async {
    final logs = await DatabaseHelper.instance.getLogs();
    setState(() {
      _logs = logs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        return ListTile(
          title: Text(log['permission']),
          subtitle: Text("Granted: ${log['is_granted'] == 1} on ${log['date']} by ${log['user']}"),
        );
      },
    );
  }
}
