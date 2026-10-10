import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class AddEditTransactionScreen extends StatefulWidget {
  final Map<String, dynamic>? transactionData;

  const AddEditTransactionScreen({super.key, this.transactionData});

  @override
  State<AddEditTransactionScreen> createState() => _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  bool isExpense = true;
  String selectedCategory = 'Ăn uống';
  late TextEditingController amountController;
  late TextEditingController noteController;
  DateTime selectedDate = DateTime.now();

  final List<String> categories = ['Ăn uống', 'Mua sắm', 'Học tập', 'Lương', 'Đi lại', 'Khác'];

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    noteController = TextEditingController();

    if (widget.transactionData != null) {
      final data = widget.transactionData!;
      isExpense = data['isIncome'] == 0;
      selectedCategory = data['category'];
      amountController.text = data['amount'].toString();
      noteController.text = data['note'] ?? '';
      try {
        final parts = data['date'].toString().split('/');
        selectedDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      } catch (_) {}
    }
  }

  void _saveDataToDB() async {
    if (amountController.text.trim().isEmpty) return;
    int amount = int.tryParse(amountController.text) ?? 0;
    
    String formattedDate = "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}";

    Map<String, dynamic> row = {
      'category': selectedCategory,
      'amount': amount,
      'isIncome': isExpense ? 0 : 1,
      'date': formattedDate,
      'note': noteController.text.trim(),
    };

    if (widget.transactionData != null) {
      await DatabaseHelper.instance.updateTransaction(row, widget.transactionData!['id']);
    } else {
      await DatabaseHelper.instance.insertTransaction(row);
    }
    
    if(mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.transactionData != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Sửa giao dịch' : 'Thêm giao dịch', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isExpense = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isExpense ? const Color(0xFFEF4444) : Colors.white,
                      foregroundColor: isExpense ? Colors.white : Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isExpense ? Colors.transparent : Colors.grey.shade300))
                    ),
                    child: const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text('Chi tiêu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isExpense = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isExpense ? const Color(0xFF10B981) : Colors.white,
                      foregroundColor: !isExpense ? Colors.white : Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: !isExpense ? Colors.transparent : Colors.grey.shade300))
                    ),
                    child: const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text('Thu nhập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            const Text('Danh mục', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  icon: const Icon(Icons.expand_more, color: Colors.grey),
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)))).toList(),
                  onChanged: (v) => setState(() => selectedCategory = v!),
                )
              )
            ),
            const SizedBox(height: 24),
            
            const Text('Số tiền', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: 'Nhập số tiền',
                suffixText: 'đ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1D56D8), width: 2)),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Ngày giao dịch', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                 final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2101));
                 if (picked != null) setState(() => selectedDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Ghi chú', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              maxLines: 3,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Nhập ghi chú (tùy chọn)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
              ),
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveDataToDB,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D56D8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('Lưu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
