import 'package:flutter/material.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/screens/home_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/lessons_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/activities_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/books_screen.dart';
import 'package:i_love_philosophy/screens/user_preferences_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/videos_screen.dart';
import 'package:i_love_philosophy/screens/outils/settings_screen.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';
import 'package:i_love_philosophy/utils/responsive_ui.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});
  @override
  AboutUsScreenState createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  int selectedIndex = 0;
  // تعريف اللون الافتراضي
  final Color _selectedColor = Colors.white;
  final List<Widget> screens = [
    HomeScreen(),
    LessonsScreen(),
    ActivitiesScreen(),
    BooksScreen(),
    VideosScreen(),
    SettingsScreen(),
    UserPreferencesScreen(),
  ];
  // Navigation logic for CurvedNavigationBar
  void onItemTapped(int index) {
    if (selectedIndex == index) return; // Prevent rebuilding the same screen
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LessonsScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ActivitiesScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BooksScreen()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VideosScreen()),
        );
        break;
      case 5:
        // راك هنا
        break;
      case 6:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen()),
        );
        break;
      case 7:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserPreferencesScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUI.fontBasis(context);
    final screenHeight = ResponsiveUI.heightBasis(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '✨ صفحة ✨ من نحن؟',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: screenWidth * 0.050, // حجم النص الأول
                fontWeight: FontWeight.bold,
                color: Colors.black,
                shadows: const [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black45,
                    offset: Offset(5.0, 5.0),
                  ),
                ],
              ),
            ),
            Text(
              '  [أ❤️ الفلسفة]',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: screenWidth * 0.020, // حجم النص الثاني
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange, // لون النص الثاني
              ),
            ),
          ],
        ),
        backgroundColor: _selectedColor,
        actions: [
          IconButton(
            color: Colors.black,
            icon: const Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      "مرحبا بك",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // لون النص داخل التنبيه
                      ),
                    ),
                    content: Text(
                      "أنت في ✨ صفحة ✨ من نحن؟' يمكنك التنقل انطلاقًا من هنا",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.black,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    actions: [
                      Center(
                        // إضافة Center لتمركز الزر
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // إغلاق التنبيه
                          },
                          child: Text(
                            "نعم",
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w900,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_background2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(), // لتحسين تجربة التمرير

            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Colors.white70,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'من نحن؟',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          ' رواد في عالم تصميم وتطوير مواقع الويب وخدمات الكمبيوتر. نسعى دائمًا إلى تحقيق التميز والابتكار في كل مشروع نقوم به. نحن لا نقدم مجرد خدمات برمجية، بل نقدم حلولاً تقنية متقدمة تساعدك في تحقيق أهدافك التجارية بفعالية وجدارة. نقدم خدمات متنوعة وعروض مناسبة لجميع في Code Expert، نؤمن بأن التصميم والتكنولوجيا يمكن أن يكونا عاملين محوريين لنجاح أعمالك. نحن نعمل جنبًا إلى جنب معك لفهم احتياج اتك وتحويلها إلى مشروعات برمجية مبدعة وتجارية ناجحة. نحن نستخدم أحدث التقنيات ونجمع بين الإبداع والأمان لضمان تقديم منتجات فريدة وموثوقة. عندما تعمل معنا، ستجد نفسك في رحلة تطوير ملهمة، حيث سنساعدك في تحقيق أحلامك وتحويلها إلى واقع. دعنا نكون شركاءك في النجاح، ولنساعدك في بناء مستقبل رقمي مشرق لعملك. الأستاذ زحوط محمد المشرف على تطبيق ومنصة (المتفوّق الجزائري - Moutafawik DZ) لنشر العلوم والمعرفة ومرافقة التلاميذ والأساتذة وأولياء الأمور في كافة الأطوار التعليمية.',
                          softWrap: true,
                          style: TextStyle(
                            fontFamily: 'Lateef',
                            fontSize: screenWidth * 0.050,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Card(
                  color: Colors.white70,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'رسالتنا',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: screenWidth * 0.06,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w900,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          'نهدف إلى تعزيز التفكير النقدي والتحليل العميق ونشر الفلسفة',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: screenWidth * 0.04,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Card(
                  color: Colors.white70,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'اتصل بنا',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: screenWidth * 0.06,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w900,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.email,
                                color: Colors.blueAccent.shade400),
                            SizedBox(width: screenHeight * 0.005),
                            Text(
                              'contact@philosophy.com',
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: screenWidth * 0.04,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.phone,
                                color: Colors.blueAccent.shade400),
                            SizedBox(width: screenHeight * 0.005),
                            Text(
                              '+213 790 020302',
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: screenWidth * 0.04,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),

/*----------------------------------------------------------------------------*/
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
/*----------------------------------------------------------------------------*/
    );
  }
}
