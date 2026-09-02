import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cá nhân', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
              child: Row(
                children: [
                  const CircleAvatar(radius: 32, backgroundColor: Color(0xFFEBF1FF), child: Icon(Icons.person, size: 36, color: Color(0xFF2F65E6))),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Nguyễn Văn A', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      SizedBox(height: 4),
                      Text('nguyenvana@example.com', style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                children: [
                  _buildListTile(Icons.person_outline, 'Thông tin cá nhân'),
                  const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFF1F5F9)),
                  _buildListTile(Icons.settings_outlined, 'Cài đặt ngân sách'),
                  const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFF1F5F9)),
                  _buildListTile(Icons.category_outlined, 'Danh mục chi tiêu'),
                  const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFF1F5F9)),
                  _buildListTile(Icons.backup_outlined, 'Sao lưu dữ liệu'),
                  const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFF1F5F9)),
                  _buildListTile(Icons.lock_outline, 'Đổi mật khẩu'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200)),
              child: _buildListTile(Icons.logout, 'Đăng xuất', color: const Color(0xFFEF4444)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {Color color = const Color(0xFF1E293B)}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
