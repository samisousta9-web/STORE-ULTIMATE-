import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/permission_service.dart';

class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  final PermissionService _permService = PermissionService();
  String _selectedRole = 'employee';

  final _roles = ['admin', 'accountant', 'employee', 'storekeeper'];
  final _modules = ['dashboard', 'products', 'sales', 'customers', 'suppliers', 'inventory', 'reports', 'settings', 'employees', 'accounting'];
  final _actions = ['view', 'create', 'edit', 'delete', 'export'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الصلاحيات')),
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.grey.shade50,
            child: ListView.builder(
              itemCount: _roles.length,
              itemBuilder: (context, index) {
                final role = _roles[index];
                return ListTile(
                  title: Text(role.toUpperCase()),
                  selected: role == _selectedRole,
                  selectedTileColor: AppColors.primary.withOpacity(0.1),
                  onTap: () => setState(() => _selectedRole = role),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: DataTable2(
                  columns: const [
                    DataColumn2(label: Text('الوحدة'), size: ColumnSize.L),
                    DataColumn2(label: Text('عرض'), size: ColumnSize.S),
                    DataColumn2(label: Text('إنشاء'), size: ColumnSize.S),
                    DataColumn2(label: Text('تعديل'), size: ColumnSize.S),
                    DataColumn2(label: Text('حذف'), size: ColumnSize.S),
                    DataColumn2(label: Text('تصدير'), size: ColumnSize.S),
                  ],
                  rows: _modules.map((module) => DataRow2(
                    cells: [
                      DataCell(Text(module)),
                      ..._actions.map((action) => DataCell(
                        FutureBuilder<bool>(
                          future: _permService.hasPermission(_selectedRole, module, action),
                          builder: (context, snapshot) {
                            final hasPerm = snapshot.data ?? false;
                            return Checkbox(
                              value: hasPerm,
                              onChanged: (v) async {
                                await _permService.updatePermission(_selectedRole, module, action, v ?? false);
                                setState(() {});
                              },
                            );
                          },
                        ),
                      )),
                    ],
                  )).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
