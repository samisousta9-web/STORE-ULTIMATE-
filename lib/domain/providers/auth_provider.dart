import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../data/database/database_helper.dart';
import '../../data/models/user_model.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  final DatabaseHelper _db = DatabaseHelper();

  Future<bool> verifySecretCode(String code) async {
    if (code == AppConstants.secretCode) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.prefSecretCodeVerified, true);
      return true;
    }
    return false;
  }

  Future<bool> isSecretCodeVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefSecretCodeVerified) ?? false;
  }

  Future<bool> login(String username, String password, {bool rememberMe = false}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final db = await _db.database;
      final result = await db.query(
        'users',
        where: 'username = ? AND password = ? AND isActive = 1',
        whereArgs: [username, password],
      );

      if (result.isNotEmpty) {
        final user = UserModel.fromMap(result.first);

        await db.update(
          'users',
          {'lastLogin': DateTime.now().toIso8601String()},
          where: 'id = ?',
          whereArgs: [user.id],
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.prefIsLoggedIn, true);
        await prefs.setInt(AppConstants.prefUserId, user.id!);
        await prefs.setString(AppConstants.prefUserRole, user.role);
        await prefs.setBool(AppConstants.prefRememberMe, rememberMe);

        state = state.copyWith(
          user: user,
          isLoading: false,
          isAuthenticated: true,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'اسم المستخدم أو كلمة المرور غير صحيحة',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'حدث خطأ أثناء تسجيل الدخول',
      );
      return false;
    }
  }

  Future<bool> loginWithPin(String pin) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final db = await _db.database;
      final result = await db.query(
        'users',
        where: 'pin = ? AND isActive = 1',
        whereArgs: [pin],
      );

      if (result.isNotEmpty) {
        final user = UserModel.fromMap(result.first);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.prefIsLoggedIn, true);
        await prefs.setInt(AppConstants.prefUserId, user.id!);
        await prefs.setString(AppConstants.prefUserRole, user.role);

        state = state.copyWith(
          user: user,
          isLoading: false,
          isAuthenticated: true,
        );
        return true;
      }
      state = state.copyWith(
        isLoading: false,
        error: 'رمز PIN غير صحيح',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'حدث خطأ',
      );
      return false;
    }
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppConstants.prefIsLoggedIn) ?? false;

    if (isLoggedIn) {
      final userId = prefs.getInt(AppConstants.prefUserId);
      if (userId != null) {
        final db = await _db.database;
        final result = await db.query(
          'users',
          where: 'id = ?',
          whereArgs: [userId],
        );
        if (result.isNotEmpty) {
          final user = UserModel.fromMap(result.first);
          state = state.copyWith(
            user: user,
            isAuthenticated: true,
          );
        }
      }
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefIsLoggedIn, false);
    await prefs.remove(AppConstants.prefUserId);
    await prefs.remove(AppConstants.prefUserRole);
    state = AuthState();
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (state.user == null) return false;

    try {
      final db = await _db.database;
      final result = await db.query(
        'users',
        where: 'id = ? AND password = ?',
        whereArgs: [state.user!.id, oldPassword],
      );

      if (result.isNotEmpty) {
        await db.update(
          'users',
          {'password': newPassword},
          where: 'id = ?',
          whereArgs: [state.user!.id],
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  bool hasPermission(String permission) {
    if (state.user == null) return false;
    if (state.user!.role == AppConstants.roleAdmin) return true;
    return state.user!.permissions.contains(permission) || 
           state.user!.permissions.contains('all');
  }
}
