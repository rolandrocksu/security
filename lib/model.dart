class PermissionLog {
  late final int id;
  late final String permission;
  late final bool isGranted;
  late final String date;
  late final String user;

  PermissionLog({
    required this.id,
    required this.permission,
    required this.isGranted,
    required this.date,
    required this.user,
  });

  PermissionLog.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        permission = map['permission'],
        isGranted = map['is_granted'] == 1,
        date = map['date'],
        user = map['user'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'permission': permission,
      'is_granted': isGranted ? 1 : 0,
      'date': date,
      'user': user,
    };
  }
}
