import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/primary_data.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/activities_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/books_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/lessons_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/videos_screen.dart';
import 'package:i_love_philosophy/screens/home_screen.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/screens/outils/study_companion_screen.dart';
import 'package:i_love_philosophy/screens/shared/subject_hub_screen.dart';
import 'package:i_love_philosophy/utils/responsive_ui.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';

class HomePrimary extends StatefulWidget {
  const HomePrimary({super.key});

  @override
  State<HomePrimary> createState() => HomePrimaryState();
}

class HomePrimaryState extends State<HomePrimary> {
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
              '📖 مرحلة التعليم الابتدائي (تقييم المكتسبات)',
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
                _buildSectionHeader('🎓 السنوات الدراسية (التعليم الابتدائي)', screenWidth),
                GridView(
                  gridDelegate: _gridDelegate,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildCard(
                      context,
                      'السنة الأولى',
                      'assets/icons/y_1_300.png',
                      Colors.blue.shade700,
                      const SubjectHubScreen(
                        title: 'السنة الأولى ابتدائي',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/y_1_300.png',
                        accentColor: Colors.blue,
                      ),
                    ),
                    _buildCard(
                      context,
                      'السنة الثانية',
                      'assets/icons/y_2_300.png',
                      Colors.green.shade700,
                      const SubjectHubScreen(
                        title: 'السنة الثانية ابتدائي',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/y_2_300.png',
                        accentColor: Colors.green,
                      ),
                    ),
                    _buildCard(
                      context,
                      'السنة الثالثة',
                      'assets/icons/y_3_300.png',
                      Colors.deepOrange.shade700,
                      const SubjectHubScreen(
                        title: 'السنة الثالثة ابتدائي',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/y_3_300.png',
                        accentColor: Colors.deepOrange,
                      ),
                    ),
                    _buildCard(
                      context,
                      'السنة الرابعة',
                      'assets/icons/y_4_300.png',
                      Colors.purple.shade700,
                      const SubjectHubScreen(
                        title: 'السنة الرابعة ابتدائي',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/y_4_300.png',
                        accentColor: Colors.purple,
                      ),
                    ),
                    _buildCard(
                      context,
                      'السنة الخامسة',
                      'assets/icons/y_5_300.png',
                      Colors.teal.shade700,
                      const SubjectHubScreen(
                        title: 'السنة الخامسة ابتدائي',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/y_5_300.png',
                        accentColor: Colors.teal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('📚 كل المواد المقررة (المنهاج الرسمي)', screenWidth),
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
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/math.png',
                        accentColor: Colors.indigo,
                      ),
                    ),
                    _buildCard(
                      context,
                      'اللغة العربية',
                      'assets/icons/arabic.png',
                      Colors.redAccent.shade700,
                      const SubjectHubScreen(
                        title: 'اللغة العربية',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/arabic.png',
                        accentColor: Colors.redAccent,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التربية العلمية',
                      'assets/icons/science.png',
                      Colors.teal.shade700,
                      const SubjectHubScreen(
                        title: 'التربية العلمية',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/science.png',
                        accentColor: Colors.teal,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التربية الإسلامية',
                      'assets/icons/islamic.png',
                      Colors.green.shade700,
                      const SubjectHubScreen(
                        title: 'التربية الإسلامية',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/islamic.png',
                        accentColor: Colors.green,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التربية المدنية',
                      'assets/icons/civic.png',
                      Colors.orange.shade800,
                      const SubjectHubScreen(
                        title: 'التربية المدنية',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/civic.png',
                        accentColor: Colors.orange,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التاريخ والجغرافيا',
                      'assets/icons/his_geo.png',
                      Colors.brown.shade700,
                      const SubjectHubScreen(
                        title: 'التاريخ والجغرافيا',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/his_geo.png',
                        accentColor: Colors.brown,
                      ),
                    ),
                    _buildCard(
                      context,
                      'اللغة الفرنسية',
                      'assets/icons/french.png',
                      Colors.blue.shade800,
                      const SubjectHubScreen(
                        title: 'اللغة الفرنسية',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/french.png',
                        accentColor: Colors.blueAccent,
                      ),
                    ),
                    _buildCard(
                      context,
                      'اللغة الإنجليزية',
                      'assets/icons/english.png',
                      Colors.deepPurple.shade700,
                      const SubjectHubScreen(
                        title: 'اللغة الإنجليزية',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/english.png',
                        accentColor: Colors.purple,
                      ),
                    ),
                    _buildCard(
                      context,
                      'اللغة الأمازيغية',
                      'assets/icons/tamazight.png',
                      Colors.amber.shade800,
                      const SubjectHubScreen(
                        title: 'اللغة الأمازيغية',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/tamazight.png',
                        accentColor: Colors.amber,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التربية الفنية',
                      'assets/icons/art.png',
                      Colors.pink.shade700,
                      const SubjectHubScreen(
                        title: 'التربية الفنية',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/art.png',
                        accentColor: Colors.pink,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التربية الموسيقية',
                      'assets/icons/music.png',
                      Colors.cyan.shade800,
                      const SubjectHubScreen(
                        title: 'التربية الموسيقية',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/music.png',
                        accentColor: Colors.cyan,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التربية البدنية',
                      'assets/icons/sport.png',
                      Colors.lightGreen.shade800,
                      const SubjectHubScreen(
                        title: 'التربية البدنية',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/sport.png',
                        accentColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('⚡ اختصارات وأدوات التفوق', screenWidth),
                GridView(
                  gridDelegate: _gridDelegate,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildCard(
                      context,
                      'الدروس',
                      'assets/images/book_cover.png',
                      Colors.indigo.shade600,
                      LessonsScreen(program: PrimaryData.programs.first),
                    ),
                    _buildCard(
                      context,
                      'الاختبارات',
                      'assets/images/book_cover.png',
                      Colors.teal.shade600,
                      ActivitiesScreen(program: PrimaryData.programs.first),
                    ),
                    _buildCard(
                      context,
                      'المكتبة والكتب',
                      'assets/images/book_cover.png',
                      Colors.deepOrange.shade600,
                      BooksScreen(program: PrimaryData.programs.first),
                    ),
                    _buildCard(
                      context,
                      'الفيديوهات',
                      'assets/images/book_cover.png',
                      Colors.purple.shade600,
                      VideosScreen(program: PrimaryData.programs.first),
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
          currentProgram: PrimaryData.programs.first,
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
