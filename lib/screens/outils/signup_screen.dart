import 'package:flutter/material.dart';
import 'package:i_love_philosophy/screens/home_screen.dart';
import 'package:i_love_philosophy/screens/user_preferences_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isPasswordVisible = false;
  String selectedStage = 'التعليم الثانوي';
  String selectedGrade = 'السنة الثالثة ثانوي (BAC)';

  final List<String> stages = const [
    'التعليم التحضيري',
    'التعليم الابتدائي',
    'التعليم المتوسط',
    'التعليم الثانوي',
  ];

  final Map<String, List<String>> gradesMap = const {
    'التعليم التحضيري': ['قسم التحضيري (5-6 سنوات)'],
    'التعليم الابتدائي': [
      'السنة الأولى ابتدائي',
      'السنة الثانية ابتدائي',
      'السنة الثالثة ابتدائي',
      'السنة الرابعة ابتدائي',
      'السنة الخامسة ابتدائي (تقييم المكتسبات)',
    ],
    'التعليم المتوسط': [
      'السنة الأولى متوسط',
      'السنة الثانية متوسط',
      'السنة الثالثة متوسط',
      'السنة الرابعة متوسط (BEM)',
    ],
    'التعليم الثانوي': [
      'السنة الأولى ثانوي (جذع مشترك)',
      'السنة الثانية ثانوي',
      'السنة الثالثة ثانوي (BAC)',
    ],
  };

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signup() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', nameController.text.trim());
      await prefs.setString('user_email', emailController.text.trim());
      await prefs.setString('user_stage', selectedStage);
      await prefs.setString('user_grade', selectedGrade);

      await UserPreferencesScreen.saveUser(
        User(
          username: emailController.text.trim(),
          password: passwordController.text,
        ),
      );

      if (!mounted) return;
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              '🎉 تم إنشاء حسابك بنجاح! أهلاً بك في المتفوّق الجزائري.',
              style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } catch (_) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر إتمام التسجيل حالياً، يرجى المحاولة مرة أخرى.',
                style: TextStyle(fontFamily: 'Cairo')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
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
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                child: Column(
                  children: [
                    // العنوان
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'إنشاء حساب طالب جديد',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)),
                      color: Colors.white.withAlpha(245),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // الاسم الكامل
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: 'الاسم الكامل أو اللقب',
                                  labelStyle: const TextStyle(
                                      fontFamily: 'Cairo', fontSize: 13),
                                  prefixIcon: const Icon(Icons.person,
                                      color: Colors.deepPurple),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'يرجى كتابة الاسم'
                                        : null,
                              ),
                              const SizedBox(height: 12),

                              // البريد
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'البريد الإلكتروني',
                                  labelStyle: const TextStyle(
                                      fontFamily: 'Cairo', fontSize: 13),
                                  prefixIcon: const Icon(Icons.email_outlined,
                                      color: Colors.deepPurple),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                validator: (v) =>
                                    (v == null || !v.contains('@'))
                                        ? 'يرجى إدخال بريد صالح'
                                        : null,
                              ),
                              const SizedBox(height: 12),

                              // اختيار الطور التعليمي
                              DropdownButtonFormField<String>(
                                initialValue: selectedStage,
                                decoration: InputDecoration(
                                  labelText: 'الطور التعليمي',
                                  labelStyle: const TextStyle(
                                      fontFamily: 'Cairo', fontSize: 13),
                                  prefixIcon: const Icon(Icons.school,
                                      color: Colors.deepPurple),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                items: stages
                                    .map((s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(s,
                                            style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 13))))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      selectedStage = val;
                                      selectedGrade = gradesMap[val]!.first;
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 12),

                              // اختيار السنة الدراسية
                              DropdownButtonFormField<String>(
                                initialValue: selectedGrade,
                                decoration: InputDecoration(
                                  labelText: 'السنة أو الشعبة',
                                  labelStyle: const TextStyle(
                                      fontFamily: 'Cairo', fontSize: 13),
                                  prefixIcon: const Icon(Icons.grade,
                                      color: Colors.deepPurple),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                items: (gradesMap[selectedStage] ?? [])
                                    .map((g) => DropdownMenuItem(
                                        value: g,
                                        child: Text(g,
                                            style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 12.5))))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => selectedGrade = val);
                                  }
                                },
                              ),
                              const SizedBox(height: 12),

                              // كلمة المرور
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
                                        color: Colors.grey),
                                    onPressed: () => setState(() =>
                                        isPasswordVisible = !isPasswordVisible),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                validator: (v) => (v == null || v.length < 6)
                                    ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
                                    : null,
                              ),
                              const SizedBox(height: 12),

                              // تأكيد كلمة المرور
                              TextFormField(
                                controller: confirmPasswordController,
                                obscureText: !isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'تأكيد كلمة المرور',
                                  labelStyle: const TextStyle(
                                      fontFamily: 'Cairo', fontSize: 13),
                                  prefixIcon: const Icon(Icons.lock_reset,
                                      color: Colors.deepPurple),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                                validator: (v) {
                                  if (v != passwordController.text) {
                                    return 'كلمات المرور غير متطابقة';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // زر التسجيل
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
                                onPressed: isLoading ? null : signup,
                                child: isLoading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2))
                                    : const Text(
                                        'إنشاء الحساب وبدء التعلم',
                                        style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),

                              const SizedBox(height: 14),
                              const Row(
                                children: [
                                  Expanded(child: Divider()),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'أو التسجيل السريع عبر',
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

                              // أزرار جوجل، فيسبوك، أبل
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildSocialQuickBtn(
                                      'assets/icons/google.png', 'Google'),
                                  _buildSocialQuickBtn(
                                      'assets/icons/facebook.png', 'Facebook'),
                                  _buildSocialQuickBtn(
                                      'assets/icons/apple.png', 'Apple'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'لديك حساب بالفعل؟ تسجيل الدخول',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
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

  Widget _buildSocialQuickBtn(String iconPath, String label) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('جاري ربط الحساب عبر $label...',
                style: const TextStyle(fontFamily: 'Cairo')),
            backgroundColor: Colors.deepPurple,
          ),
        );
        Future.delayed(const Duration(milliseconds: 700), () {
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
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
}
