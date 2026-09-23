// Buoi 4: Chia component cac tabs va giao dien
import 'package:flutter/material.dart';
import 'tabs/home_tab.dart';
import 'tabs/transaction_tab.dart';
import 'tabs/statistics_tab.dart';
import 'tabs/profile_tab.dart';
import 'add_edit_transaction_screen.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;
  
  Key _homeKey = UniqueKey();
  Key _transactionKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeTab(key: _homeKey),
          TransactionTab(key: _transactionKey),
          const StatisticsTab(),
          const ProfileTab(),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: const Color(0xFF2F65E6).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5)),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditTransactionScreen()));
            setState(() {
              _homeKey = UniqueKey();
              _transactionKey = UniqueKey();
            }); 
          },
          backgroundColor: const Color(0xFF2F65E6),
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: BottomAppBar(
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          elevation: 0,
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, Icons.home, 'Trang chá»§', 0),
                _buildNavItem(Icons.receipt_long_outlined, Icons.receipt_long, 'Giao dá»‹ch', 1),
                const SizedBox(width: 48),
                _buildNavItem(Icons.bar_chart_outlined, Icons.bar_chart, 'Thá»‘ng kĂª', 2),
                _buildNavItem(Icons.person_outline, Icons.person, 'CĂ¡ nhĂ¢n', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData activeIcon, String label, int index) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? const Color(0xFF2F65E6) : const Color(0xFF94A3B8);
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
