import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:i_love_philosophy/utils/security_utils.dart';
import 'package:i_love_philosophy/utils/responsive_ui.dart';

class User {
  final String username;
  final String password;

  User({required this.username, required this.password});

  Map<String, String> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, String> json) {
    return User(
      username: json['username']!,
      password: json['password']!,
    );
  }
}

class UserPreferencesScreen extends StatefulWidget {
  static String hashPassword(String rawPassword) {
    return SecurityUtils.hashPassword(rawPassword);
  }

  static Future<void> saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', user.username.trim());
    await prefs.setString('password', SecurityUtils.hashPassword(user.password));
  }

  static Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    if (username != null && password != null) {
      return User(username: username, password: password);
    }
    return null;
  }

  static Future<bool> verifyPassword(
      String username, String rawPassword) async {
    final user = await getUser();
    if (user == null) return false;
    if (user.username != username.trim()) return false;
    return SecurityUtils.verifyPassword(rawPassword, user.password);
  }

  const UserPreferencesScreen({super.key});

  @override
  UserPreferencesScreenState createState() => UserPreferencesScreenState();
}

class UserPreferencesScreenState extends State<UserPreferencesScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    User? user = await UserPreferencesScreen.getUser();
    if (user != null) {
      setState(() {
        _usernameController.text = user.username;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveUser() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرجاء تعبئة جميع الحقول')),
        );
      }
      return;
    }

    User user = User(
      username: _usernameController.text,
      password: _passwordController.text,
    );
    await UserPreferencesScreen.saveUser(user);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUI.fontBasis(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الحساب'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تعديل بيانات المستخدم',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    'اسم المستخدم',
                    'أدخل اسمك الجديد',
                    screenWidth,
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    'كلمة المرور الجديدة',
                    'أدخل كلمة مرور جديدة',
                    screenWidth,
                    obscure: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('حفظ التغييرات'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    double screenWidth, {
    bool obscure = false,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: screenWidth * 0.05),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
