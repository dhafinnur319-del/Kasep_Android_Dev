import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import 'login_page.dart';
import 'home_page.dart';

class GuruProfilePage extends StatelessWidget {
  final String userId;

  const GuruProfilePage({super.key, required this.userId});

  void _backToHome(BuildContext context) {
    // Ambil data user dari Hive
    final hiveService = HiveService();
    final user = hiveService.getUserById(userId);
    
    if (user != null) {
      // Kembali ke HomePage dengan data user
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            role: user['role'] ?? 'guru',
            userId: userId,
            userName: user['nama'] ?? 'Guru',
          ),
        ),
      );
    } else {
      // Fallback: pop sampai ke halaman pertama
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hiveService = HiveService();
    final user = hiveService.getUserById(userId);

    final Color primaryColor = const Color(0xFF007DF9);
    final Color textPrimaryColor = const Color(0xFF1A1A1A);
    final Color textSecondaryColor = const Color(0xFF5F6368);
    final Color backgroundColor = const Color(0xFFF3F9FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Profil Guru'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _backToHome(context),
          tooltip: 'Kembali ke Menu Utama',
        ),
      ),
      body: user == null
          ? Center(
              child: Text(
                'User tidak ditemukan',
                style: TextStyle(color: textSecondaryColor),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor, width: 3.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Color(0xFF007DF9),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Column(
                    children: [
                      Text(
                        user['nama'] ?? 'Nama Guru',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Guru ${user['mapel'] ?? 'Mata Pelajaran'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Guru Aktif',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoItem(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: user['email'] ?? 'guru@kasep.sch.id',
                          primaryColor: primaryColor,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildInfoItem(
                          icon: Icons.badge_outlined,
                          label: 'NIP',
                          value: user['nip'] ?? '-',
                          primaryColor: primaryColor,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildInfoItem(
                          icon: Icons.book_outlined,
                          label: 'Mata Pelajaran',
                          value: user['mapel'] ?? '-',
                          primaryColor: primaryColor,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildInfoItem(
                          icon: Icons.phone_outlined,
                          label: 'Telepon',
                          value: user['noTelp'] ?? '-',
                          primaryColor: primaryColor,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildInfoItem(
                          icon: Icons.wc_outlined,
                          label: 'Gender',
                          value: user['gender'] ?? 'Tidak diketahui',
                          primaryColor: primaryColor,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildInfoItem(
                          icon: Icons.cake_outlined,
                          label: 'Tanggal Lahir',
                          value: user['tanggalLahir'] ?? '1 Januari 1980',
                          primaryColor: primaryColor,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildInfoItem(
                          icon: Icons.location_on_outlined,
                          label: 'Alamat',
                          value: user['alamat'] ?? '-',
                          primaryColor: primaryColor,
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        _buildInfoItem(
                          icon: Icons.lock_outline,
                          label: 'Password',
                          value: '********',
                          primaryColor: primaryColor,
                          isPassword: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildMenuCard(
                          icon: Icons.assignment,
                          title: 'Tugas',
                          subtitle: 'Download materi tugas',
                          color: Colors.orange,
                          onTap: () {
                            // Navigasi ke halaman download Tugas
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur Tugas segera hadir')),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildMenuCard(
                          icon: Icons.library_books,
                          title: 'E-Perpustakaan',
                          subtitle: 'Download buku digital',
                          color: Colors.green,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur E-Perpustakaan segera hadir')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showLogoutDialog(context),
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5F6368),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF9AA0A6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color primaryColor,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5F6368),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isPassword ? Colors.grey.shade600 : const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF5F6368))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}