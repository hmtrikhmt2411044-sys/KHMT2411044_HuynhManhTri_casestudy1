import 'dart:math';
import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../utils.dart';

class StatisticsTab extends StatefulWidget {
  const StatisticsTab({super.key});

  @override
  State<StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  String timeFilter = 'Tháng này';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Text('Thống kê', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(child: _buildTimeFilter('Tháng này')),
                const SizedBox(width: 8),
                Expanded(child: _buildTimeFilter('Tháng trước')),
                const SizedBox(width: 8),
                Expanded(child: _buildTimeFilter('Năm nay')),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper.instance.readAllTransactions(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                // Chỉ tính chi tiêu
                final expenses = snapshot.data!.where((i) => i['isIncome'] == 0).toList();
                
                if (expenses.isEmpty) {
                  return const Center(child: Text("Chưa có chi tiêu nào", style: TextStyle(color: Colors.grey)));
                }

                // Nhóm theo category
                Map<String, int> categoryTotals = {};
                int totalExpense = 0;
                for (var item in expenses) {
                  final cat = item['category'] as String;
                  final amount = item['amount'] as int;
                  categoryTotals[cat] = (categoryTotals[cat] ?? 0) + amount;
                  totalExpense += amount;
                }

                // Sắp xếp giảm dần
                var sortedEntries = categoryTotals.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));

                return Column(
                  children: [
                    // BIỂU ĐỒ TRÒN (DONUT CHART) THẬT SỰ BẰNG CODE
                    SizedBox(
                      height: 200,
                      child: CustomPaint(
                        painter: DonutChartPainter(categories: sortedEntries, total: totalExpense),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${formatCurrency(totalExpense)} đ', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                              const SizedBox(height: 4),
                              const Text('Tổng chi tiêu', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // LEGEND
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        itemCount: sortedEntries.length,
                        itemBuilder: (context, index) {
                          final entry = sortedEntries[index];
                          final percentage = (entry.value / totalExpense * 100).round();
                          final config = getCategoryConfig(entry.key);
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              children: [
                                Container(width: 14, height: 14, decoration: BoxDecoration(color: config['color'], shape: BoxShape.circle)),
                                const SizedBox(width: 16),
                                Text(entry.key, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
                                const Spacer(),
                                Text('${formatCurrency(entry.value)} đ', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 40,
                                  child: Text('$percentage%', textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              }
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimeFilter(String label) {
    final isSelected = timeFilter == label;
    return GestureDetector(
      onTap: () => setState(() => timeFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2F65E6) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? const Color(0xFF2F65E6) : Colors.grey.shade200)
        ),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF64748B), fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    );
  }
}

// LỚP VẼ BIỂU ĐỒ DONUT (KHÔNG CẦN THƯ VIỆN)
class DonutChartPainter extends CustomPainter {
  final List<MapEntry<String, int>> categories;
  final int total;

  DonutChartPainter({required this.categories, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    const strokeWidth = 35.0; // Độ dày của viền Donut

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double startAngle = -pi / 2; // Bắt đầu vẽ từ đỉnh (12 giờ)

    for (var entry in categories) {
      final sweepAngle = (entry.value / total) * 2 * pi;
      final config = getCategoryConfig(entry.key);
      paint.color = config['color'];
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
