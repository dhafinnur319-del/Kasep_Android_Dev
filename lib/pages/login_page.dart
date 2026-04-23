import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'guru_page.dart';
import 'siswa_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  LoginPage({super.key});

  void login(BuildContext context) {
    var box = Hive.box('users');
    String input = controller.text;

    bool loginSuccess = false;
    String role = '';

    for (var key in box.keys) {
      var user = box.get(key);

      if (user['nip'] == input || user['nis'] == input) {
        loginSuccess = true;
        role = user['role'];
        break;
      }
    }

    if (loginSuccess) {
      if (role == 'guru') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GuruPage()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SiswaPage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SekolahApp",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),

              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Masukkan NIP / NIS",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => login(context),
                  child: Text("Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}