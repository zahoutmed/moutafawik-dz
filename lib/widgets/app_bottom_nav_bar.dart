import 'package:flutter/material.dart';
import 'package:i_love_philosophy/models/education_models.dart';
import 'package:i_love_philosophy/screens/home_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/lessons_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/activities_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/books_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/videos_screen.dart';

/// شريط التنقل السفلي الموحد بالأيقونات والتصنيفات الواضحة لجميع الشاشات
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final SubjectProgram? currentProgram;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    this.currentProgram,
  });

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = const HomeScreen();
        break;
      case 1:
        destination = LessonsScreen(program: currentProgram);
        break;
      case 2:
        destination = ActivitiesScreen(program: currentProgram);
        break;
      case 3:
        destination = BooksScreen(program: currentProgram);
        break;
      case 4:
        destination = VideosScreen(program: currentProgram);
        break;
      default:
        destination = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeIndex = currentIndex.clamp(0, 4);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        bottom: true,
        maintainBottomViewPadding: true,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(30),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: BottomNavigationBar(
              currentIndex: safeIndex,
              onTap: (i) => _onTap(context, i),
              type: BottomNavigationBarType.fixed,
              backgroundColor: isDark
                  ? const Color(0xFF1E1E2C)
                  : const Color(0xFFF3F6FF),
              selectedItemColor: Colors.deepPurple,
              unselectedItemColor: isDark ? Colors.white70 : Colors.black54,
              selectedFontSize: 12,
              unselectedFontSize: 11,
              iconSize: 24,
              selectedLabelStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_outlined),
                  activeIcon: Icon(Icons.menu_book_rounded),
                  label: 'الدروس',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.quiz_outlined),
                  activeIcon: Icon(Icons.quiz_rounded),
                  label: 'الاختبارات',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_library_outlined),
                  activeIcon: Icon(Icons.local_library_rounded),
                  label: 'المكتبة',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.ondemand_video_outlined),
                  activeIcon: Icon(Icons.ondemand_video_rounded),
                  label: 'الميلتيميديا',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
