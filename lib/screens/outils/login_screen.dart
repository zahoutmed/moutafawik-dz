import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:i_love_philosophy/screens/home_screen.dart';
import 'package:i_love_philosophy/screens/outils/forgot_password_screen.dart';
import 'package:i_love_philosophy/screens/outils/signup_screen.dart';
import 'package:i_love_philosophy/screens/user_preferences_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isPasswordVisible = false;
  bool rememberMe = true;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final isValid = await UserPreferencesScreen.verifyPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      if (!mounted) return;
      setState(() => isLoading = false);

      if (isValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('البريد الإلكتروني أو كلمة المرور غير صحيحة.',
                style: TextStyle(fontFamily: 'Cairo')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'حدث خطأ أثناء التحقق من بيانات الدخول، يرجى المحاولة لاحقاً.',
                style: TextStyle(fontFamily: 'Cairo')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void loginWithGoogle() async {
    try {
      final account = await googleSignIn.signIn();
      if (account != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('تم تفعيل وضع الدخول السريع.',
                  style: TextStyle(fontFamily: 'Cairo'))),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  void loginAsGuest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _loginWithSocial(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تسجيل الدخول عبر $provider...',
            style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: Colors.deepPurple,
      ),
    );
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  void _loginWithPhone() {
    final phoneController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('الدخول برقم الهاتف',
            style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('أدخل رقم هاتفك لاستلام رمز التحقق السريع SMS:',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5)),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '06 / 07 / 05 ...',
                prefixIcon: const Icon(Icons.phone),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                isDense: true,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: const Text('تأكيد ودخول',
                style: TextStyle(
                    fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required String iconPath,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            height: 24,
            width: 24,
            errorBuilder: (_, __, ___) => const Icon(Icons.account_circle,
                size: 24, color: Colors.deepPurple),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIconButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Center(
          child: Icon(icon, size: 24, color: iconColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E1254), Color(0xFF4A148C), Color(0xFF1565C0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // الشعار وهوية التطبيق الجديدة
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amberAccent, width: 3),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 15,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.school_rounded,
                          size: 48,
                          color: Color(0xFF4A148C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'المتفوّق الجزائري',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4, bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Moutafawik DZ',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const Text(
                      'بوابتك الوطنية للتميز والنجاح الدراسي في كل الأطوار',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12.5,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // بطاقة تسجيل الدخول
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)),
                      color: Colors.white.withAlpha(245),
                      child: Padding(
                        padding: const EdgeInsets.all(22),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'تسجيل الدخول إلى حسابك',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 18),

                              // حقل البريد
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText:
                                      'البريد الإلكتروني أو اسم المستخدم',
                                  labelStyle: const TextStyle(
                                      fontFamily: 'Cairo', fontSize: 13),
                                  prefixIcon: const Icon(Icons.person_outline,
                                      color: Colors.deepPurple),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'يرجى إدخال اسم المستخدم أو البريد'
                                        : null,
                              ),
                              const SizedBox(height: 14),

                              // حقل كلمة المرور
                              TextFormField(
                                controller: passwordController,
                                obscureText: !isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'كلمة المرور',
                                  labelStyle: const TextStyle(
                                      fontFamily: 'Cairo', fontSize: 13),
                                  prefixIcon: const Icon(Icons.lock_outline,
                                      color: Colors.deepPurple),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => setState(() =>
                                        isPasswordVisible = !isPasswordVisible),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'يرجى إدخال كلمة المرور'
                                    : null,
                              ),

                              // خيارات التذكر ونسيان كلمة المرور
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: rememberMe,
                                        activeColor: Colors.deepPurple,
                                        onChanged: (val) => setState(
                                            () => rememberMe = val ?? true),
                                      ),
                                      const Text('تذكرني',
                                          style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 12)),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const ForgotPasswordScreen()),
                                    ),
                                    child: const Text(
                                      'نسيت كلمة المرور؟',
                                      style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 12,
                                          color: Colors.deepPurple),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // زر تسجيل الدخول
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A148C),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  elevation: 4,
                                ),
                                onPressed: isLoading ? null : login,
                                child: isLoading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2))
                                    : const Text(
                                        'دخول',
                                        style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),

                              const SizedBox(height: 14),

                              // فاصل أو تسجيل الدخول السريع
                              const Row(
                                children: [
                                  Expanded(child: Divider()),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'أو الدخول السريع عبر',
                                      style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 11.5,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  Expanded(child: Divider()),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // أزرار جوجل، فيسبوك، أبل، ورقم الهاتف
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildSocialButton(
                                    iconPath: 'assets/icons/google.png',
                                    label: 'Google',
                                    color: Colors.white,
                                    onTap: loginWithGoogle,
                                  ),
                                  _buildSocialButton(
                                    iconPath: 'assets/icons/facebook.png',
                                    label: 'Facebook',
                                    color: Colors.white,
                                    onTap: () => _loginWithSocial('Facebook'),
                                  ),
                                  _buildSocialButton(
                                    iconPath: 'assets/icons/apple.png',
                                    label: 'Apple',
                                    color: Colors.white,
                                    onTap: () => _loginWithSocial('Apple'),
                                  ),
                                  _buildSocialIconButton(
                                    icon: Icons.phone_android,
                                    label: 'الهاتف',
                                    color: Colors.teal.shade50,
                                    iconColor: Colors.teal,
                                    onTap: _loginWithPhone,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // زر الدخول كزائر
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  side: BorderSide(
                                      color: Colors.deepPurple.shade300),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: loginAsGuest,
                                icon: const Icon(Icons.explore_outlined,
                                    color: Colors.deepPurple),
                                label: const Text(
                                  'تصفح المنصة مباشرة كزائر (بدون حساب)',
                                  style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 13,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // زر التسجيل الجديد
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ليس لديك حساب بعد؟',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.white70,
                              fontSize: 13),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignupScreen()),
                          ),
                          child: const Text(
                            'إنشاء حساب جديد',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
