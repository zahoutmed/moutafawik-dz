import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/secondary_data.dart';
import 'package:i_love_philosophy/models/education_models.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/screens/outils/study_companion_screen.dart';
import 'package:i_love_philosophy/screens/outils/study_progress_service.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/lessons_detail_screen.dart';
import 'package:i_love_philosophy/utils/curriculum_filter_helper.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';
import 'package:i_love_philosophy/widgets/program_filter_bar.dart';
import 'package:i_love_philosophy/utils/responsive_ui.dart';

class LessonsScreen extends StatefulWidget {
  final SubjectProgram? program;

  const LessonsScreen({super.key, this.program});

  @override
  State<LessonsScreen> createState() => LessonsScreenState();
}

class LessonsScreenState extends State<LessonsScreen> {
  final StudyProgressService _progressService = StudyProgressService();
  final TextEditingController _searchController = TextEditingController();
  late SubjectProgram _activeProgram;
  String _selectedLevel = 'الكل';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _activeProgram = widget.program ?? SecondaryData.programs.first;
    final levels = CurriculumFilterHelper.extractAvailableLevels(_activeProgram.lessons);
    if (levels.length > 1) {
      final hint = _activeProgram.levelOrStream;
      final matched = levels.where((l) => hint.contains(l) ||
          (l == '1 ثانوي' && hint.contains('الأولى ثانوي')) ||
          (l == '2 ثانوي' && hint.contains('الثانية ثانوي')) ||
          (l == '3 ثانوي' && (hint.contains('الثالثة ثانوي') || hint.contains('BAC'))) ||
          (l == '4 متوسط' && (hint.contains('الرابعة متوسط') || hint.contains('BEM')))).firstOrNull;
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUI.fontBasis(context);
    final availableLevels = CurriculumFilterHelper.extractAvailableLevels(_activeProgram.lessons);
    final levelChoices = availableLevels.length > 1 ? ['الكل', ...availableLevels] : availableLevels;
    if (!levelChoices.contains(_selectedLevel) && levelChoices.isNotEmpty) {
      _selectedLevel = levelChoices.first;
    }

    final levelFiltered = CurriculumFilterHelper.filterByLevel(_activeProgram.lessons, _selectedLevel);
    final filteredLessons = levelFiltered.where((lesson) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.trim().toLowerCase();
      return lesson.title.toLowerCase().contains(q) ||
          lesson.section.toLowerCase().contains(q) ||
          lesson.summary.toLowerCase().contains(q);
    }).toList();

    // تجميع الدروس حسب الميدان/المحور
    final Map<String, List<LessonData>> grouped = {};
    for (final lesson in filteredLessons) {
      grouped.putIfAbsent(lesson.section, () => []).add(lesson);
    }

    final completedCount = levelFiltered.where((l) => _progressService.isLessonCompleted(l.title)).length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF3F1D77),
          foregroundColor: Colors.white,
          title: Text(
            '📖 دروس: ${_activeProgram.title}',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: screenWidth * 0.042,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.psychology, color: Colors.amberAccent),
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
          child: Column(
            children: [
              ProgramFilterBar(
                selectedProgram: _activeProgram,
                onProgramChanged: (prog) {
                  setState(() {
                    _activeProgram = prog;
                    final nextLevels = CurriculumFilterHelper.extractAvailableLevels(prog.lessons);
                    _selectedLevel = nextLevels.length > 1 ? nextLevels.first : 'الكل';
                  });
                },
              ),
              // شريط تصفية السنوات الدراسية والشعب
              if (levelChoices.length > 1)
                Container(
                  width: double.infinity,
                  color: Colors.white.withAlpha(245),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(Icons.school, size: 18, color: Color(0xFF3F1D77)),
                        ),
                        ...levelChoices.map((lvl) {
                          final isSel = _selectedLevel == lvl;
                          return Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: ChoiceChip(
                              label: Text(
                                lvl,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.w600,
                                  color: isSel ? Colors.white : const Color(0xFF3F1D77),
                                ),
                              ),
                              selected: isSel,
                              selectedColor: const Color(0xFF3F1D77),
                              backgroundColor: Colors.deepPurple.shade50,
                              onSelected: (_) => setState(() => _selectedLevel = lvl),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              // شريط البحث + ملخص التقدم
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: InputDecoration(
                          hintText: 'ابحث في دروس $_selectedLevel...',
                          hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white.withAlpha(242),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(242),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '$completedCount / ${levelFiltered.length}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: grouped.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد دروس مطابقة للبحث في هذا المستوى.',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        children: grouped.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 10, bottom: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3F1D77).withAlpha(230),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${entry.key} (${entry.value.length})',
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              ...entry.value.map((lesson) {
                                final isDone = _progressService.isLessonCompleted(lesson.title);
                                final isFav = _progressService.isBookmarked(lesson.title);
                                final levelBadge = CurriculumFilterHelper.extractLevel(lesson);
                                return Card(
                                  elevation: 3,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(14),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => LessonsDetailScreen(lessonData: lesson),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: isDone ? Colors.green.withAlpha(30) : _activeProgram.color.withAlpha(30),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              isDone ? Icons.check_circle : Icons.menu_book_rounded,
                                              color: isDone ? Colors.green : _activeProgram.color,
                                              size: 26,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  lesson.title,
                                                  style: const TextStyle(
                                                    fontFamily: 'Cairo',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  lesson.summary,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontFamily: 'Amiri',
                                                    fontSize: 14.5,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Wrap(
                                                  spacing: 6,
                                                  runSpacing: 4,
                                                  children: [
                                                    _miniTag(levelBadge, Colors.deepPurple),
                                                    _miniTag(lesson.duration, Colors.teal),
                                                    if (lesson.examples.isNotEmpty)
                                                      _miniTag('${lesson.examples.length} أمثلة', Colors.orange.shade800),
                                                    if (lesson.reviewQuestions.isNotEmpty)
                                                      _miniTag('${lesson.reviewQuestions.length} تمارين', Colors.indigo),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                visualDensity: VisualDensity.compact,
                                                onPressed: () => _progressService.toggleBookmark(lesson.title),
                                                icon: Icon(
                                                  isFav ? Icons.bookmark : Icons.bookmark_border,
                                                  color: isFav ? Colors.deepOrange : Colors.grey,
                                                  size: 20,
                                                ),
                                              ),
                                              IconButton(
                                                visualDensity: VisualDensity.compact,
                                                onPressed: () => _progressService.toggleLessonCompleted(lesson.title),
                                                icon: Icon(
                                                  isDone ? Icons.check_circle : Icons.check_circle_outline,
                                                  color: isDone ? Colors.green : Colors.grey,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 1,
          currentProgram: _activeProgram,
        ),
      ),
    );
  }

  Widget _miniTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(22),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontFamily: 'Cairo', fontSize: 10.5, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
