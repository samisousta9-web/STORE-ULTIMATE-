class AppConstants {
  static const String appName = 'Store Manager Pro Ultimate';
  static const String appVersion = '1.0.0';
  static const String developerName = 'Sami Banouh';
  static const String developerEmail = 'banouhsami13@gmail.com';
  static const String developerPhone = '0782918108';
  static const String secretCode = '200213570000';
  static const String currency = 'د.ج'; // Algerian Dinar
  static const String currencyName = 'الدينار الجزائري';

  // Database
  static const String dbName = 'store_manager_pro.db';
  static const int dbVersion = 1;

  // Shared Preferences Keys
  static const String prefSecretCodeVerified = 'secret_code_verified';
  static const String prefIsLoggedIn = 'is_logged_in';
  static const String prefUserId = 'user_id';
  static const String prefUserRole = 'user_role';
  static const String prefRememberMe = 'remember_me';
  static const String prefLanguage = 'language';
  static const String prefTheme = 'theme';
  static const String prefBranchId = 'branch_id';

  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleAccountant = 'accountant';
  static const String roleEmployee = 'employee';
  static const String roleStorekeeper = 'storekeeper';

  // Pagination
  static const int itemsPerPage = 20;

  // Animation Durations
  static const int splashDuration = 3000;
  static const int transitionDuration = 500;
}
