import '../../data/database/database_helper.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  final DatabaseHelper _db = DatabaseHelper();

  Future<bool> hasPermission(String role, String module, String action) async {
    final db = await _db.database;
    final column = 'can${action[0].toUpperCase()}${action.substring(1)}';
    final result = await db.query(
      'permissions',
      where: 'role = ? AND module = ? AND $column = 1',
      whereArgs: [role, module],
    );
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getRolePermissions(String role) async {
    final db = await _db.database;
    return await db.query('permissions', where: 'role = ?', whereArgs: [role]);
  }

  Future<void> updatePermission(String role, String module, String action, bool value) async {
    final db = await _db.database;
    final column = 'can${action[0].toUpperCase()}${action.substring(1)}';
    await db.update(
      'permissions',
      {column: value ? 1 : 0},
      where: 'role = ? AND module = ?',
      whereArgs: [role, module],
    );
  }
}
