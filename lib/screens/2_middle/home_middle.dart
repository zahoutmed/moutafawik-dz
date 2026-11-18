import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/middle_data.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/activities_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/books_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/lessons_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/videos_screen.dart';
import 'package:i_love_philosophy/screens/educational_enhancements_screen.dart';
import 'package:i_love_philosophy/screens/home_screen.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/screens/outils/study_companion_screen.dart';
import 'package:i_love_philosophy/screens/shared/official_exams_screen.dart';
import 'package:i_love_philosophy/screens/shared/subject_hub_screen.dart';
import 'package:i_love_philosophy/utils/responsive_ui.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';

class HomeMiddle extends StatefulWidget {
  const HomeMiddle({super.key});

  @override
  State<HomeMiddle> createState() => HomeMiddleState();
}

class HomeMiddleState extends State<HomeMiddle> {
  static const _gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 155,
    mainAxisExtent: 118,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUI.fontBasis(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF3F1D77),
          foregroundColor: Colors.white,
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '🎓 مرحلة التعليم المتوسط (1 إلى 4 متوسط - BEM)',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.home_outlined, color: Colors.amberAccent),
              tooltip: 'الرئيسية',
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
            ),
          ],
        ),
        drawer: const CustomDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_background2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: ResponsiveUI.constrainBody(
            maxWidth: 1120,
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _buildSectionHeader('🎓 السنوات الدراسية (التعليم المتوسط)', screenWidth),
                GridView(
                  gridDelegate: _gridDelegate,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildCard(
                      context,
                      'السنة 1 متوسط',
                      'assets/icons/y_1_300.png',
                      Colors.blue.shade700,
                      const SubjectHubScreen(
                        title: 'السنة الأولى متوسط',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/y_1_300.png',
                        accentColor: Colors.blue,
                      ),
                    ),
                    _buildCard(
                      context,
                      'السنة 2 متوسط',
                      'assets/icons/y_2_300.png',
                      Colors.green.shade700,
                      const SubjectHubScreen(
                        title: 'السنة الثانية متوسط',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/y_2_300.png',
                        accentColor: Colors.green,
                      ),
                    ),
                    _buildCard(
                      context,
                      'السنة 3 متوسط',
                      'assets/icons/y_3_300.png',
                      Colors.deepOrange.shade700,
                      const SubjectHubScreen(
                        title: 'السنة الثالثة متوسط',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/y_3_300.png',
                        accentColor: Colors.deepOrange,
                      ),
                    ),
                    _buildCard(
                      context,
                      'السنة 4 متوسط (BEM)',
                      'assets/icons/y_4_300.png',
                      Colors.purple.shade700,
                      const SubjectHubScreen(
                        title: 'السنة الرابعة متوسط (BEM)',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/y_4_300.png',
                        accentColor: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('📚 كل المواد المقررة (التعليم المتوسط)', screenWidth),
                GridView(
                  gridDelegate: _gridDelegate,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildCard(
                      context,
                      'الرياضيات',
                      'assets/icons/math.png',
                      Colors.indigo.shade700,
                      const SubjectHubScreen(
                        title: 'الرياضيات',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/math.png',
                        accentColor: Colors.indigo,
                      ),
                    ),
                    _buildCard(
                      context,
                      'اللغة العربية',
                      'assets/icons/arabic.png',
                      Colors.teal.shade700,
                      const SubjectHubScreen(
                        title: 'اللغة العربية',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/arabic.png',
                        accentColor: Colors.teal,
                      ),
                    ),
                    _buildCard(
                      context,
                      'العلوم الفيزيائية',
                      'assets/icons/physics.png',
                      Colors.amber.shade800,
                      const SubjectHubScreen(
                        title: 'العلوم الفيزيائية والتكنولوجيا',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/physics.png',
                        accentColor: Colors.amber,
                      ),
                    ),
                    _buildCard(
                      context,
                      'علوم الطبيعة والحياة',
                      'assets/icons/science.png',
                      Colors.green.shade700,
                      const SubjectHubScreen(
                        title: 'علوم الطبيعة والحياة',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/science.png',
                        accentColor: Colors.green,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التاريخ والجغرافيا',
                      'assets/icons/his_geo.png',
                      Colors.brown.shade700,
                      const SubjectHubScreen(
                        title: 'التاريخ والجغرافيا',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/his_geo.png',
                        accentColor: Colors.brown,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التربية الإسلامية',
                      'assets/icons/islamic.png',
                      Colors.teal.shade800,
                      const SubjectHubScreen(
                        title: 'التربية الإسلامية',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/islamic.png',
                        accentColor: Colors.teal,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التربية المدنية',
                      'assets/icons/civic.png',
                      Colors.orange.shade800,
                      const SubjectHubScreen(
                        title: 'التربية المدنية',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/civic.png',
                        accentColor: Colors.orange,
                      ),
                    ),
                    _buildCard(
                      context,
                      'اللغة الفرنسية',
                      'assets/icons/french.png',
                      Colors.blue.shade800,
                      const SubjectHubScreen(
                        title: 'اللغة الفرنسية',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/french.png',
                        accentColor: Colors.blue,
                      ),
                    ),
                    _buildCard(
                      context,
                      'اللغة الإنجليزية',
                      'assets/icons/english.png',
                      Colors.deepPurple.shade700,
                      const SubjectHubScreen(
                        title: 'اللغة الإنجليزية',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/english.png',
                        accentColor: Colors.deepPurple,
                      ),
                    ),
                    _buildCard(
                      context,
                      'الإعلام الآلي',
                      'assets/icons/informatique.png',
                      Colors.blueGrey.shade700,
                      const SubjectHubScreen(
                        title: 'الإعلام الآلي',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/informatique.png',
                        accentColor: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('⚡ اختصارات وحوليات BEM', screenWidth),
                GridView(
                  gridDelegate: _gridDelegate,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildCard(
                      context,
                      'الدروس والملخصات',
                      'assets/images/book_cover.png',
                      Colors.indigo.shade600,
                      LessonsScreen(program: MiddleData.programs.first),
                    ),
                    _buildCard(
                      context,
                      'الاختبارات التفاعلية',
                      'assets/images/book_cover.png',
                      Colors.teal.shade600,
                      ActivitiesScreen(program: MiddleData.programs.first),
                    ),
                    _buildCard(
                      context,
                      'مواضيع وحلول BEM',
                      'assets/images/book_cover.png',
                      Colors.deepPurple.shade700,
                      const OfficialExamsScreen(),
                    ),
                    _buildCard(
                      context,
                      'المكتبة والمراجع',
                      'assets/images/book_cover.png',
                      Colors.deepOrange.shade600,
                      BooksScreen(program: MiddleData.programs.first),
                    ),
                    _buildCard(
                      context,
                      'الشروحات المرئية',
                      'assets/images/book_cover.png',
                      Colors.pink.shade700,
                      VideosScreen(program: MiddleData.programs.first),
                    ),
                    _buildCard(
                      context,
                      'البطاقات والعد التنازلي',
                      'assets/images/book_cover.png',
                      Colors.cyan.shade800,
                      const EducationalEnhancementsScreen(),
                    ),
                    _buildCard(
                      context,
                      'رفيق التفوق',
                      'assets/images/book_cover.png',
                      Colors.blueGrey.shade700,
                      const StudyCompanionScreen(initialTab: 0),
                    ),
                    _buildCard(
                      context,
                      'متابعة التقدم',
                      'assets/images/book_cover.png',
                      Colors.green.shade700,
                      const StudyCompanionScreen(initialTab: 2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 0,
          currentProgram: MiddleData.programs.first,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: screenWidth * 0.044,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2B1055),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    String imagePath,
    Color color,
    Widget screen,
  ) {
    return Card(
      color: color,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.menu_book, color: Colors.white, size: 32),
                ),
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
