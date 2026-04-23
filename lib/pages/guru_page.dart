import 'package:flutter/material.dart';

class GuruPage extends StatelessWidget {
  const GuruPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard Guru")),
      body: Center(child: Text("Halaman Guru")),
    );
  }
}