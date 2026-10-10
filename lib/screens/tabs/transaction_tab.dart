import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../utils.dart';
import '../add_edit_transaction_screen.dart';
import '../filter_screen.dart';

class TransactionTab extends StatefulWidget {
  const TransactionTab({super.key});

  @override
  State<TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends State<TransactionTab> {
  String filterType = 'Tất cả';
  String filterCategory = 'Tất cả danh mục';
  String filterTimeRange = 'Tháng này';
  DateTimeRange? customDateRange;

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
    } catch (_) {}
    return null;
  }

  bool _isWithinDateRange(DateTime txDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(txDate.year, txDate.month, txDate.day);

    switch (filterTimeRange) {
      case 'Hôm nay':
        return targetDate.isAtSameMomentAs(today);
      case '7 ngày qua':
        final sevenDaysAgo = today.subtract(const Duration(days: 7));
        return targetDate.isAfter(sevenDaysAgo.subtract(const Duration(seconds: 1))) &&
            targetDate.isBefore(today.add(const Duration(days: 1)));
      case 'Tháng này':
        return targetDate.year == now.year && targetDate.month == now.month;
      case 'Tùy chỉnh':
        if (customDateRange != null) {
          final start = DateTime(
              customDateRange!.start.year, customDateRange!.start.month, customDateRange!.start.day);
          final end = DateTime(
              customDateRange!.end.year, customDateRange!.end.month, customDateRange!.end.day, 23, 59, 59);
          return targetDate.isAfter(start.subtract(const Duration(seconds: 1))) &&
              targetDate.isBefore(end.add(const Duration(seconds: 1)));
        }
        return true;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Giao dịch',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Color(0xFF2F65E6), size: 28),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilterScreen(
                          currentType: filterType,
                          currentCategory: filterCategory,
                          currentTimeRange: filterTimeRange,
                          customDateRange: customDateRange,
                        ),
                      ),
                    );

                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        filterType = result['type'] ?? 'Tất cả';
                        filterCategory = result['category'] ?? 'Tất cả danh mục';
                        filterTimeRange = result['timeRange'] ?? 'Tháng này';
                        customDateRange = result['customDateRange'];
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildFilterChip('Tất cả'),
                const SizedBox(width: 8),
                _buildFilterChip('Thu nhập'),
                const SizedBox(width: 8),
                _buildFilterChip('Chi tiêu'),
              ],
            ),
          ),
          if (filterCategory != 'Tất cả danh mục' || filterTimeRange != 'Tháng này')
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$filterCategory • $filterTimeRange',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              filterCategory = 'Tất cả danh mục';
                              filterTimeRange = 'Tháng này';
                              customDateRange = null;
                            });
                          },
                          child: const Icon(Icons.close, size: 14, color: Color(0xFF475569)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper.instance.readAllTransactions(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                var items = snapshot.data!;

                // 1. Lọc theo Loại (Thu nhập / Chi tiêu)
                if (filterType == 'Thu nhập') {
                  items = items.where((i) => i['isIncome'] == 1).toList();
                } else if (filterType == 'Chi tiêu') {
                  items = items.where((i) => i['isIncome'] == 0).toList();
                }

                // 2. Lọc theo Danh mục
                if (filterCategory != 'Tất cả danh mục') {
                  items = items.where((i) => i['category'] == filterCategory).toList();
                }

                // 3. Lọc theo Khoảng thời gian
                items = items.where((i) {
                  final dt = _parseDate(i['date']?.toString() ?? '');
                  if (dt == null) return true;
                  return _isWithinDateRange(dt);
                }).toList();

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      "Không có giao dịch phù hợp với bộ lọc",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isIncome = item['isIncome'] == 1;
                    final config = getCategoryConfig(item['category']);

                    return InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddEditTransactionScreen(transactionData: item),
                          ),
                        );
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: (config['color'] as Color).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(config['icon'] as IconData,
                                  color: config['color'] as Color, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['category'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['date'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${isIncome ? '+' : '-'}${formatCurrency(item['amount'])} đ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isIncome
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = filterType == label;
    return GestureDetector(
      onTap: () => setState(() => filterType = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2F65E6) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF2F65E6) : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
