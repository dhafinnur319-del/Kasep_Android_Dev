import 'package:flutter/material.dart';
import 'berita_page.dart';
import 'pengumuman_page.dart';
import 'guru_profile_page.dart';
import 'siswa_profile_page.dart';

class HomePage extends StatefulWidget {
  final String role;
  final String userId;
  final String userName;
  
  const HomePage({
    super.key,
    required this.role,
    required this.userId,
    required this.userName,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  late List<Widget> _pages;
  
  @override
  void initState() {
    super.initState();
    
    _pages = [
      // Halaman Beranda
      _buildHomeContent(),
      
      // Halaman Berita
      BeritaPage(),
      
      // Halaman Pengumuman
      PengumumanPage(role: widget.role),
      
      // Halaman Profile
      widget.role == 'guru' 
          ? GuruProfilePage(userId: widget.userId)
          : SiswaProfilePage(userId: widget.userId),
    ];
  }
  
  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF007DF9), Color(0xFF005BB5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang,',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 5),
                Text(
                  widget.userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.role == 'guru' 
                      ? 'Kelola pembelajaran dengan mudah'
                      : 'Semangat belajar!',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 20),
          
          // Menu Grid
          Text(
            'Menu Cepat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildMenuCard(
                icon: Icons.newspaper,
                title: 'Berita',
                color: Colors.blue,
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
              _buildMenuCard(
                icon: Icons.announcement,
                title: 'Pengumuman',
                color: Colors.orange,
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
              ),
              _buildMenuCard(
                icon: Icons.person,
                title: 'Profil',
                color: Colors.green,
                onTap: () {
                  setState(() {
                    _selectedIndex = 3;
                  });
                },
              ),
              _buildMenuCard(
                icon: Icons.logout,
                title: 'Logout',
                color: Colors.red,
                onTap: () {
                  _showLogoutDialog();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Logout'),
        content: Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Color(0xFF007DF9),
        unselectedItemColor: Color(0xFF5F6368),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Berita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Pengumuman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}