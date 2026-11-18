import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/curriculum_repository.dart';
import 'package:i_love_philosophy/models/education_models.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/screens/outils/study_companion_screen.dart';
import 'package:i_love_philosophy/screens/outils/study_progress_service.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/lessons_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/lessons_detail_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/activities_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/books_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/videos_screen.dart';
import 'package:i_love_philosophy/utils/curriculum_filter_helper.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';
import 'package:i_love_philosophy/utils/responsive_ui.dart';

class SubjectHubScreen extends StatefulWidget {
  final String title;
  final String stageName;
  final String iconPath;
  final Color accentColor;
  final List<String> units;
  final SubjectProgram? program;

  const SubjectHubScreen({
    super.key,
    required this.title,
    required this.stageName,
    required this.iconPath,
    this.accentColor = Colors.deepPurple,
    this.units = const [],
    this.program,
  });

  @override
  State<SubjectHubScreen> createState() => _SubjectHubScreenState();
}

class _SubjectHubScreenState extends State<SubjectHubScreen> {
  final StudyProgressService _progressService = StudyProgressService();
  late final SubjectProgram _program;
  String _selectedLevel = 'الكل';

  @override
  void initState() {
    super.initState();
    _program = widget.program ??
        CurriculumRepository.resolveProgram(
          title: widget.title,
          stageName: widget.stageName,
          iconPath: widget.iconPath,
          accentColor: widget.accentColor,
        );
    final levels = CurriculumFilterHelper.extractAvailableLevels(_program.lessons);
    if (levels.length > 1) {
      final hint = '${widget.stageName} ${_program.levelOrStream}';
      final matched = levels.where((l) => hint.contains(l) ||
          (l == '1 ثانوي' && hint.contains('الأولى ثانوي')) ||
          (l == '2 ثانوي' && hint.contains('الثانية ثانوي')) ||
          (l == '3 ثانوي' && (hint.contains('الثالثة ثانوي') || hint.contains('BAC'))) ||
          (l == '1 متوسط' && hint.contains('الأولى متوسط')) ||
          (l == '2 متوسط' && hint.contains('الثانية متوسط')) ||
          (l == '3 متوسط' && hint.contains('الثالثة متوسط')) ||
          (l == '4 متوسط' && (hint.contains('الرابعة متوسط') || hint.contains('BEM'))) ||
          (l == '1 ابتدائي' && hint.contains('الأولى ابتدائي')) ||
          (l == '2 ابتدائي' && hint.contains('الثانية ابتدائي')) ||
          (l == '3 ابتدائي' && hint.contains('الثالثة ابتدائي')) ||
          (l == '4 ابتدائي' && hint.contains('الرابعة ابتدائي')) ||
          (l == '5 ابتدائي' && hint.contains('الخامسة ابتدائي'))).firstOrNull;
      _selectedLevel = matched ?? levels.first;
    }
    _progressService.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _progressService.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUI.fontBasis(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(
            '${_program.title} - ${_program.levelOrStream}',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: screenWidth * 0.042,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.psychology, color: Colors.deepPurple),
              tooltip: 'رفيق التفوق والمنهجية',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudyCompanionScreen(),
                  ),
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
            maxWidth: 1100,
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
              // بطاقة تعريفية بالمادة أو الشعبة
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: Colors.white.withAlpha(240),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: _program.color.withAlpha(35),
                        child: Image.asset(
                          _program.iconPath,
                          height: 44,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.menu_book,
                            size: 36,
                            color: _program.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _program.title,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: screenWidth * 0.050,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${_program.stage} | ${_program.levelOrStream}',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: screenWidth * 0.033,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _program.description,
                              style: const TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // أزرار الوصول السريع للأقسام الأربعة بارتفاع معياري ثابت ومتجاوب
              GridView(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 270,
                  mainAxisExtent: 50,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildQuickAction(
                    'الدروس والملخصات (${_program.lessons.length})',
                    Icons.menu_book_rounded,
                    Colors.indigo,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonsScreen(program: _program),
                      ),
                    ),
                  ),
                  _buildQuickAction(
                    'الاختبارات (${_program.quizzes.length})',
                    Icons.quiz_rounded,
                    Colors.teal,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ActivitiesScreen(program: _program),
                      ),
                    ),
                  ),
                  _buildQuickAction(
                    'المكتبة والمراجع (${_program.libraryItems.length})',
                    Icons.local_library_rounded,
                    Colors.deepOrange,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BooksScreen(program: _program),
                      ),
                    ),
                  ),
                  _buildQuickAction(
                    'الميلتيميديا والشروحات (${_program.mediaItems.length})',
                    Icons.ondemand_video_rounded,
                    Colors.purple,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideosScreen(program: _program),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Builder(builder: (context) {
                final availableLevels = CurriculumFilterHelper.extractAvailableLevels(_program.lessons);
                final levelChoices = availableLevels.length > 1 ? ['الكل', ...availableLevels] : availableLevels;
                if (!levelChoices.contains(_selectedLevel) && levelChoices.isNotEmpty) {
                  _selectedLevel = levelChoices.first;
                }
                final filteredLessons = CurriculumFilterHelper.filterByLevel(_program.lessons, _selectedLevel);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📚 وحدات ودروس المنهاج الرسمي (${filteredLessons.length}):',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: screenWidth * 0.044,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (levelChoices.length > 1) ...[
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: levelChoices.map((lvl) {
                            final isSel = _selectedLevel == lvl;
                            return Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: ChoiceChip(
                                label: Text(
                                  lvl,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11.5,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                                    color: isSel ? Colors.white : const Color(0xFF3F1D77),
                                  ),
                                ),
                                selected: isSel,
                                selectedColor: const Color(0xFF3F1D77),
                                backgroundColor: Colors.white.withAlpha(230),
                                onSelected: (_) => setState(() => _selectedLevel = lvl),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    ...filteredLessons.map((lesson) {
                      final key = '${_program.id}: ${lesson.title}';
                      final isDone = _progressService.isLessonCompleted(key) ||
                          _progressService.isLessonCompleted(lesson.title);
                      final isFav = _progressService.isBookmarked(key) ||
                          _progressService.isBookmarked(lesson.title);
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isDone ? Colors.green : _program.color,
                            child: Icon(
                              isDone ? Icons.check : Icons.article_outlined,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            lesson.title,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                          ),
                          subtitle: Text(
                            isDone
                                ? 'تمت المراجعة ✅ • ${lesson.section}'
                                : '${lesson.section} • ${lesson.duration}',
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 14,
                              color: isDone ? Colors.green.shade700 : Colors.black54,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  isFav ? Icons.bookmark : Icons.bookmark_border,
                                  color: isFav ? Colors.deepOrange : Colors.grey,
                                ),
                                onPressed: () => _progressService.toggleBookmark(lesson.title),
                              ),
                              IconButton(
                                icon: Icon(
                                  isDone ? Icons.check_circle : Icons.check_circle_outline,
                                  color: isDone ? Colors.green : Colors.grey,
                                ),
                                onPressed: () => _progressService.toggleLessonCompleted(lesson.title),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LessonsDetailScreen(lessonData: lesson),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
          currentIndex: 1,
          currentProgram: _program,
        ),
      ),
    );
  }

  Widget _buildQuickAction(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 19),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
