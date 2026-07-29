import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _darkMode = false;
  String _language = 'ar';
  bool _notifications = true;
  bool _autoBackup = true;
  bool _fingerprint = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        children: [
          // Developer Info
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.primary.withOpacity(0.05),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.store, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  AppConstants.appName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('v${AppConstants.appVersion}'),
                const SizedBox(height: 8),
                Text('by ${AppConstants.developerName}'),
                Text(AppConstants.developerEmail, style: const TextStyle(color: AppColors.primary)),
                Text(AppConstants.developerPhone),
              ],
            ),
          ),
          const Divider(),
          // General Settings
          const ListTile(
            leading: Icon(Icons.tune),
            title: Text('الإعدادات العامة', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('اللغة'),
            subtitle: Text(_language == 'ar' ? 'العربية' : _language == 'fr' ? 'Français' : 'English'),
            trailing: DropdownButton<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
                DropdownMenuItem(value: 'fr', child: Text('Français')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (v) => setState(() => _language = v!),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('العملة'),
            subtitle: Text(AppConstants.currencyName),
            trailing: Text(AppConstants.currency, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('الوضع الليلي'),
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          const Divider(),
          // Security
          const ListTile(
            leading: Icon(Icons.security),
            title: Text('الأمان', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: const Text('قفل التطبيق بالبصمة'),
            value: _fingerprint,
            onChanged: (v) => setState(() => _fingerprint = v),
          ),
          ListTile(
            leading: const Icon(Icons.pin),
            title: const Text('تغيير رمز PIN'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('تغيير كلمة المرور'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),
          // Backup & Sync
          const ListTile(
            leading: Icon(Icons.cloud),
            title: Text('النسخ الاحتياطي والمزامنة', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.backup),
            title: const Text('النسخ الاحتياطي التلقائي'),
            subtitle: const Text('نسخ احتياطي يومي'),
            value: _autoBackup,
            onChanged: (v) => setState(() => _autoBackup = v),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('نسخ احتياطي يدوي'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.cloud_download),
            title: const Text('استعادة البيانات'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('مزامنة السحابة'),
            subtitle: const Text('Firebase Cloud Sync'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),
          // Printing
          const ListTile(
            leading: Icon(Icons.print),
            title: Text('الطباعة', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.bluetooth),
            title: const Text('طابعة Bluetooth'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.wifi),
            title: const Text('طابعة Wi-Fi'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.usb),
            title: const Text('طابعة USB'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),
          // Tax
          const ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('الضرائب', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.percent),
            title: const Text('نسبة الضريبة الافتراضية'),
            trailing: const Text('19%', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {},
          ),
          const Divider(),
          // Data
          const ListTile(
            leading: Icon(Icons.storage),
            title: Text('البيانات', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.file_upload),
            title: const Text('استيراد البيانات'),
            subtitle: const Text('Excel, CSV'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('تصدير البيانات'),
            subtitle: const Text('Excel, CSV, PDF'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: AppColors.error),
            title: const Text('مسح جميع البيانات', style: TextStyle(color: AppColors.error)),
            onTap: () {},
          ),
          const Divider(),
          // About
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('حول التطبيق', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('التحقق من التحديثات'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('مركز المساعدة'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              '© 2024 ${AppConstants.developerName} - جميع الحقوق محفوظة',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
