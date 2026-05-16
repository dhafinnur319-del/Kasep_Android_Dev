import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailBeritaPage extends StatelessWidget {
  final Map<String, dynamic> berita;

  const DetailBeritaPage({super.key, required this.berita});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF007DF9);
    final Color textPrimaryColor = const Color(0xFF1A1A1A);
    final Color textSecondaryColor = const Color(0xFF5F6368);

    // Format tanggal
    String formattedDate = _formatDate(berita['createdAt'] ?? berita['tanggal']);
    
    // Nama pembuat
    String author = berita['createdBy']?.toString() ?? berita['penulis'] ?? 'Admin';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Berita',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar berita (jika ada)
            if (berita['imageUrl'] != null && berita['imageUrl'].toString().isNotEmpty)
              _buildImageWidget(berita['imageUrl']),
            
            // Container putih untuk konten
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Berita
                  Text(
                    berita['title'] ?? 'Judul Berita',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Author dan Tanggal
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF007DF9).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Color(0xFF007DF9),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        author,
                        style: TextStyle(
                          fontSize: 13,
                          color: textSecondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Color(0xFF9AA0A6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 13,
                          color: textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Divider
                  Container(
                    height: 2,
                    width: 40,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Konten Berita
                  Text(
                    berita['content'] ?? berita['deskripsi'] ?? 'Tidak ada konten',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Color(0xFF3C4043),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
      ),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / 
                    loadingProgress.expectedTotalBytes!
                  : null,
              color: const Color(0xFF007DF9),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF007DF9).withOpacity(0.7),
                  const Color(0xFF007DF9).withOpacity(0.3),
                ],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 48,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gambar tidak tersedia',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Tanggal tidak tersedia';
    
    try {
      DateTime parsedDate = DateTime.parse(date);
      // Format: Selasa, 10 Mei 2026
      return DateFormat('EEEE, d MMMM yyyy', 'id').format(parsedDate);
    } catch (e) {
      return date.toString().split('T')[0];
    }
  }
}