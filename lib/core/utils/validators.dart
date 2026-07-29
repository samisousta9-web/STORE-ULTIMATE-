class Validators {
  static String? required(String? value, [String field = '']) {
    if (value == null || value.trim().isEmpty) {
      return field.isNotEmpty ? '$field مطلوب' : 'هذا الحقل مطلوب';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'البريد الإلكتروني غير صالح';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return null;
    final phoneRegex = RegExp(r'^(0|\+213)[5-7][0-9]{8}$');
    if (!phoneRegex.hasMatch(value)) return 'رقم الهاتف غير صالح';
    return null;
  }

  static String? minLength(String? value, int min, [String field = '']) {
    if (value != null && value.length < min) {
      return '$field يجب أن يكون $min أحرف على الأقل';
    }
    return null;
  }

  static String? positiveNumber(String? value, [String field = '']) {
    if (value == null || value.isEmpty) return null;
    final number = double.tryParse(value);
    if (number == null || number < 0) {
      return '$field يجب أن يكون رقماً موجباً';
    }
    return null;
  }
}
