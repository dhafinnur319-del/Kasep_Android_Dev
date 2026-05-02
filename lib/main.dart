import 'package:flutter/material.dart';
import 'services/hive_service.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final hiveService = HiveService();
  await hiveService.initHive();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasep App',
      theme: ThemeData(
        primaryColor: Color(0xFF007DF9),
        scaffoldBackgroundColor: Color(0xFFF3F9FF),
        fontFamily: 'Poppins',
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(
          role: ModalRoute.of(context)!.settings.arguments as String? ?? '',
          userId: '',
          userName: '',
        ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}