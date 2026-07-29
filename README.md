# Store Manager Pro Ultimate

## Professional Store Management System

**Developer:** Sami Banouh  
**Email:** banouhsami13@gmail.com  
**Phone:** 0782918108  
**Currency:** Algerian Dinar (DZD)

---

## Features

### Core Features
- Multi-platform support (Android, iOS, Web, Desktop)
- Material 3 Design with Dark Mode
- Multi-language support (Arabic, French, English)
- SQLite database with encryption
- Offline-first architecture
- Cloud sync ready (Firebase)

### Security
- Secret code activation (200213570000)
- Fingerprint/Face ID authentication
- PIN code login
- Role-based access control
- Audit logging
- Database encryption

### Business Modules
- Dashboard with analytics
- Point of Sale (POS)
- Product management with barcode/QR
- Customer management with loyalty points
- Supplier management
- Inventory with low stock alerts
- Invoicing with PDF generation
- Advanced accounting (Ledger, Trial Balance, Income Statement, Balance Sheet, Cash Flow)
- Employee management (attendance, payroll, commissions)
- Multi-company & multi-branch support
- Purchase orders & returns
- Coupons & promotions (BOGO)

### AI Features
- Smart sales predictions
- Low stock forecasting
- Product profitability analysis
- Smart recommendations

### Reports
- 150+ professional reports
- Interactive charts
- Export to PDF, Excel, CSV

### Printing
- Bluetooth printers
- USB printers
- Wi-Fi printers
- Customizable receipt templates

### Backup & Sync
- Local backup
- Cloud backup (Google Drive ready)
- Automatic scheduled backups
- Offline sync with conflict resolution

---

## Building the APK

### Prerequisites
- Flutter SDK 3.22.0 or later
- Android SDK 35
- JDK 17

### Steps

```bash
# 1. Navigate to project
cd store_manager_pro

# 2. Get dependencies
flutter pub get

# 3. Clean build
flutter clean

# 4. Build APK
flutter build apk --release

# 5. Build AAB for Play Store
flutter build appbundle --release

# 6. Build for other platforms
flutter build ios --release
flutter build web --release
```

### Default Login
- **Username:** admin
- **Password:** admin123
- **Secret Code:** 200213570000 (first use only)

---

## Project Structure

```
lib/
├── core/           # Constants, Theme, Utils, Services
├── data/           # Models, Database
├── domain/         # Providers (Riverpod)
└── presentation/   # Screens & Widgets
```

---

## Dependencies

| Package | Purpose |
|---------|---------|
| flutter_riverpod | State management |
| sqflite | Local database |
| fl_chart | Charts & graphs |
| data_table_2 | Advanced data tables |
| pdf + printing | PDF generation & printing |
| barcode_widget + qr_flutter | Barcode & QR |
| local_auth | Biometric authentication |
| firebase_* | Cloud sync |
| encrypt | Database encryption |

---

## License

Proprietary - All rights reserved by Sami Banouh
