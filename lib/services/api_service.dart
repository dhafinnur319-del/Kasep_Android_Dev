import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  
  // GET semua berita (Public - tidak perlu token)
  Future<List<Map<String, dynamic>>> fetchBerita() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/berita'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Fetch Berita - Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        print('Failed to fetch berita: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetchBerita: $e');
      return [];
    }
  }
  
  // GET berita by ID (Public)
  Future<Map<String, dynamic>?> fetchBeritaById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/berita/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(json.decode(response.body));
      }
      return null;
    } catch (e) {
      print('Error fetchBeritaById: $e');
      return null;
    }
  }
}