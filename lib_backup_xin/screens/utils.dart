import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(int amount) {
  final formatter = NumberFormat('#,###', 'vi_VN');
  return formatter.format(amount);
}

Map<String, dynamic> getCategoryConfig(String categoryName) {
  switch (categoryName) {
    case 'Ăn uống': return {'icon': Icons.restaurant, 'color': const Color(0xFFE55A5A)}; // Đỏ
    case 'Mua sắm': return {'icon': Icons.shopping_cart, 'color': const Color(0xFFF28F8F)}; // Đỏ nhạt/Cam
    case 'Đi lại': return {'icon': Icons.directions_car, 'color': const Color(0xFF67C278)}; // Xanh lá
    case 'Học tập': return {'icon': Icons.book, 'color': const Color(0xFF4A7DE8)}; // Xanh dương
    case 'Lương': return {'icon': Icons.monetization_on, 'color': const Color(0xFF10B981)}; 
    case 'Khác': return {'icon': Icons.category, 'color': const Color(0xFF9860E5)}; // Tím
    default: return {'icon': Icons.category, 'color': const Color(0xFF9860E5)};
  }
}
