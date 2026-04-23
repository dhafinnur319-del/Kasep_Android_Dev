import 'package:flutter/material.dart';

class SiswaPage extends StatelessWidget {
  const SiswaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard Siswa")),
      body: Center(child: Text("Halaman Siswa")),
    );
  }
}