import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/constants/app_constants.dart';

class BackupService {
  static Future<String> createLocalBackup() async {
    final dbPath = await getDatabasesPath();
    final sourceFile = File(join(dbPath, AppConstants.dbName));
    final backupDir = await getExternalStorageDirectory();
    final backupPath = join(backupDir!.path, 'backups');
    await Directory(backupPath).create(recursive: true);
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final backupFile = File(join(backupPath, 'backup_$timestamp.db'));
    await sourceFile.copy(backupFile.path);
    return backupFile.path;
  }

  static Future<void> shareBackup(String path) async {
    await Share.shareXFiles([XFile(path)], text: 'Store Manager Pro Backup');
  }

  static Future<void> restoreFromBackup(String path) async {
    final dbPath = await getDatabasesPath();
    final sourceFile = File(path);
    final targetFile = File(join(dbPath, AppConstants.dbName));
    await sourceFile.copy(targetFile.path);
  }
}
