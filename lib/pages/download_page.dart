import 'package:flutter/material.dart';

class DownloadPage extends StatefulWidget {
  final String title;
  final String menuName;
  final Color color;

  const DownloadPage({
    super.key,
    required this.title,
    required this.menuName,
    required this.color,
  });

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  List<DownloadItem> _items = [];
  List<DownloadItem> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
    _searchResults = _items;
  }

  void _loadItems() {
    if (widget.menuName == 'Tugas') {
      _items = [
        const DownloadItem(
          title: 'Tugas Matematika - Bab 1',
          subtitle: 'Materi tentang persamaan linear',
          size: '2.5 MB',
          icon: Icons.functions,
          type: 'PDF',
        ),
        const DownloadItem(
          title: 'Tugas Bahasa Indonesia',
          subtitle: 'Materi tentang teks prosedur',
          size: '1.2 MB',
          icon: Icons.menu_book,
          type: 'DOCX',
        ),
        const DownloadItem(
          title: 'Tugas IPA - Praktikum',
          subtitle: 'Laporan praktikum fisika',
          size: '3.8 MB',
          icon: Icons.science,
          type: 'PPT',
        ),
        const DownloadItem(
          title: 'Tugas Inggris - Essay',
          subtitle: 'Writing descriptive text',
          size: '0.8 MB',
          icon: Icons.translate,
          type: 'DOC',
        ),
        const DownloadItem(
          title: 'Tugas Sejarah',
          subtitle: 'Materi tentang kemerdekaan',
          size: '4.2 MB',
          icon: Icons.history,
          type: 'PDF',
        ),
        const DownloadItem(
          title: 'Tugas PKN',
          subtitle: 'Materi tentang hak dan kewajiban',
          size: '1.5 MB',
          icon: Icons.account_balance,
          type: 'PDF',
        ),
      ];
    } else if (widget.menuName == 'E-Perpustakaan') {
      _items = [
        const DownloadItem(
          title: 'Buku Matematika Kelas XI',
          subtitle: 'Kurikulum Merdeka',
          size: '15 MB',
          icon: Icons.calculate,
          type: 'PDF',
        ),
        const DownloadItem(
          title: 'Novel - Laskar Pelangi',
          subtitle: 'Karya Andrea Hirata',
          size: '2 MB',
          icon: Icons.auto_stories,
          type: 'EPUB',
        ),
        const DownloadItem(
          title: 'E-Book Pemrograman Flutter',
          subtitle: 'Belajar Flutter dari dasar',
          size: '25 MB',
          icon: Icons.code,
          type: 'PDF',
        ),
        const DownloadItem(
          title: 'Kamus Inggris-Indonesia',
          subtitle: 'Edisi Terbaru',
          size: '8 MB',
          icon: Icons.translate,
          type: 'PDF',
        ),
        const DownloadItem(
          title: 'Buku Biologi SMA',
          subtitle: 'Materi kelas X, XI, XII',
          size: '12 MB',
          icon: Icons.biotech,
          type: 'PDF',
        ),
      ];
    }
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults = _items;
      } else {
        _searchResults = _items
            .where((item) =>
                item.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _downloadFile(DownloadItem item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            CircularProgressIndicator(color: widget.color),
            const SizedBox(height: 16),
            Text(
              'Mendownload ${item.title}...',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              '${item.size} • ${item.type}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.title} berhasil didownload!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F9FF),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterItems,
                decoration: InputDecoration(
                  hintText: 'Cari ${widget.menuName}...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _filterItems('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _searchResults.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada ${widget.menuName}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final item = _searchResults[index];
                return _buildDownloadCard(item);
              },
            ),
    );
  }

  Widget _buildDownloadCard(DownloadItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _downloadFile(item),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, size: 28, color: widget.color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.type,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.storage,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.size,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.download,
                    size: 20,
                    color: widget.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Model untuk item download
class DownloadItem {
  final String title;
  final String subtitle;
  final String size;
  final IconData icon;
  final String type;

  const DownloadItem({
    required this.title,
    required this.subtitle,
    required this.size,
    required this.icon,
    required this.type,
  });
}