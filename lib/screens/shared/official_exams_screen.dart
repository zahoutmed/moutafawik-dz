import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/official_exams_data.dart';
import 'package:i_love_philosophy/models/education_models.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';

class OfficialExamsScreen extends StatefulWidget {
  final String? initialExamType; // 'BAC' أو 'BEM'
  final String? initialSubject;

  const OfficialExamsScreen({
    super.key,
    this.initialExamType,
    this.initialSubject,
  });

  @override
  State<OfficialExamsScreen> createState() => _OfficialExamsScreenState();
}

class _OfficialExamsScreenState extends State<OfficialExamsScreen> {
  late String _selectedType;
  late String _selectedSubject;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialExamType ?? 'الكل';
    _selectedSubject = widget.initialSubject ?? 'الكل';
  }

  @override
  Widget build(BuildContext context) {
    final allExams = OfficialExamsData.allExams;
    final subjects = ['الكل', ...allExams.map((e) => e.subject).toSet()];

    final filtered = allExams.where((exam) {
      final matchesType = _selectedType == 'الكل' || exam.examType == _selectedType;
      final matchesSubject = _selectedSubject == 'الكل' || exam.subject == _selectedSubject;
      final matchesSearch = _searchQuery.isEmpty ||
          exam.topicTitle.contains(_searchQuery) ||
          exam.subject.contains(_searchQuery) ||
          exam.streamOrLevel.contains(_searchQuery);
      return matchesType && matchesSubject && matchesSearch;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '📜 بنك الامتحانات الرسمية (BAC & BEM وتقييم المكتسبات)',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_background2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // رأس الفلترة
                Container(
                  color: Colors.white.withAlpha(240),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Column(
                    children: [
                      // شريط البحث
                      TextField(
                        onChanged: (val) => setState(() => _searchQuery = val.trim()),
                        decoration: InputDecoration(
                          hintText: 'ابحث عن مادة، سنة، أو شعبة...',
                          hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
                          prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.deepPurple.shade200),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // أزرار نوع الامتحان
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildTypeChip('الكل'),
                            const SizedBox(width: 8),
                            _buildTypeChip('BAC', 'بكالوريا BAC'),
                            const SizedBox(width: 8),
                            _buildTypeChip('BEM', 'شهادة التعليم المتوسط BEM'),
                            const SizedBox(width: 8),
                            _buildTypeChip('PRIMARY', 'تقييم المكتسبات (الابتدائي)'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // تصنيف المواد
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: subjects.map((sub) {
                            final isSel = _selectedSubject == sub;
                            return Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: ChoiceChip(
                                label: Text(
                                  sub,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                    color: isSel ? Colors.white : Colors.black87,
                                  ),
                                ),
                                selected: isSel,
                                selectedColor: Colors.deepPurple,
                                backgroundColor: Colors.grey.shade200,
                                onSelected: (_) => setState(() => _selectedSubject = sub),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // قائمة المواضيع الرسمية
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(220),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.menu_book, size: 48, color: Colors.grey),
                                SizedBox(height: 12),
                                Text(
                                  'لا توجد مواضيع مطابقة للفلتر المحدد.',
                                  style: TextStyle(fontFamily: 'Cairo', fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            return _buildExamCard(context, filtered[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildTypeChip(String type, [String? label]) {
    final isSel = _selectedType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedType = type),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSel ? Colors.deepPurple : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSel ? Colors.deepPurple : Colors.grey.shade300,
            ),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label ?? type,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSel ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, OfficialExamData exam) {
    final isBac = exam.examType == 'BAC';
    final accentColor = isBac ? Colors.deepPurple : Colors.teal;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withAlpha(245),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${exam.examType} ${exam.year}',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${exam.subject} - ${exam.streamOrLevel}',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              exam.topicTitle,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'المدة: ${exam.duration}',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: Colors.grey.shade700),
                ),
                const SizedBox(width: 16),
                Icon(Icons.grade_outlined, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'المعامل: ${exam.coefficient}',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.description_outlined, size: 18),
                    label: const Text('نص الموضوع'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: accentColor,
                      side: BorderSide(color: accentColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _showTopicDialog(context, exam),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('الحل وسلم التنقيط'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _showSolutionDialog(context, exam),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTopicDialog(BuildContext context, OfficialExamData exam) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.article, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'نص امتحان ${exam.examType} ${exam.year} - ${exam.subject}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: SelectableText(
                    exam.topicContent,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 17,
                      height: 1.8,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSolutionDialog(BuildContext context, OfficialExamData exam) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.fact_check, color: Colors.teal),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'الحل الرسمي وسلم التنقيط - ${exam.examType} ${exam.year}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.amber.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.rule, color: Colors.amber, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'سلم التنقيط الوزاري المعتمد:',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ...exam.gradingCriteria.map(
                              (c) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '• $c',
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12.5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        exam.solutionContent,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 16.5,
                          height: 1.8,
                          color: Colors.black87,
                        ),
                      ),
                    ],
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
