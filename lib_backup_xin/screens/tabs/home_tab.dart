import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../utils.dart';
import '../add_edit_transaction_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  void _refreshData() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.readAllTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final transactions = snapshot.data ?? [];
          
          int totalIncome = 0;
          int totalExpense = 0;
          for (var t in transactions) {
            int amt = t['amount'] as int;
            if (t['isIncome'] == 1) totalIncome += amt;
            else totalExpense += amt;
          }
          int balance = totalIncome - totalExpense;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildBalanceCard(balance),
                _buildIncomeExpenseCards(totalIncome, totalExpense),
                _buildRecentTransactions(transactions),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Xin chào!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              SizedBox(height: 4),
              Text('Hôm nay là một ngày tốt lành!', style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
            ],
          ),
          Container(
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEBF1FF)),
            padding: const EdgeInsets.all(12),
            child: const Icon(Icons.person, color: Color(0xFF2F65E6), size: 24),
          )
        ],
      ),
    );
  }

  Widget _buildBalanceCard(int balance) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF2F65E6),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: const Color(0xFF2F65E6).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Số dư hiện tại', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 18),
                )
              ],
            ),
            const SizedBox(height: 12),
            Text('${formatCurrency(balance)} đ', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseCards(int income, int expense) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Row(
        children: [
          Expanded(child: _buildInfoCard(true, income)),
          const SizedBox(width: 16),
          Expanded(child: _buildInfoCard(false, expense)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(bool isIncome, int amount) {
    final bgColor = isIncome ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);
    final iconColor = isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final arrowIcon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;
    final label = isIncome ? 'Thu nhập' : 'Chi tiêu';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(arrowIcon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('${formatCurrency(amount)} đ', style: TextStyle(color: iconColor, fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(List<Map<String, dynamic>> transactions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Chi tiêu gần đây', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              Text('Xem tất cả', style: TextStyle(fontSize: 14, color: Color(0xFF2F65E6), fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          if (transactions.isEmpty) 
            const Padding(padding: EdgeInsets.all(20), child: Text("Chưa có giao dịch", style: TextStyle(color: Colors.grey))),
          for (var item in transactions.take(5))
            _buildTransactionItem(item)
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> item) {
    final isIncome = item['isIncome'] == 1;
    final config = getCategoryConfig(item['category']);
    
    return InkWell(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditTransactionScreen(transactionData: item)));
        _refreshData();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: (config['color'] as Color).withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
              child: Icon(config['icon'] as IconData, color: config['color'] as Color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['category'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                  const SizedBox(height: 4),
                  Text(item['date'], style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '-'}${formatCurrency(item['amount'])} đ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
            )
          ],
        ),
      ),
    );
  }
}
