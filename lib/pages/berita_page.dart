import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'detail_berita_page.dart';
import 'home_page.dart';

class BeritaPage extends StatefulWidget {
  final String? role;
  final String? userId;
  final String? userName;
  
  const BeritaPage({
    super.key, 
    this.role, 
    this.userId, 
    this.userName,
  });

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
  
  String _formatTanggal(dynamic tanggal) {
    if (tanggal == null) return '-';
    try {
      DateTime date = DateTime.parse(tanggal);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return tanggal.toString().split('T')[0];
    }
  }
  
  void _navigateToDetail(Map<String, dynamic> berita) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailBeritaPage(berita: berita),
      ),
    );
  }
  
  void _backToHome() {
    if (widget.role != null && widget.userId != null) {
      // Kembali ke HomePage dengan data yang ada
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            role: widget.role!,
            userId: widget.userId!,
            userName: widget.userName ?? '',
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _backToHome,
          tooltip: 'Kembali ke Menu Utama',
        ),
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
                  CircularProgressIndicator(color: Color(0xFF007DF9)),
                  SizedBox(height: 16),
                  Text('Memuat berita...'),
                ],
              ),
            )
          : _beritaList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.newspaper, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(_errorMessage.isEmpty ? 'Belum ada berita' : _errorMessage),
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
    String imageUrl = berita['imageUrl'] ?? '';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(berita),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageWidget(imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Text(
                      berita['summary'] ?? 
                      (berita['content']?.length > 80 
                          ? '${berita['content'].substring(0, 80)}...'
                          : berita['content'] ?? ''),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5F6368),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 12, color: Color(0xFF9AA0A6)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            berita['createdBy']?.toString() ?? 'Admin',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF9AA0A6)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.calendar_today, size: 12, color: Color(0xFF9AA0A6)),
                        const SizedBox(width: 4),
                        Text(
                          _formatTanggal(berita['createdAt'] ?? berita['tanggal']),
                          style: const TextStyle(fontSize: 11, color: Color(0xFF9AA0A6)),
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
    const double imageSize = 80;
    
    if (imageUrl.isNotEmpty) {
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
}