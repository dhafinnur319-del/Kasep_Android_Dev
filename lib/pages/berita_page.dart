import 'package:flutter/material.dart';
import '../services/hive_service.dart';

class BeritaPage extends StatelessWidget {
  const BeritaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hiveService = HiveService();
    final beritaList = hiveService.getAllBerita();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita'),
        backgroundColor: Color(0xFF007DF9),
      ),
      body: beritaList.isEmpty
          ? Center(
              child: Text(
                'Belum ada berita',
                style: TextStyle(color: Color(0xFF5F6368)),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: beritaList.length,
              itemBuilder: (context, index) {
                final berita = beritaList[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          berita['judul'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          berita['deskripsi'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF5F6368),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person, size: 14, color: Color(0xFF5F6368)),
                            SizedBox(width: 4),
                            Text(
                              berita['penulis'],
                              style: TextStyle(fontSize: 12, color: Color(0xFF5F6368)),
                            ),
                            SizedBox(width: 16),
                            Icon(Icons.calendar_today, size: 14, color: Color(0xFF5F6368)),
                            SizedBox(width: 4),
                            Text(
                              DateTime.parse(berita['tanggal']).toString().split(' ')[0],
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