import 'package:connectivity_plus/connectivity_plus.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final Connectivity _connectivity = Connectivity();

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> syncToCloud() async {
    if (!await isOnline()) return;
    // Cloud sync not configured - app works offline
  }

  Future<void> syncFromCloud() async {
    if (!await isOnline()) return;
    // Cloud sync not configured - app works offline
  }
}
