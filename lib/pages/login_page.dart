import 'package:flutter/material.dart';
import 'package:responsi_123220147/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isError = false;
  bool isObscure = true;

  // mengecek apakah ada login atau belum
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString("username");

    if (savedUsername != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(username: savedUsername),
      ));
    }
  }

  // inputan untuk login
  Future<void> _handleLogin() async {
    String message = "";
    if (_username.text == "123220147" && _password.text == "12345678") {
      message = "Berhasil Login";
      setState(() {
        isError = false;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", _username.text); // Simpan login

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(username: _username.text),
      ));
    } else {
      message = "Username atau Password salah";
      setState(() {
        isError = true;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 249, 255),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(40, 130, 40, 30),
        children: [
          const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          const SizedBox(height: 8),
          const Text("Welcome back!!"),
          const SizedBox(height: 25),
          TextField(
            controller: _username,
            decoration: InputDecoration(
              label: const Text("Username"),
              filled: true,
              fillColor: isError ? const Color.fromARGB(255, 255, 147, 139) : Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _password,
            obscureText: isObscure,
            decoration: InputDecoration(
              label: const Text("Password"),
              filled: true,
              fillColor: isError ? const Color.fromARGB(255, 255, 147, 139) : Colors.transparent,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                child: Icon(isObscure ? Icons.visibility_off : Icons.remove_red_eye),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: _handleLogin,
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
