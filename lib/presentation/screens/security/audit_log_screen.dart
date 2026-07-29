import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/audit_service.dart';

class AuditLogScreen extends ConsumerStatefulWidget {
  const AuditLogScreen({super.key});

  @override
  ConsumerState<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends ConsumerState<AuditLogScreen> {
  final AuditService _auditService = AuditService();
  List<Map<String, dynamic>> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await _auditService.getAuditLogs(limit: 100);
    setState(() {
      _logs = logs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل العمليات'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download), onPressed: () {}),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: DataTable2(
                  columns: const [
                    DataColumn2(label: Text('التاريخ'), size: ColumnSize.S),
                    DataColumn2(label: Text('المستخدم'), size: ColumnSize.S),
                    DataColumn2(label: Text('العملية'), size: ColumnSize.S),
                    DataColumn2(label: Text('الجدول'), size: ColumnSize.S),
                    DataColumn2(label: Text('السجل'), size: ColumnSize.S),
                    DataColumn2(label: Text('القيمة القديمة'), size: ColumnSize.M),
                    DataColumn2(label: Text('القيمة الجديدة'), size: ColumnSize.M),
                  ],
                  rows: _logs.map((log) => DataRow2(
                    cells: [
                      DataCell(Text(log['createdAt']?.toString().substring(0, 16) ?? '')),
                      DataCell(Text('${log['userId']}')),
                      DataCell(_buildActionChip(log['action'])),
                      DataCell(Text(log['tableName'] ?? '')),
                      DataCell(Text(log['recordId'] ?? '')),
                      DataCell(Text(log['oldValue'] ?? '-', style: const TextStyle(fontSize: 11))),
                      DataCell(Text(log['newValue'] ?? '-', style: const TextStyle(fontSize: 11))),
                    ],
                  )).toList(),
                ),
              ),
            ),
    );
  }

  Widget _buildActionChip(String action) {
    Color color;
    switch (action) {
      case 'CREATE': color = AppColors.success; break;
      case 'UPDATE': color = AppColors.info; break;
      case 'DELETE': color = AppColors.error; break;
      case 'LOGIN': color = AppColors.primary; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(action, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}
