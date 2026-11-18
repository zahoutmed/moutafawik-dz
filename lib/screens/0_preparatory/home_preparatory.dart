import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/preparatory_data.dart';
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

class HomePreparatory extends StatefulWidget {
  const HomePreparatory({super.key});

  @override
  State<HomePreparatory> createState() => HomePreparatoryState();
}

class HomePreparatoryState extends State<HomePreparatory> {
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
              '🌱 مرحلة التعليم التحضيري (5 - 6 سنوات)',
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
                _buildSectionHeader('🎨 مجالات وأنشطة القسم التحضيري', screenWidth),
                GridView(
                  gridDelegate: _gridDelegate,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildCard(
                      context,
                      'اللغة العربية',
                      'assets/icons/arabic.png',
                      Colors.pink.shade700,
                      const SubjectHubScreen(
                        title: 'اللغة العربية',
                        stageName: 'التعليم التحضيري',
                        iconPath: 'assets/icons/arabic.png',
                        accentColor: Colors.pink,
                      ),
                    ),
                    _buildCard(
                      context,
                      'الرياضيات',
                      'assets/icons/math.png',
                      Colors.green.shade700,
                      const SubjectHubScreen(
                        title: 'الرياضيات',
                        stageName: 'التعليم التحضيري',
                        iconPath: 'assets/icons/math.png',
                        accentColor: Colors.green,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التربية الإسلامية',
                      'assets/icons/islamic.png',
                      Colors.teal.shade700,
                      const SubjectHubScreen(
                        title: 'التربية الإسلامية',
                        stageName: 'التعليم التحضيري',
                        iconPath: 'assets/icons/islamic.png',
                        accentColor: Colors.teal,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التربية العلمية',
                      'assets/icons/science.png',
                      Colors.blue.shade700,
                      const SubjectHubScreen(
                        title: 'التربية العلمية',
                        stageName: 'التعليم التحضيري',
                        iconPath: 'assets/icons/science.png',
                        accentColor: Colors.lightBlue,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التربية المدنية',
                      'assets/icons/civic.png',
                      Colors.orange.shade800,
                      const SubjectHubScreen(
                        title: 'التربية المدنية',
                        stageName: 'التعليم التحضيري',
                        iconPath: 'assets/icons/civic.png',
                        accentColor: Colors.orange,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التربية التشكيلية',
                      'assets/icons/art.png',
                      Colors.purple.shade700,
                      const SubjectHubScreen(
                        title: 'التربية الفنية',
                        stageName: 'التعليم التحضيري',
                        iconPath: 'assets/icons/art.png',
                        accentColor: Colors.purple,
                      ),
                    ),
                    _buildCard(
                      context,
                      'التربية الموسيقية',
                      'assets/icons/music.png',
                      Colors.indigo.shade700,
                      const SubjectHubScreen(
                        title: 'التربية الموسيقية',
                        stageName: 'التعليم التحضيري',
                        iconPath: 'assets/icons/music.png',
                        accentColor: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('⚡ اختصارات الأنشطة والألعاب التربوية', screenWidth),
                GridView(
                  gridDelegate: _gridDelegate,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildCard(
                      context,
                      'الأنشطة والدروس',
                      'assets/images/book_cover.png',
                      Colors.indigo.shade600,
                      LessonsScreen(program: PreparatoryData.programs.first),
                    ),
                    _buildCard(
                      context,
                      'ألعاب وتقييمات',
                      'assets/images/book_cover.png',
                      Colors.teal.shade600,
                      ActivitiesScreen(program: PreparatoryData.programs.first),
                    ),
                    _buildCard(
                      context,
                      'القصص والكتب',
                      'assets/images/book_cover.png',
                      Colors.deepOrange.shade600,
                      BooksScreen(program: PreparatoryData.programs.first),
                    ),
                    _buildCard(
                      context,
                      'الأناشيد والفيديو',
                      'assets/images/book_cover.png',
                      Colors.purple.shade600,
                      VideosScreen(program: PreparatoryData.programs.first),
                    ),
                    _buildCard(
                      context,
                      'رفيق المعلم والولي',
                      'assets/images/book_cover.png',
                      Colors.blueGrey.shade700,
                      const StudyCompanionScreen(initialTab: 0),
                    ),
                    _buildCard(
                      context,
                      'متابعة الطفل',
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
          currentProgram: PreparatoryData.programs.first,
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
