import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String userBox = 'users';
  static const String beritaBox = 'berita';
  static const String pengumumanBox = 'pengumuman';
  
  Future<void> initHive() async {
    // Inisialisasi Hive
    await Hive.initFlutter();
    
    // Buka boxes - gunakan static constant sebagai nama box
    await Hive.openBox(userBox);      // 'users'
    await Hive.openBox(beritaBox);    // 'berita'
    await Hive.openBox(pengumumanBox); // 'pengumuman'
    
    // Inisialisasi sample data
    await initSampleData();
  }
  
  Future<void> initSampleData() async {
    // Gunakan nama variable yang berbeda dari static constant
    final usersBox = Hive.box(userBox);           // ← pakai usersBox, bukan userBox
    final beritasBox = Hive.box(beritaBox);       // ← pakai beritasBox
    final pengumumansBox = Hive.box(pengumumanBox); // ← pakai pengumumansBox
    
    if (usersBox.isEmpty) {
      // Data Guru
      await usersBox.put('guru_1', {
        'id': 'guru_1',
        'nama': 'Budi Santoso, S.Pd',
        'role': 'guru',
        'nip': '198512342023011001',
        'password': 'guru123',
        'mapel': 'Matematika',
        'noTelp': '081234567890',
        'alamat': 'Jl. Pendidikan No. 123',
      });
      
      await usersBox.put('guru_2', {
        'id': 'guru_2',
        'nama': 'Heri Setyawan, M.Kom',
        'role': 'guru',
        'nip': '198803152024021002',
        'password': 'guru456',
        'mapel': 'Pemrograman',
        'noTelp': '081234567891',
        'alamat': 'Jl. Teknologi No. 45',
      });
      
      // Data Siswa
      await usersBox.put('siswa_1', {
        'id': 'siswa_1',
        'nama': 'Andi Prasetyo',
        'role': 'siswa',
        'nis': '2024001',
        'password': 'siswa123',
        'kelas': 'XI RPL 1',
        'jurusan': 'Rekayasa Perangkat Lunak',
        'noTelp': '081234567892',
        'alamat': 'Jl. Merdeka No. 67',
      });
      
      await usersBox.put('siswa_2', {
        'id': 'siswa_2',
        'nama': 'Andika Putra',
        'role': 'siswa',
        'nis': '2024002',
        'password': 'siswa456',
        'kelas': 'XI RPL 1',
        'jurusan': 'Rekayasa Perangkat Lunak',
        'noTelp': '081234567893',
        'alamat': 'Jl. Sudirman No. 89',
      });
    }
    
    if (beritasBox.isEmpty) {
      await beritasBox.put('berita_1', {
        'id': 'berita_1',
        'judul': 'Penerimaan Peserta Didik Baru 2026',
        'deskripsi': 'Pendaftaran siswa baru tahun ajaran 2026/2027 telah dibuka. Silakan daftar secara online melalui website sekolah.',
        'tanggal': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
        'penulis': 'Admin Sekolah',
      });
      
      await beritasBox.put('berita_2', {
        'id': 'berita_2',
        'judul': 'Juara Lomba Robotics Tingkat Nasional',
        'deskripsi': 'Tim Robotics sekolah berhasil meraih juara 1 dalam lomba robotics tingkat nasional.',
        'tanggal': DateTime.now().subtract(Duration(days: 5)).toIso8601String(),
        'penulis': 'Humas Sekolah',
      });
    }
    
    if (pengumumansBox.isEmpty) {
      await pengumumansBox.put('pengumuman_1', {
        'id': 'pengumuman_1',
        'judul': 'Libur Semester Genap',
        'isi': 'Diumumkan kepada seluruh siswa bahwa libur semester genap akan dilaksanakan pada tanggal 20-30 Juni 2026.',
        'tanggal': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        'targetRole': 'all',
      });
      
      await pengumumansBox.put('pengumuman_2', {
        'id': 'pengumuman_2',
        'judul': 'Pembagian Rapor',
        'isi': 'Pengambilan rapor semester genap dilaksanakan pada tanggal 25 Juni 2026 pukul 08.00 - 12.00 WIB.',
        'tanggal': DateTime.now().subtract(Duration(days: 3)).toIso8601String(),
        'targetRole': 'siswa',
      });
    }
  }
  
  Map<String, dynamic>? getUserById(String id) {
    final usersBox = Hive.box(userBox);
    final user = usersBox.get(id);
    return user != null ? Map<String, dynamic>.from(user) : null;
  }
  
  List<Map<String, dynamic>> getAllBerita() {
    final beritasBox = Hive.box(beritaBox);
    final List<Map<String, dynamic>> beritaList = [];
    
    for (var key in beritasBox.keys) {
      final data = beritasBox.get(key);
      beritaList.add(Map<String, dynamic>.from(data));
    }
    
    beritaList.sort((a, b) {
      final dateA = DateTime.parse(a['tanggal']);
      final dateB = DateTime.parse(b['tanggal']);
      return dateB.compareTo(dateA);
    });
    
    return beritaList;
  }
  
  List<Map<String, dynamic>> getPengumumanByRole(String role) {
    final pengumumansBox = Hive.box(pengumumanBox);
    final List<Map<String, dynamic>> pengumumanList = [];
    
    for (var key in pengumumansBox.keys) {
      final data = pengumumansBox.get(key);
      final targetRole = data['targetRole'];
      
      if (targetRole == 'all' || targetRole == role) {
        pengumumanList.add(Map<String, dynamic>.from(data));
      }
    }
    
    pengumumanList.sort((a, b) {
      final dateA = DateTime.parse(a['tanggal']);
      final dateB = DateTime.parse(b['tanggal']);
      return dateB.compareTo(dateA);
    });
    
    return pengumumanList;
  }
}