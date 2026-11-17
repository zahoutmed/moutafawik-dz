import 'package:flutter/material.dart';
import 'package:i_love_philosophy/models/education_models.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/pdf_view_screen.dart';
import 'package:i_love_philosophy/screens/outils/study_progress_service.dart';
import 'package:i_love_philosophy/utils/lesson_pdf_generator.dart';

/// شاشة العرض البيداغوجية الاحترافية متعددة الصفحات ومتكيفة مع جميع أحجام الشاشات
class LessonsDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? lessons;
  final LessonData? lessonData;

  const LessonsDetailScreen({this.lessons, this.lessonData, super.key});

  @override
  State<LessonsDetailScreen> createState() => _LessonsDetailScreenState();
}

class _LessonsDetailScreenState extends State<LessonsDetailScreen> {
  final StudyProgressService _progressService = StudyProgressService();
  final PageController _pageController = PageController();
  final Map<int, TextEditingController> _answerControllers = {};
  final Set<int> _solvedExercises = {};
  final Set<int> _revealedHints = {};

  int _currentStage = 0;
  double _fontScale = 1.0;
  bool _sepiaMode = false;
  bool _isGeneratingPdf = false;

  static const List<_LessonStageMeta> _stages = [
    _LessonStageMeta('الأهداف والانطلاق', Icons.flag_rounded),
    _LessonStageMeta('الشرح البيداغوجي', Icons.menu_book_rounded),
    _LessonStageMeta('الأمثلة المحلولة', Icons.lightbulb_rounded),
    _LessonStageMeta('ورشة التطبيقات', Icons.edit_note_rounded),
    _LessonStageMeta('المخطط و PDF', Icons.picture_as_pdf_rounded),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _answerControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _goToStage(int index, {required bool isWide}) {
    setState(() => _currentStage = index);
    if (!isWide && _pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _openLessonPdf({
    required String title,
    required String section,
    required String audience,
    required String duration,
    required String summary,
    required List<String> keyPoints,
    required String fullExplanation,
    required List<Map<String, dynamic>> detailedSections,
    required List<String> examples,
    required String mindMapSummary,
    required List<String> reviewQuestions,
    required String pdfFile,
  }) async {
    if (pdfFile.trim().isNotEmpty) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PDFViewScreen(pdfPath: pdfFile, title: title)),
      );
      return;
    }

    setState(() => _isGeneratingPdf = true);
    try {
      final bytes = await LessonPdfGenerator.buildLessonPdf(
        title: title,
        section: section,
        audience: audience,
        duration: duration,
        summary: summary,
        keyPoints: keyPoints,
        fullExplanation: fullExplanation,
        detailedSections: detailedSections,
        examples: examples,
        mindMapSummary: mindMapSummary,
        reviewQuestions: reviewQuestions,
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PDFViewScreen(pdfBytes: bytes, title: '$title (PDF)')),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر توليد ملف PDF: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final LessonData? ld = widget.lessonData;
    final Map<String, dynamic> raw = widget.lessons ?? ld?.toMap() ?? {};

    final String title = ld?.title ?? (raw['title'] ?? 'عنوان الدرس').toString();
    final String section = ld?.section ?? (raw['section'] ?? 'الميدان الدراسي').toString();
    final String summary = ld?.summary ?? (raw['desc'] ?? '').toString();
    final String duration = ld?.duration ?? (raw['duration'] ?? '45 دقيقة').toString();
    final String audience = ld?.audience ?? (raw['audience'] ?? 'جميع المستويات').toString();
    final String pdfFile = ld?.pdfFile ?? (raw['pdfFile'] ?? '').toString();

    final List<String> keyPoints = ld != null
        ? ld.keyPoints
        : (raw['keyPoints'] is List ? List<String>.from(raw['keyPoints'].map((e) => e.toString())) : []);

    final String fullExplanation = ld?.fullExplanation.isNotEmpty == true
        ? ld!.fullExplanation
        : (raw['fullExplanation']?.toString().isNotEmpty == true
            ? raw['fullExplanation'].toString()
            : summary);

    final List<Map<String, dynamic>> detailedSections = ld != null
        ? ld.detailedSections.map((s) => s.toMap()).toList()
        : (raw['detailedSections'] is List
            ? List<Map<String, dynamic>>.from(
                (raw['detailedSections'] as List).whereType<Map>().map((m) => Map<String, dynamic>.from(m)),
              )
            : []);

    final List<String> examples = ld != null
        ? ld.examples
        : (raw['examples'] is List ? List<String>.from(raw['examples'].map((e) => e.toString())) : []);

    final String mindMapSummary = ld?.mindMapSummary.isNotEmpty == true
        ? ld!.mindMapSummary
        : (raw['mindMapSummary'] ?? '').toString();

    final List<String> reviewQuestions = ld != null
        ? ld.reviewQuestions
        : (raw['reviewQuestions'] is List ? List<String>.from(raw['reviewQuestions'].map((e) => e.toString())) : []);

    final isDone = _progressService.isLessonCompleted(title);
    final isFav = _progressService.isBookmarked(title);

    final Color bgColor = _sepiaMode ? const Color(0xFFFBF0D9) : const Color(0xFFF4F5FA);
    final Color cardColor = _sepiaMode ? const Color(0xFFFFF8E8) : Colors.white;
    final Color textColor = _sepiaMode ? const Color(0xFF3E2D1C) : const Color(0xFF1F2333);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 820;

          final pages = <Widget>[
            _buildObjectivesPage(title, section, audience, duration, summary, keyPoints, cardColor, textColor),
            _buildExplanationPage(fullExplanation, detailedSections, cardColor, textColor),
            _buildExamplesPage(examples, cardColor, textColor),
            _buildWorkshopPage(reviewQuestions, keyPoints, cardColor, textColor),
            _buildSummaryAndPdfPage(
              title: title,
              section: section,
              audience: audience,
              duration: duration,
              summary: summary,
              keyPoints: keyPoints,
              fullExplanation: fullExplanation,
              detailedSections: detailedSections,
              examples: examples,
              mindMapSummary: mindMapSummary,
              reviewQuestions: reviewQuestions,
              pdfFile: pdfFile,
              cardColor: cardColor,
              textColor: textColor,
            ),
          ];

          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: const Color(0xFF3F1D77),
              foregroundColor: Colors.white,
              title: Text(
                title,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 14.5, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                IconButton(
                  icon: _isGeneratingPdf
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amberAccent),
                        )
                      : const Icon(Icons.picture_as_pdf_rounded, color: Colors.amberAccent),
                  tooltip: 'عرض الدرس كملف PDF',
                  onPressed: _isGeneratingPdf
                      ? null
                      : () => _openLessonPdf(
                            title: title,
                            section: section,
                            audience: audience,
                            duration: duration,
                            summary: summary,
                            keyPoints: keyPoints,
                            fullExplanation: fullExplanation,
                            detailedSections: detailedSections,
                            examples: examples,
                            mindMapSummary: mindMapSummary,
                            reviewQuestions: reviewQuestions,
                            pdfFile: pdfFile,
                          ),
                ),
                IconButton(
                  icon: const Icon(Icons.text_increase, size: 20),
                  tooltip: 'تكبير الخط',
                  onPressed: () => setState(() => _fontScale = (_fontScale + 0.1).clamp(0.85, 1.5)),
                ),
                IconButton(
                  icon: const Icon(Icons.text_decrease, size: 20),
                  tooltip: 'تصغير الخط',
                  onPressed: () => setState(() => _fontScale = (_fontScale - 0.1).clamp(0.85, 1.5)),
                ),
                IconButton(
                  icon: Icon(_sepiaMode ? Icons.wb_sunny : Icons.chrome_reader_mode, size: 20),
                  tooltip: 'وضع القراءة المريح',
                  onPressed: () => setState(() => _sepiaMode = !_sepiaMode),
                ),
                IconButton(
                  icon: Icon(isFav ? Icons.bookmark : Icons.bookmark_border, color: isFav ? Colors.amberAccent : Colors.white),
                  onPressed: () {
                    _progressService.toggleBookmark(title);
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: Icon(isDone ? Icons.check_circle : Icons.check_circle_outline, color: isDone ? Colors.greenAccent : Colors.white),
                  onPressed: () {
                    _progressService.toggleLessonCompleted(title);
                    setState(() {});
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                // شريط المحطات والمعلومات التكيّفي
                Container(
                  color: const Color(0xFF2B1055),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.layers, color: Colors.amberAccent, size: 15),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '$section  •  $audience  •  $duration',
                              style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 11.5),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'صفحة ${_currentStage + 1}/${_stages.length}',
                            style: const TextStyle(fontFamily: 'Cairo', color: Colors.amberAccent, fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: (_currentStage + 1) / _stages.length,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.amberAccent),
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      if (!isWide) ...[
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _stages.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final active = idx == _currentStage;
                              return Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () => _goToStage(idx, isWide: false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: active ? Colors.amberAccent : Colors.white12,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(entry.value.icon, size: 15, color: active ? Colors.black87 : Colors.white70),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${idx + 1}. ${entry.value.label}',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 11.5,
                                            fontWeight: active ? FontWeight.bold : FontWeight.normal,
                                            color: active ? Colors.black87 : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // جسم الدرس المتجاوب
                Expanded(
                  child: isWide
                      ? Row(
                          children: [
                            // فهرس جانبي ثابت للشاشات الكبيرة والأجهزة اللوحية
                            Container(
                              width: 240,
                              color: Colors.white,
                              child: ListView(
                                padding: const EdgeInsets.all(12),
                                children: [
                                  const Text(
                                    'محطات الدرس البيداغوجية',
                                    style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF3F1D77)),
                                  ),
                                  const Divider(),
                                  ..._stages.asMap().entries.map((e) {
                                    final active = e.key == _currentStage;
                                    return ListTile(
                                      dense: true,
                                      selected: active,
                                      selectedTileColor: const Color(0xFF3F1D77).withAlpha(20),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      leading: Icon(e.value.icon, color: active ? const Color(0xFF3F1D77) : Colors.grey),
                                      title: Text(
                                        '${e.key + 1}. ${e.value.label}',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 12.5,
                                          fontWeight: active ? FontWeight.bold : FontWeight.normal,
                                          color: active ? const Color(0xFF3F1D77) : Colors.black87,
                                        ),
                                      ),
                                      onTap: () => _goToStage(e.key, isWide: true),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            const VerticalDivider(width: 1),
                            Expanded(
                              child: IndexedStack(
                                index: _currentStage,
                                children: pages,
                              ),
                            ),
                          ],
                        )
                      : PageView(
                          controller: _pageController,
                          onPageChanged: (idx) => setState(() => _currentStage = idx),
                          children: pages,
                        ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _currentStage > 0 ? () => _goToStage(_currentStage - 1, isWide: isWide) : null,
                    icon: const Icon(Icons.arrow_back_ios, size: 15),
                    label: const Text('المحطة السابقة', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5)),
                  ),
                  const Spacer(),
                  if (_currentStage < _stages.length - 1)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F1D77),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _goToStage(_currentStage + 1, isWide: isWide),
                      icon: const Icon(Icons.arrow_forward_ios, size: 15),
                      label: const Text('المحطة التالية', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
                    )
                  else
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDone ? Colors.green : Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (!isDone) _progressService.toggleLessonCompleted(title);
                        Navigator.pop(context);
                      },
                      icon: Icon(isDone ? Icons.check_circle : Icons.done_all, size: 17),
                      label: Text(
                        isDone ? 'مكتمل ✓ العودة' : 'إتمام الدرس والعودة',
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildObjectivesPage(
    String title,
    String section,
    String audience,
    String duration,
    String summary,
    List<String> keyPoints,
    Color cardColor,
    Color textColor,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF3F1D77), Color(0xFF5D2DA8)]),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(section, style: const TextStyle(fontFamily: 'Cairo', color: Colors.amberAccent, fontSize: 12.5, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(title, style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 17 * _fontScale, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _pillBadge(Icons.school, audience),
                  _pillBadge(Icons.timer_outlined, duration),
                  _pillBadge(Icons.verified, 'المنهاج الرسمي الجزائري'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (summary.isNotEmpty)
          Card(
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.explore, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text('الوضعية الانطلاقية وفكرة الدرس', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15, color: Colors.deepPurple)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(summary, style: TextStyle(fontFamily: 'Amiri', fontSize: 17 * _fontScale, height: 1.7, color: textColor)),
                ],
              ),
            ),
          ),
        const SizedBox(height: 12),
        if (keyPoints.isNotEmpty)
          Card(
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.teal),
                      SizedBox(width: 8),
                      Text('أهداف التعلم والكفاءات المستهدفة', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...keyPoints.asMap().entries.map((e) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.teal.withAlpha(15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.teal.withAlpha(50)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 11,
                              backgroundColor: Colors.teal,
                              child: Text('${e.key + 1}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(e.value, style: TextStyle(fontFamily: 'Amiri', fontSize: 16 * _fontScale, height: 1.5, color: textColor)),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExplanationPage(
    String fullExplanation,
    List<Map<String, dynamic>> detailedSections,
    Color cardColor,
    Color textColor,
  ) {
    final blocks = fullExplanation.split('\n').where((l) => l.trim().isNotEmpty).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: blocks.map((line) {
                final trimmed = line.trim();
                final isHeading = trimmed.startsWith('■') || trimmed.startsWith('#');
                if (isHeading) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 14, bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3F1D77).withAlpha(18),
                      borderRadius: BorderRadius.circular(10),
                      border: const Border(right: BorderSide(color: Color(0xFF3F1D77), width: 4)),
                    ),
                    child: Text(
                      trimmed.replaceFirst('■', '').trim(),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15 * _fontScale,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3F1D77),
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    trimmed,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 17 * _fontScale,
                      height: 1.75,
                      color: textColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        if (detailedSections.isNotEmpty) ...[
          const SizedBox(height: 14),
          const Text(
            '📌 محاور ومفاهيم مهيكلة',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF3F1D77)),
          ),
          const SizedBox(height: 8),
          ...detailedSections.map((sec) {
            final sTitle = (sec['title'] ?? '').toString();
            final sContent = (sec['content'] ?? '').toString();
            final bullets = (sec['bulletPoints'] is List)
                ? List<String>.from((sec['bulletPoints'] as List).map((e) => e.toString()))
                : <String>[];
            return Card(
              color: cardColor,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sTitle.isNotEmpty)
                      Text(sTitle, style: TextStyle(fontFamily: 'Cairo', fontSize: 14.5 * _fontScale, fontWeight: FontWeight.bold, color: Colors.teal.shade800)),
                    if (sContent.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(sContent, style: TextStyle(fontFamily: 'Amiri', fontSize: 16.5 * _fontScale, height: 1.65, color: textColor)),
                    ],
                    if (bullets.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...bullets.map((b) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 16)),
                                Expanded(child: Text(b, style: TextStyle(fontFamily: 'Amiri', fontSize: 15.5 * _fontScale, color: textColor))),
                              ],
                            ),
                          )),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildExamplesPage(List<String> examples, Color cardColor, Color textColor) {
    if (examples.isEmpty) {
      return const Center(
        child: Text('لا توجد أمثلة محلولة مسجلة لهذا الدرس حالياً.', style: TextStyle(fontFamily: 'Cairo', fontSize: 15)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: examples.length,
      itemBuilder: (_, idx) {
        return Card(
          color: cardColor,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'مثال تطبيقي محلول ${idx + 1}',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  examples[idx],
                  style: TextStyle(fontFamily: 'Amiri', fontSize: 16.5 * _fontScale, height: 1.75, color: textColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWorkshopPage(List<String> reviewQuestions, List<String> keyPoints, Color cardColor, Color textColor) {
    if (reviewQuestions.isEmpty) {
      return const Center(
        child: Text('لا توجد تمارين تطبيقية لهذا الدرس حالياً.', style: TextStyle(fontFamily: 'Cairo', fontSize: 15)),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.indigo.shade200),
          ),
          child: Row(
            children: [
              const Icon(Icons.engineering, color: Colors.indigo, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ورشة التطبيقات والوضعيات الإدماجية', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 14.5, color: Colors.indigo)),
                    Text(
                      'أنجزت ${_solvedExercises.length} من ${reviewQuestions.length} تمارين',
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...reviewQuestions.asMap().entries.map((entry) {
          final idx = entry.key;
          final question = entry.value;
          final controller = _answerControllers.putIfAbsent(idx, () => TextEditingController());
          final isSolved = _solvedExercises.contains(idx);
          final showHint = _revealedHints.contains(idx);
          final hintText = keyPoints.isNotEmpty
              ? keyPoints[idx % keyPoints.length]
              : 'راجع القاعدة الأساسية والمثال التطبيقي في المحطة السابقة.';

          return Card(
            color: cardColor,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isSolved ? Colors.green : Colors.transparent, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: isSolved ? Colors.green : Colors.indigo,
                        child: Text('${idx + 1}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          idx == reviewQuestions.length - 1 ? 'وضعية إدماجية / تمرين شامل' : 'تمرين تطبيقي ${idx + 1}',
                          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13, color: isSolved ? Colors.green.shade700 : Colors.indigo),
                        ),
                      ),
                      if (isSolved) const Icon(Icons.verified, color: Colors.green, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(question, style: TextStyle(fontFamily: 'Amiri', fontSize: 16.5 * _fontScale, height: 1.65, color: textColor)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'اكتب محاولتك أو خطوات الحل هنا...',
                      hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            if (showHint) {
                              _revealedHints.remove(idx);
                            } else {
                              _revealedHints.add(idx);
                            }
                          });
                        },
                        icon: const Icon(Icons.tips_and_updates_outlined, size: 17, color: Colors.amber),
                        label: Text(showHint ? 'إخفاء التلميح' : 'تلميح للحل', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12)),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSolved ? Colors.green : Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        onPressed: () {
                          setState(() {
                            if (isSolved) {
                              _solvedExercises.remove(idx);
                            } else {
                              _solvedExercises.add(idx);
                            }
                          });
                        },
                        icon: Icon(isSolved ? Icons.check_circle : Icons.task_alt, size: 16),
                        label: Text(isSolved ? 'تم الإنجاز ✓' : 'تأكيد الحل', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12)),
                      ),
                    ],
                  ),
                  if (showHint)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Text('💡 مفتاح الحل: $hintText', style: TextStyle(fontFamily: 'Amiri', fontSize: 15 * _fontScale, color: Colors.brown.shade800)),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSummaryAndPdfPage({
    required String title,
    required String section,
    required String audience,
    required String duration,
    required String summary,
    required List<String> keyPoints,
    required String fullExplanation,
    required List<Map<String, dynamic>> detailedSections,
    required List<String> examples,
    required String mindMapSummary,
    required List<String> reviewQuestions,
    required String pdfFile,
    required Color cardColor,
    required Color textColor,
  }) {
    final mapLines = mindMapSummary.split('\n').where((l) => l.trim().isNotEmpty).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.alt_route_rounded, color: Colors.teal),
                    SizedBox(width: 8),
                    Text('المخطط الذهني وخلاصة الدرس', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15, color: Colors.teal)),
                  ],
                ),
                const SizedBox(height: 12),
                if (mapLines.isEmpty)
                  Text('لا يوجد مخطط ذهني مسجل.', style: TextStyle(fontFamily: 'Amiri', fontSize: 15, color: textColor))
                else
                  ...mapLines.map((line) => Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.teal.withAlpha(15),
                          borderRadius: BorderRadius.circular(10),
                          border: const Border(right: BorderSide(color: Colors.teal, width: 3)),
                        ),
                        child: Text(line.trim(), style: TextStyle(fontFamily: 'Amiri', fontSize: 16 * _fontScale, height: 1.5, color: textColor)),
                      )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Card(
          color: const Color(0xFF3F1D77),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                const Icon(Icons.picture_as_pdf_rounded, color: Colors.amberAccent, size: 42),
                const SizedBox(height: 8),
                const Text(
                  'نسخة الدرس المنسقة بصيغة PDF متعددة الصفحات',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.5),
                ),
                const SizedBox(height: 6),
                const Text(
                  'اعرض الدرس كاملاً مع الأمثلة والتمارين في عارض PDF الاحترافي للتصفح والتكبير.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Cairo', color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: _isGeneratingPdf
                      ? null
                      : () => _openLessonPdf(
                            title: title,
                            section: section,
                            audience: audience,
                            duration: duration,
                            summary: summary,
                            keyPoints: keyPoints,
                            fullExplanation: fullExplanation,
                            detailedSections: detailedSections,
                            examples: examples,
                            mindMapSummary: mindMapSummary,
                            reviewQuestions: reviewQuestions,
                            pdfFile: pdfFile,
                          ),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(
                    _isGeneratingPdf ? 'جاري تجهيز ملف PDF...' : 'فتح الدرس كصفحات PDF',
                    style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _pillBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.amberAccent),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.white)),
        ],
      ),
    );
  }
}

class _LessonStageMeta {
  final String label;
  final IconData icon;
  const _LessonStageMeta(this.label, this.icon);
}
