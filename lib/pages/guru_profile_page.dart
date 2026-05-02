import 'package:flutter/material.dart';
import '../services/hive_service.dart';

class GuruProfilePage extends StatelessWidget {
  final String userId; // Perbaiki: userId (bukan userID)
  
  const GuruProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final hiveService = HiveService();
    final user = hiveService.getUserById(userId);
    
    // Definisikan warna langsung di sini (karena tidak pakai AppConstants)
    final Color primaryColor = const Color(0xFF007DF9);
    final Color backgroundColor = const Color(0xFFF3F9FF);
    final Color textPrimaryColor = const Color(0xFF1A1A1A);
    final Color textSecondaryColor = const Color(0xFF5F6368);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Guru'),
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        elevation: 0,
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
                  // Header Profile
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          user['nama'] ?? '-',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Guru ${user['mapel'] ?? ''}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Informasi Detail
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Pribadi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        _buildInfoCard(
                          icon: Icons.badge,
                          label: 'NIP',
                          value: user['nip'] ?? '-',
                          primaryColor: primaryColor,
                        ),
                        
                        _buildInfoCard(
                          icon: Icons.book,
                          label: 'Mata Pelajaran',
                          value: user['mapel'] ?? '-',
                          primaryColor: primaryColor,
                        ),
                        
                        _buildInfoCard(
                          icon: Icons.phone,
                          label: 'Nomor Telepon',
                          value: user['noTelp'] ?? '-',
                          primaryColor: primaryColor,
                        ),
                        
                        _buildInfoCard(
                          icon: Icons.location_on,
                          label: 'Alamat',
                          value: user['alamat'] ?? '-',
                          primaryColor: primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
  
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color primaryColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryColor),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5F6368),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}