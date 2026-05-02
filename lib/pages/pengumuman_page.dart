import 'package:flutter/material.dart';
import '../services/hive_service.dart';

class PengumumanPage extends StatelessWidget {
  final String role;
  
  const PengumumanPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final hiveService = HiveService();
    final pengumumanList = hiveService.getPengumumanByRole(role);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengumuman'),
        backgroundColor: Color(0xFF007DF9),
      ),
      body: pengumumanList.isEmpty
          ? Center(
              child: Text(
                'Belum ada pengumuman',
                style: TextStyle(color: Color(0xFF5F6368)),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: pengumumanList.length,
              itemBuilder: (context, index) {
                final pengumuman = pengumumanList[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pengumuman['judul'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          pengumuman['isi'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF5F6368),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: Color(0xFF5F6368)),
                            SizedBox(width: 4),
                            Text(
                              DateTime.parse(pengumuman['tanggal']).toString().split(' ')[0],
                              style: TextStyle(fontSize: 12, color: Color(0xFF5F6368)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}