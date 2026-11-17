import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:i_love_philosophy/screens/home_screen.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool isEmailVerified = false;
  bool isVerificationEmailSent = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = user?.emailVerified ?? false;

    if (!isEmailVerified && user != null) {
      sendEmailVerification();
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      if (user != null && !isEmailVerified) {
        await user?.sendEmailVerification();
        if (mounted) {
          setState(() {
            isVerificationEmailSent = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر إرسال رابط التفعيل حالياً.')),
        );
      }
    }
  }

  Future<void> checkEmailVerified() async {
    try {
      await user?.reload();
      final verified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
      if (!mounted) return;
      setState(() {
        isEmailVerified = verified;
      });

      if (isEmailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لم يتم تفعيل البريد الإلكتروني بعد.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء التحقق من التفعيل.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_background2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'تفعيل الحساب',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: screenWidth * 0.07,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(),
                Text(
                  isVerificationEmailSent
                      ? 'تم إرسال رابط التفعيل إلى بريدك الإلكتروني. يرجى التحقق من البريد الإلكتروني لتفعيل حسابك.'
                      : 'يرجى الانتظار بينما نقوم بإرسال رابط التفعيل إلى بريدك الإلكتروني.',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: screenWidth * 0.07,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(),
                if (isVerificationEmailSent)
                  ElevatedButton(
                    onPressed: checkEmailVerified,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 10,
                      shadowColor: Colors.black45,
                    ),
                    child: Text(
                      'تحقق من التفعيل',
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: screenWidth * 0.07,
                        color: Colors.white,
                      ),
                    ),
                  ),
                SizedBox(),
                if (!isEmailVerified)
                  TextButton(
                    onPressed: sendEmailVerification,
                    child: Text(
                      'إعادة إرسال رابط التفعيل',
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: screenWidth * 0.07,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
