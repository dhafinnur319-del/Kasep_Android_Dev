import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'home_page.dart'; // Update: langsung ke home_page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nisController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  // Color palette dari Group 12
  final Color primaryColor = const Color(0xFF007DF9);
  final Color primaryDarkColor = const Color(0xFF005BB5);
  final Color backgroundColor = const Color(0xFFF3F9FF);
  final Color textPrimaryColor = const Color(0xFF1A1A1A);
  final Color textThreeColor = const Color(0xFFC1C6CC);
  final Color textSecondaryColor = const Color(0xFF5F6368);

  void login(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(milliseconds: 500));

    var box = Hive.box('users');
    String nisNip = nisController.text.trim();
    String password = passwordController.text.trim();

    bool loginSuccess = false;
    String role = '';
    String userId = '';
    String userName = '';

    for (var key in box.keys) {
      var user = box.get(key);
      
      if ((user['nis'] != null && user['nis'] == nisNip) || 
          (user['nip'] != null && user['nip'] == nisNip)) {
        if (user['password'] == password) {
          loginSuccess = true;
          role = user['role'];
          userId = user['id']; // Ambil userId
          userName = user['nama'];
          break;
        }
      }
    }

    setState(() {
      isLoading = false;
    });

    if (loginSuccess) {
      // Langsung ke HomePage dengan membawa role dan userId
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            role: role,
            userId: userId,
            userName: userName,
          )
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login gagal! Periksa kembali NIS/NIP dan Password Anda"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDarkColor, 
      body: SafeArea(
        child: Column(
          children: [
            // 30% bagian atas (Biru Tua)
            Expanded(
              flex: 3, 
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: backgroundColor,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "KASEP",
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: backgroundColor,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Login untuk mengakses fitur pribadi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: textThreeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 70% bagian bawah (Putih Kebiruan)
            Expanded(
              flex: 7, 
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView( // Tambahkan SingleChildScrollView
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "NIS / NIP",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white, // Ubah ke putih agar lebih jelas
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: primaryDarkColor.withOpacity(0.3)),
                              ),
                              child: TextField(
                                controller: nisController,
                                style: TextStyle(fontSize: 16, color: textPrimaryColor),
                                decoration: InputDecoration(
                                  hintText: "Masukkan NIS / NIP",
                                  hintStyle: TextStyle(color: textSecondaryColor),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  prefixIcon: Icon(Icons.person_outline, color: primaryDarkColor),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            
                            Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white, // Ubah ke putih agar lebih jelas
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: primaryDarkColor.withOpacity(0.3)),
                              ),
                              child: TextField(
                                controller: passwordController,
                                obscureText: !isPasswordVisible,
                                style: TextStyle(fontSize: 16, color: textPrimaryColor),
                                decoration: InputDecoration(
                                  hintText: "Masukkan Password",
                                  hintStyle: TextStyle(color: textSecondaryColor),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.lock_outline, color: primaryDarkColor),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                      color: textSecondaryColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 30),
                            
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : () => login(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor, // Gunakan primaryColor
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text(
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                              ),
                            ),
                            
                            SizedBox(height: 20),
                            
                            // Informasi Login
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "✓ Login Siswa menggunakan NIS",
                                    style: TextStyle(fontSize: 12, color: textSecondaryColor),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "✓ Login Guru/Tendik Menggunakan NIP",
                                    style: TextStyle(fontSize: 12, color: textSecondaryColor),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "✓ Contoh: NIS (2024001) / NIP (198512342023011001)",
                                    style: TextStyle(fontSize: 12, color: textSecondaryColor),
                                  ),
                                ],
                              ),
                            ),
                            
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nisController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}