import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/ai_service.dart';

class AiDashboardScreen extends ConsumerStatefulWidget {
  const AiDashboardScreen({super.key});

  @override
  ConsumerState<AiDashboardScreen> createState() => _AiDashboardScreenState();
}

class _AiDashboardScreenState extends ConsumerState<AiDashboardScreen> {
  final AIService _aiService = AIService();
  Map<String, dynamic>? _summary;
  List<Map<String, dynamic>>? _predictions;
  List<Map<String, dynamic>>? _profitability;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final summary = await _aiService.generateSmartSummary();
    final predictions = await _aiService.predictLowStock();
    final profitability = await _aiService.analyzeProductProfitability();
    setState(() {
      _summary = summary;
      _predictions = predictions;
      _profitability = profitability;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.psychology, color: AppColors.accent),
            SizedBox(width: 8),
            Text('المساعد الذكي'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadData();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSmartSummary(),
                  const SizedBox(height: 24),
                  _buildPredictionsCard(),
                  const SizedBox(height: 24),
                  _buildProfitabilityChart(),
                  const SizedBox(height: 24),
                  _buildRecommendations(),
                ],
              ),
            ),
    );
  }

  Widget _buildSmartSummary() {
    return Card(
      color: AppColors.primary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.insights, color: AppColors.primary),
                SizedBox(width: 8),
                Text('ملخص ذكي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInsightCard('مبيعات اليوم', '${_summary?['todaySales']?.toStringAsFixed(2) ?? '0'} ${AppConstants.currency}', Icons.today),
                _buildInsightCard('الفواتير', '${_summary?['todayInvoices'] ?? 0}', Icons.receipt),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInsightCard('المنتج الأكثر مبيعاً', '${_summary?['topProduct'] ?? 'لا يوجد'}', Icons.trending_up),
                _buildInsightCard('تنبيهات المخزون', '${_summary?['lowStockCount'] ?? 0}', Icons.warning_amber),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionsCard() {
    if (_predictions == null || _predictions!.isEmpty) {
      return const Card(child: ListTile(title: Text('لا توجد تنبيهات حالياً')));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning_amber, color: AppColors.error),
                SizedBox(width: 8),
                Text('تنبيهات نفاد المخزون', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ..._predictions!.take(5).map((p) => ListTile(
              leading: const Icon(Icons.inventory, color: AppColors.error),
              title: Text(p['name'] ?? 'منتج'),
              subtitle: Text('الكمية: ${p['quantity']} | أيام حتى النفاد: ${p['daysUntilStockout']}'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('إعادة طلب'),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitabilityChart() {
    if (_profitability == null || _profitability!.isEmpty) {
      return const SizedBox.shrink();
    }

    final topProducts = _profitability!.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تحليل ربحية المنتجات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: List.generate(topProducts.length, (index) {
                    final profit = (topProducts[index]['totalProfit'] as num?)?.toDouble() ?? 0;
                    return BarChartGroupData(
                      x: index,
                      barRods: [BarChartRodData(toY: profit, color: AppColors.success, width: 30)],
                    );
                  }),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          if (v.toInt() < topProducts.length) {
                            return Text(
                              topProducts[v.toInt()]['name'].toString().substring(0, topProducts[v.toInt()]['name'].toString().length > 8 ? 8 : topProducts[v.toInt()]['name'].toString().length),
                              style: const TextStyle(fontSize: 9),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: AppColors.accent),
                SizedBox(width: 8),
                Text('توصيات ذكية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            _buildRecommendation('زيادة مخزون المنتجات الأكثر مبيعاً بنسبة 20%'),
            _buildRecommendation('تطبيق خصم 10% على المنتجات التي لم تُباع منذ 30 يوماً'),
            _buildRecommendation('إعادة التفاوض مع الموردين لتقليل تكلفة الشراء'),
            _buildRecommendation('تفعيل نظام نقاط الولاء لزيادة الاحتفاظ بالعملاء'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendation(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
