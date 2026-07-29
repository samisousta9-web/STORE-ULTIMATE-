import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users Table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        fullName TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        role TEXT NOT NULL,
        avatar TEXT,
        isActive INTEGER DEFAULT 1,
        useFingerprint INTEGER DEFAULT 0,
        pin TEXT,
        createdAt TEXT NOT NULL,
        lastLogin TEXT,
        permissions TEXT
      )
    ''');

    // Branches Table
    await db.execute('''
      CREATE TABLE branches (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        address TEXT,
        phone TEXT,
        managerName TEXT,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT NOT NULL
      )
    ''');

    // Categories Table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        icon TEXT,
        color TEXT,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT NOT NULL
      )
    ''');

    // Brands Table
    await db.execute('''
      CREATE TABLE brands (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        logo TEXT,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT NOT NULL
      )
    ''');

    // Products Table
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        image TEXT,
        barcode TEXT,
        qrCode TEXT,
        sku TEXT UNIQUE NOT NULL,
        categoryId INTEGER,
        brandId INTEGER,
        supplierId INTEGER,
        purchasePrice REAL NOT NULL,
        salePrice REAL NOT NULL,
        taxRate REAL DEFAULT 0,
        discount REAL DEFAULT 0,
        quantity INTEGER NOT NULL DEFAULT 0,
        minStock INTEGER DEFAULT 0,
        expiryDate TEXT,
        branchId INTEGER NOT NULL,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories(id),
        FOREIGN KEY (brandId) REFERENCES brands(id),
        FOREIGN KEY (supplierId) REFERENCES suppliers(id),
        FOREIGN KEY (branchId) REFERENCES branches(id)
      )
    ''');

    // Customers Table
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        address TEXT,
        balance REAL DEFAULT 0,
        debt REAL DEFAULT 0,
        loyaltyPoints INTEGER DEFAULT 0,
        notes TEXT,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT NOT NULL
      )
    ''');

    // Suppliers Table
    await db.execute('''
      CREATE TABLE suppliers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT,
        address TEXT,
        debt REAL DEFAULT 0,
        paid REAL DEFAULT 0,
        notes TEXT,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT NOT NULL
      )
    ''');

    // Sales Table
    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        invoiceNumber TEXT UNIQUE NOT NULL,
        customerId INTEGER,
        userId INTEGER NOT NULL,
        branchId INTEGER NOT NULL,
        subtotal REAL NOT NULL,
        taxAmount REAL NOT NULL,
        discountAmount REAL NOT NULL,
        total REAL NOT NULL,
        paid REAL NOT NULL,
        paymentMethod TEXT NOT NULL,
        paymentReference TEXT,
        status TEXT NOT NULL,
        notes TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (customerId) REFERENCES customers(id),
        FOREIGN KEY (userId) REFERENCES users(id),
        FOREIGN KEY (branchId) REFERENCES branches(id)
      )
    ''');

    // Sale Items Table
    await db.execute('''
      CREATE TABLE sale_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        saleId INTEGER NOT NULL,
        productId INTEGER NOT NULL,
        productName TEXT NOT NULL,
        unitPrice REAL NOT NULL,
        quantity INTEGER NOT NULL,
        discount REAL DEFAULT 0,
        tax REAL DEFAULT 0,
        total REAL NOT NULL,
        FOREIGN KEY (saleId) REFERENCES sales(id) ON DELETE CASCADE,
        FOREIGN KEY (productId) REFERENCES products(id)
      )
    ''');

    // Inventory Movements Table
    await db.execute('''
      CREATE TABLE inventory_movements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        type TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        fromBranchId INTEGER,
        toBranchId INTEGER,
        referenceId INTEGER,
        referenceType TEXT,
        notes TEXT,
        userId INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (productId) REFERENCES products(id),
        FOREIGN KEY (fromBranchId) REFERENCES branches(id),
        FOREIGN KEY (toBranchId) REFERENCES branches(id),
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Expenses Table
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        branchId INTEGER,
        userId INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (branchId) REFERENCES branches(id),
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Employees Table
    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        salary REAL NOT NULL,
        commissionRate REAL DEFAULT 0,
        hireDate TEXT NOT NULL,
        department TEXT,
        position TEXT,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Attendance Table
    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employeeId INTEGER NOT NULL,
        checkIn TEXT,
        checkOut TEXT,
        status TEXT,
        notes TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (employeeId) REFERENCES employees(id)
      )
    ''');


    // Companies Table
    await db.execute('''
      CREATE TABLE companies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        taxNumber TEXT,
        commercialRegister TEXT,
        address TEXT,
        phone TEXT,
        email TEXT,
        logo TEXT,
        currency TEXT DEFAULT 'DZD',
        defaultTaxRate TEXT,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT NOT NULL
      )
    ''');

    // Audit Logs Table
    await db.execute('''
      CREATE TABLE audit_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        action TEXT NOT NULL,
        tableName TEXT NOT NULL,
        recordId TEXT,
        oldValue TEXT,
        newValue TEXT,
        ipAddress TEXT,
        deviceInfo TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');

    // Coupons Table
    await db.execute('''
      CREATE TABLE coupons (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT UNIQUE NOT NULL,
        type TEXT NOT NULL,
        value REAL NOT NULL,
        minOrderAmount REAL,
        maxDiscount REAL,
        startDate TEXT,
        endDate TEXT,
        usageLimit INTEGER,
        usageCount INTEGER DEFAULT 0,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT NOT NULL
      )
    ''');

    // Ledger Table
    await db.execute('''
      CREATE TABLE ledger (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        accountCode TEXT NOT NULL,
        accountName TEXT NOT NULL,
        description TEXT NOT NULL,
        debit REAL,
        credit REAL,
        reference TEXT,
        documentNumber TEXT,
        userId INTEGER NOT NULL,
        companyId INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id),
        FOREIGN KEY (companyId) REFERENCES companies(id)
      )
    ''');

    // Batch Tracking Table
    await db.execute('''
      CREATE TABLE batch_tracking (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        batchNumber TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        expiryDate TEXT,
        purchaseDate TEXT,
        supplierId INTEGER,
        costPrice REAL,
        isActive INTEGER DEFAULT 1,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (productId) REFERENCES products(id),
        FOREIGN KEY (supplierId) REFERENCES suppliers(id)
      )
    ''');

    // Serial Numbers Table
    await db.execute('''
      CREATE TABLE serial_numbers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        serialNumber TEXT NOT NULL,
        status TEXT DEFAULT 'available',
        saleId INTEGER,
        warrantyExpiry TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (productId) REFERENCES products(id),
        FOREIGN KEY (saleId) REFERENCES sales(id)
      )
    ''');

    // Permissions Table
    await db.execute('''
      CREATE TABLE permissions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        role TEXT NOT NULL,
        module TEXT NOT NULL,
        canView INTEGER DEFAULT 0,
        canCreate INTEGER DEFAULT 0,
        canEdit INTEGER DEFAULT 0,
        canDelete INTEGER DEFAULT 0,
        canExport INTEGER DEFAULT 0,
        UNIQUE(role, module)
      )
    ''');

    // Insert default permissions
    final permissions = [
      ['admin', 'dashboard', 1, 1, 1, 1, 1],
      ['admin', 'products', 1, 1, 1, 1, 1],
      ['admin', 'sales', 1, 1, 1, 1, 1],
      ['admin', 'customers', 1, 1, 1, 1, 1],
      ['admin', 'suppliers', 1, 1, 1, 1, 1],
      ['admin', 'inventory', 1, 1, 1, 1, 1],
      ['admin', 'reports', 1, 1, 1, 1, 1],
      ['admin', 'settings', 1, 1, 1, 1, 1],
      ['admin', 'employees', 1, 1, 1, 1, 1],
      ['admin', 'accounting', 1, 1, 1, 1, 1],
      ['accountant', 'dashboard', 1, 0, 0, 0, 1],
      ['accountant', 'sales', 1, 0, 0, 0, 1],
      ['accountant', 'reports', 1, 0, 0, 0, 1],
      ['accountant', 'accounting', 1, 1, 1, 0, 1],
      ['employee', 'dashboard', 1, 0, 0, 0, 0],
      ['employee', 'sales', 1, 1, 0, 0, 0],
      ['employee', 'customers', 1, 1, 0, 0, 0],
      ['storekeeper', 'dashboard', 1, 0, 0, 0, 0],
      ['storekeeper', 'products', 1, 1, 1, 0, 0],
      ['storekeeper', 'inventory', 1, 1, 1, 0, 0],
    ];

    for (var perm in permissions) {
      await db.insert('permissions', {
        'role': perm[0],
        'module': perm[1],
        'canView': perm[2],
        'canCreate': perm[3],
        'canEdit': perm[4],
        'canDelete': perm[5],
        'canExport': perm[6],
      });
    }

    // Insert default company
    await db.insert('companies', {
      'name': 'شركتي',
      'taxNumber': '123456789',
      'address': 'الجزائر',
      'phone': '0782918108',
      'email': 'banouhsami13@gmail.com',
      'currency': 'DZD',
      'defaultTaxRate': '19',
      'isActive': 1,
      'createdAt': DateTime.now().toIso8601String(),
    });

    // Insert default admin user
    await db.insert('users', {
      'username': 'admin',
      'password': 'admin123',
      'fullName': 'Sami Banouh',
      'email': 'banouhsami13@gmail.com',
      'phone': '0782918108',
      'role': 'admin',
      'isActive': 1,
      'createdAt': DateTime.now().toIso8601String(),
      'permissions': 'all',
    });

    // Insert default branch
    await db.insert('branches', {
      'name': 'الفرع الرئيسي',
      'address': 'الجزائر',
      'phone': '0782918108',
      'managerName': 'Sami Banouh',
      'isActive': 1,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
