import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../utils.dart';
import '../add_edit_transaction_screen.dart';

class TransactionTab extends StatefulWidget {
  const TransactionTab({super.key});

  @override
  State<TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends State<TransactionTab> {
  String filterType = 'Tất cả';

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
                const Text('Giao dịch', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                Icon(Icons.filter_list, color: const Color(0xFF2F65E6), size: 28),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Expanded(child: _buildFilterChip('Tất cả')),
                  Expanded(child: _buildFilterChip('Thu nhập')),
                  Expanded(child: _buildFilterChip('Chi tiêu')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DatabaseHelper.instance.readAllTransactions(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                var items = snapshot.data!;
                if (filterType == 'Thu nhập') items = items.where((i) => i['isIncome'] == 1).toList();
                if (filterType == 'Chi tiêu') items = items.where((i) => i['isIncome'] == 0).toList();

                if (items.isEmpty) {
                  return const Center(child: Text("Không có giao dịch nào", style: TextStyle(color: Colors.grey)));
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
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditTransactionScreen(transactionData: item)));
                        setState((){});
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(20), 
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))]
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(color: (config['color'] as Color).withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
                              child: Icon(config['icon'] as IconData, color: config['color'] as Color, size: 24)
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['category'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                                  const SizedBox(height: 6),
                                  Text(item['date'], style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                                ],
                              ),
                            ),
                            Text('${isIncome ? '+' : '-'}${formatCurrency(item['amount'])} đ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444)))
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2F65E6) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF64748B), fontWeight: FontWeight.w600, fontSize: 13)),
      ),
    );
  }
}
