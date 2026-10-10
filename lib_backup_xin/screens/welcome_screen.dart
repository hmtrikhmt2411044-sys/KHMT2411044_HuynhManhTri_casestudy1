import 'package:flutter/material.dart';
import 'main_tab_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // VẼ LẠI CÁI VÍ TIỀN 3D Y HỆT MẪU BẰNG CODE
              SizedBox(
                width: 140,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Tờ tiền xanh phía sau
                    Positioned(
                      top: 15, left: 25,
                      child: Transform.rotate(
                        angle: -0.2,
                        child: Container(width: 80, height: 50, decoration: BoxDecoration(color: const Color(0xFF67C278), borderRadius: BorderRadius.circular(4))),
                      ),
                    ),
                    // Tờ tiền xanh phía trước
                    Positioned(
                      top: 10, left: 40,
                      child: Transform.rotate(
                        angle: 0.1,
                        child: Container(width: 80, height: 50, decoration: BoxDecoration(color: const Color(0xFF4ADE80), borderRadius: BorderRadius.circular(4))),
                      ),
                    ),
                    // Thân ví màu xanh
                    Positioned(
                      bottom: 25,
                      child: Container(
                        width: 100, height: 60,
                        decoration: BoxDecoration(color: const Color(0xFF2F65E6), borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    // Nút bấm trên ví
                    Positioned(
                      bottom: 45, right: 35,
                      child: Container(
                        width: 10, height: 10,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text('Expense Manager', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
              const SizedBox(height: 16),
              const Text('Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color(0xFF64748B), height: 1.5, fontWeight: FontWeight.w500)),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainTabScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F65E6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Nút bo nhẹ chứ ko bo tròn hẳn
                  ),
                  child: const Text('Bắt đầu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
