import 'package:flutter/material.dart';
import 'package:fluttergsi/presentation/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttergsi/template/template.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Template t = Template();
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? token = await t.getString('token');

    if (token == '' || token == null) {
      // If not logged in, navigate back to login
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
    // If logged in, stay on HomeScreen
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
