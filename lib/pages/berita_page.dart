import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BeritaPage extends StatefulWidget {
  const BeritaPage({super.key});

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  final ApiService _apiService = ApiService();
  
  List<Map<String, dynamic>> _beritaList = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _loadBerita();
  }
  
  Future<void> _loadBerita() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final berita = await _apiService.fetchBerita();
      
      setState(() {
        _beritaList = berita;
        _isLoading = false;
      });
      
      if (berita.isEmpty) {
        setState(() {
          _errorMessage = 'Belum ada berita';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat berita: $e';
      });
    }
  }
  
  Future<void> _onRefresh() async {
    await _loadBerita();
  }
  
  String _formatTanggal(dynamic tanggalValue) {
    if (tanggalValue == null) return '-';
    
    String tanggalStr = '';
    
    // Jika tanggalValue adalah String
    if (tanggalValue is String) {
      tanggalStr = tanggalValue;
    }
    // Jika tanggalValue adalah Map (misalnya berita object)
    else if (tanggalValue is Map) {
      // Prioritaskan field 'tanggal' manual
      if (tanggalValue.containsKey('tanggal') && tanggalValue['tanggal'] != null) {
        tanggalStr = tanggalValue['tanggal'].toString();
      }
      // Jika tidak ada, pakai 'createdAt' dari timestamps
      else if (tanggalValue.containsKey('createdAt') && tanggalValue['createdAt'] != null) {
        tanggalStr = tanggalValue['createdAt'].toString();
      }
      else {
        return '-';
      }
    }
    else {
      return '-';
    }
    
    // Parse tanggal
    try {
      // Coba parse dengan format ISO
      DateTime date = DateTime.parse(tanggalStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      // Jika gagal, coba split string
      try {
        String cleanDate = tanggalStr.split('T')[0];
        List<String> parts = cleanDate.split('-');
        if (parts.length == 3) {
          return '${parts[2]}/${parts[1]}/${parts[0]}';
        }
        return cleanDate;
      } catch (e2) {
        return tanggalStr;
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita'),
        backgroundColor: const Color(0xFF007DF9),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF007DF9),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Memuat berita...',
                    style: TextStyle(color: Color(0xFF5F6368)),
                  ),
                ],
              ),
            )
          : _beritaList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.newspaper,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage.isEmpty ? 'Belum ada berita' : _errorMessage,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadBerita,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Muat Ulang'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007DF9),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: const Color(0xFF007DF9),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _beritaList.length,
                    itemBuilder: (context, index) {
                      final berita = _beritaList[index];
                      return _buildBeritaCard(berita);
                    },
                  ),
                ),
    );
  }
  
  Widget _buildBeritaCard(Map<String, dynamic> berita) {
    // Gambar placeholder atau dari cloudinaryId
    String imageUrl = berita['cloudinaryId'] != null 
        ? 'https://res.cloudinary.com/your-cloud/image/upload/${berita['cloudinaryId']}'
        : '';
    
    // Ambil tanggal (prioritaskan field 'tanggal' manual)
    String tanggalDisplay = '';
    if (berita['tanggal'] != null) {
      tanggalDisplay = _formatTanggal(berita['tanggal']);
    } else if (berita['createdAt'] != null) {
      tanggalDisplay = _formatTanggal(berita['createdAt']);
    } else {
      tanggalDisplay = '-';
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showBeritaDetail(context, berita);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kotak Gambar di Kiri
              _buildImageWidget(imageUrl),
              
              const SizedBox(width: 12),
              
              // Konten di Kanan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      berita['title'] ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Content (deskripsi singkat)
                    Text(
                      berita['content'] ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5F6368),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Author & Date
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 12,
                          color: Color(0xFF9AA0A6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            berita['createdBy'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9AA0A6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Color(0xFF9AA0A6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tanggalDisplay,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9AA0A6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildImageWidget(String imageUrl) {
    // Ukuran kotak gambar
    const double imageSize = 80;
    
    if (imageUrl.isNotEmpty) {
      // Jika ada gambar dari cloudinary
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage(imageSize);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / 
                          loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      // Placeholder jika tidak ada gambar
      return _buildPlaceholderImage(imageSize);
    }
  }
  
  Widget _buildPlaceholderImage(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F9FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF007DF9).withOpacity(0.2)),
      ),
      child: const Icon(
        Icons.image_outlined,
        size: 32,
        color: Color(0xFF007DF9),
      ),
    );
  }
  
  void _showBeritaDetail(BuildContext context, Map<String, dynamic> berita) {
    // Ambil tanggal untuk detail
    String tanggalDisplay = '';
    if (berita['tanggal'] != null) {
      tanggalDisplay = _formatTanggal(berita['tanggal']);
    } else if (berita['createdAt'] != null) {
      tanggalDisplay = _formatTanggal(berita['createdAt']);
    } else {
      tanggalDisplay = '-';
    }
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar besar jika ada
                        if (berita['cloudinaryId'] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://res.cloudinary.com/your-cloud/image/upload/${berita['cloudinaryId']}',
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                            ),
                          ),
                        
                        if (berita['cloudinaryId'] != null)
                          const SizedBox(height: 16),
                        
                        // Title
                        Text(
                          berita['title'] ?? 'No Title',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Author & Date
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              berita['createdBy'] ?? 'Unknown',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tanggalDisplay,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        
                        const Divider(height: 24),
                        
                        // Content
                        Text(
                          berita['content'] ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: Color(0xFF3C4043),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}