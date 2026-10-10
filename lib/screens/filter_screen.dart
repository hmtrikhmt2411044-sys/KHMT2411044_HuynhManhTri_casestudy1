import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final String currentType;
  final String currentCategory;
  final String currentTimeRange;
  final DateTimeRange? customDateRange;

  const FilterScreen({
    super.key,
    required this.currentType,
    required this.currentCategory,
    required this.currentTimeRange,
    this.customDateRange,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late String _selectedType;
  late String _selectedCategory;
  late String _selectedTimeRange;
  DateTimeRange? _customDateRange;

  final List<String> _categories = [
    'Tất cả danh mục',
    'Ăn uống',
    'Mua sắm',
    'Đi lại',
    'Học tập',
    'Lương',
    'Khác'
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.currentType;
    _selectedCategory = widget.currentCategory;
    _selectedTimeRange = widget.currentTimeRange;
    _customDateRange = widget.customDateRange;
  }

  Future<void> _pickCustomDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _customDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2F65E6),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _customDateRange = picked;
        _selectedTimeRange = 'Tùy chỉnh';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bộ lọc',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Loại giao dịch
                      const Text(
                        'Loại giao dịch',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCheckboxOption('Tất cả'),
                      _buildCheckboxOption('Thu nhập'),
                      _buildCheckboxOption('Chi tiêu'),

                      const SizedBox(height: 24),

                      // 2. Danh mục
                      const Text(
                        'Danh mục',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                            items: _categories.map((String cat) {
                              return DropdownMenuItem<String>(
                                value: cat,
                                child: Text(
                                  cat,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF1E293B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // 3. Khoảng thời gian
                      const Text(
                        'Khoảng thời gian',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildRadioOption('Hôm nay'),
                      _buildRadioOption('7 ngày qua'),
                      _buildRadioOption('Tháng này'),
                      _buildRadioOption('Tùy chỉnh'),
                      if (_selectedTimeRange == 'Tùy chỉnh' && _customDateRange != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 36.0, top: 4.0),
                          child: Text(
                            'Từ ${_customDateRange!.start.day}/${_customDateRange!.start.month}/${_customDateRange!.start.year} đến ${_customDateRange!.end.day}/${_customDateRange!.end.month}/${_customDateRange!.end.year}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF2F65E6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Nút Áp dụng
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'type': _selectedType,
                        'category': _selectedCategory,
                        'timeRange': _selectedTimeRange,
                        'customDateRange': _customDateRange,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F65E6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Áp dụng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxOption(String type) {
    final bool isSelected = _selectedType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2F65E6) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? const Color(0xFF2F65E6) : const Color(0xFF94A3B8),
                  width: 1.8,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Text(
              type,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String timeOption) {
    final bool isSelected = _selectedTimeRange == timeOption;
    return InkWell(
      onTap: () async {
        if (timeOption == 'Tùy chỉnh') {
          await _pickCustomDateRange();
        } else {
          setState(() {
            _selectedTimeRange = timeOption;
          });
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF2F65E6) : const Color(0xFF94A3B8),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2F65E6),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Text(
              timeOption,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
