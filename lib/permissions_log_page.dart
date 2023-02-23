import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PermissionsLog extends StatefulWidget {
  @override
  _PermissionsLogState createState() => _PermissionsLogState();
}

class _PermissionsLogState extends State<PermissionsLog> {
  late Database _database;
  List<Map<String, dynamic>> _logs = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _getLogs();
  }

  void _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'permissions_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE permission_logs(id INTEGER PRIMARY KEY, permission TEXT, is_granted INTEGER, date TEXT, user TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> _insertLog(String permission, bool isGranted) async {
    final DateTime now = DateTime.now();
    final String formattedDate = "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}";
    await _database.insert(
      'permission_logs',
      {
        'permission': permission,
        'is_granted': isGranted ? 1 : 0,
        'date': formattedDate,
        'user': 'user1', // TODO: replace with actual user ID
      },
    );
    _getLogs();
  }

  Future<void> _getLogs() async {
    final List<Map<String, dynamic>> logs = await _database.query('permission_logs');
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








// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';

// class PermissionsLog extends StatefulWidget {
//   @override
//   _PermissionsLogState createState() => _PermissionsLogState();
// }

// class _PermissionsLogState extends State<PermissionsLog> {
//   List<Map<String, dynamic>> _logEntries = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchLogEntries();
//   }

//   void _fetchLogEntries() async {
//     final Database database = await openDatabase(
//       "permissions_log.db",
//       version: 1,
//       onCreate: (Database db, int version) async {
//         await db.execute(
//             "CREATE TABLE IF NOT EXISTS log (timestamp TEXT, permission TEXT, granted INTEGER)");
//       },
//     );
//     final List<Map<String, dynamic>> entries = await database.query("log");
//     setState(() {
//       _logEntries = entries;
//     });
//   }

//   Widget _buildLogTile(Map<String, dynamic> entry) {
//     final timestamp = entry['timestamp'] as String;
//     final permission = entry['permission'] as String;
//     final granted = entry['granted'] == 1;
//     return ListTile(
//       title: Text(permission),
//       subtitle: Text(granted ? "Granted" : "Revoked"),
//       trailing: Text(timestamp),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Permissions Log"),
//       ),
//       body: ListView(
//         children: _logEntries.map((entry) => _buildLogTile(entry)).toList(),
//       ),
//     );
//   }
// }
