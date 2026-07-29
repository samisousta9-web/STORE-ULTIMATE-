import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _notifications.initialize(initSettings);
    _initialized = true;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) await init();
    const androidDetails = AndroidNotificationDetails(
      'store_manager_channel',
      'Store Manager Notifications',
      channelDescription: 'Notifications for store management',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _notifications.show(id, title, body, notificationDetails, payload: payload);
  }

  Future<void> showLowStockAlert(String productName, int quantity) async {
    await showNotification(
      id: 1,
      title: 'تنبيه نفاد المخزون',
      body: 'المنتج "$productName" بقي منه $quantity فقط!',
    );
  }

  Future<void> showExpiryAlert(String productName, DateTime expiryDate) async {
    await showNotification(
      id: 2,
      title: 'تنبيه انتهاء الصلاحية',
      body: 'المنتج "$productName" ينتهي بتاريخ ${expiryDate.toIso8601String().substring(0, 10)}',
    );
  }
}
