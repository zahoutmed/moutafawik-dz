import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/curriculum_repository.dart';
import 'package:i_love_philosophy/screens/shared/subject_hub_screen.dart';

/// الشاشة الذكية للترابط الهرمي:
/// عند اختيار الشعبة -> تعرض السنوات والمواد بمعاملاتها وبرامجها
/// عند اختيار المادة -> تعرض الشعب والسنوات وتحدد الدروس والاختبارات مباشرة
class StreamSubjectNavigatorScreen extends StatefulWidget {
  final String initialMode; // 'stream' أو 'subject'
  final String initialTarget; // اسم الشعبة أو اسم المادة
  final String stage;

  const StreamSubjectNavigatorScreen({
    super.key,
    this.initialMode = 'stream',
    this.initialTarget = 'شعبة علوم تجريبية',
    this.stage = 'التعليم الثانوي',
  });

  @override
  State<StreamSubjectNavigatorScreen> createState() => _StreamSubjectNavigatorScreenState();
}

class _StreamSubjectNavigatorScreenState extends State<StreamSubjectNavigatorScreen> {
  late String _mode;
  late String _selectedTarget;
  late String _selectedYear;
  late String _selectedStream;

  // خريطة السنوات لكل شعبة
  final Map<String, List<String>> _streamYears = {
    'شعبة علوم تجريبية': ['السنة الثالثة ثانوي (BAC)', 'السنة الثانية ثانوي', 'السنة الأولى ثانوي (ج.م.ع.ت)'],
    'شعبة رياضيات': ['السنة الثالثة ثانوي (BAC)', 'السنة الثانية ثانوي', 'السنة الأولى ثانوي (ج.م.ع.ت)'],
    'شعبة تقني رياضي': ['السنة الثالثة ثانوي (BAC)', 'السنة الثانية ثانوي', 'السنة الأولى ثانوي (ج.م.ع.ت)'],
    'شعبة تسيير واقتصاد': ['السنة الثالثة ثانوي (BAC)', 'السنة الثانية ثانوي', 'السنة الأولى ثانوي (ج.م.ع.ت)'],
    'شعبة آداب وفلسفة': ['السنة الثالثة ثانوي (BAC)', 'السنة الثانية ثانوي', 'السنة الأولى ثانوي (ج.م.آداب)'],
    'شعبة لغات أجنبية': ['السنة الثالثة ثانوي (BAC)', 'السنة الثانية ثانوي', 'السنة الأولى ثانوي (ج.م.آداب)'],
    'ج.م.علوم وتكنولوجيا': ['السنة الأولى ثانوي (جذع مشترك علوم وتكنولوجيا)'],
    'جذع مشترك آداب': ['السنة الأولى ثانوي (جذع مشترك آداب)'],
    'شعبة الفنون': ['السنة الثالثة ثانوي (BAC)', 'السنة الثانية ثانوي'],
  };

  // خريطة المواد ومعاملاتها الرسمية الوزارية لكل شعبة في البكالوريا
  final Map<String, List<Map<String, dynamic>>> _streamCurriculum = {
    'شعبة علوم تجريبية': [
      {'name': 'العلوم الطبيعية', 'coeff': 6, 'icon': 'assets/icons/science.png', 'color': Colors.lightBlue},
      {'name': 'العلوم الفيزيائية', 'coeff': 5, 'icon': 'assets/icons/physics.png', 'color': Colors.indigo},
      {'name': 'الرياضيات', 'coeff': 5, 'icon': 'assets/icons/math.png', 'color': Colors.green},
      {'name': 'الفلسفة', 'coeff': 2, 'icon': 'assets/icons/philo.png', 'color': Colors.deepPurple},
      {'name': 'اللغة العربية', 'coeff': 3, 'icon': 'assets/icons/arabic.png', 'color': Colors.pink},
      {'name': 'العلوم الإسلامية', 'coeff': 2, 'icon': 'assets/icons/islamic.png', 'color': Colors.teal},
      {'name': 'التاريخ والجغرافيا', 'coeff': 2, 'icon': 'assets/icons/his_geo.png', 'color': Colors.brown},
      {'name': 'اللغة الفرنسية', 'coeff': 2, 'icon': 'assets/icons/french.png', 'color': Colors.blue},
      {'name': 'اللغة الإنجليزية', 'coeff': 2, 'icon': 'assets/icons/english.png', 'color': Colors.deepPurpleAccent},
    ],
    'شعبة رياضيات': [
      {'name': 'الرياضيات', 'coeff': 7, 'icon': 'assets/icons/math.png', 'color': Colors.green},
      {'name': 'العلوم الفيزيائية', 'coeff': 6, 'icon': 'assets/icons/physics.png', 'color': Colors.indigo},
      {'name': 'العلوم الطبيعية', 'coeff': 2, 'icon': 'assets/icons/science.png', 'color': Colors.lightBlue},
      {'name': 'الفلسفة', 'coeff': 2, 'icon': 'assets/icons/philo.png', 'color': Colors.deepPurple},
      {'name': 'اللغة العربية', 'coeff': 3, 'icon': 'assets/icons/arabic.png', 'color': Colors.pink},
      {'name': 'العلوم الإسلامية', 'coeff': 2, 'icon': 'assets/icons/islamic.png', 'color': Colors.teal},
      {'name': 'التاريخ والجغرافيا', 'coeff': 2, 'icon': 'assets/icons/his_geo.png', 'color': Colors.brown},
      {'name': 'اللغة الفرنسية', 'coeff': 2, 'icon': 'assets/icons/french.png', 'color': Colors.blue},
      {'name': 'اللغة الإنجليزية', 'coeff': 2, 'icon': 'assets/icons/english.png', 'color': Colors.deepPurpleAccent},
    ],
    'شعبة تقني رياضي': [
      {'name': 'الهندسة الميكانيكية', 'coeff': 7, 'icon': 'assets/icons/mecanical.png', 'color': Colors.blueGrey},
      {'name': 'الهندسة الكهربائية', 'coeff': 7, 'icon': 'assets/icons/elect.png', 'color': Colors.orange},
      {'name': 'الهندسة المدنية', 'coeff': 7, 'icon': 'assets/icons/civil.png', 'color': Colors.brown},
      {'name': 'هندسة الطرائق', 'coeff': 7, 'icon': 'assets/icons/chimi.png', 'color': Colors.cyan},
      {'name': 'الرياضيات', 'coeff': 6, 'icon': 'assets/icons/math.png', 'color': Colors.green},
      {'name': 'العلوم الفيزيائية', 'coeff': 6, 'icon': 'assets/icons/physics.png', 'color': Colors.indigo},
      {'name': 'الفلسفة', 'coeff': 2, 'icon': 'assets/icons/philo.png', 'color': Colors.deepPurple},
      {'name': 'اللغة العربية', 'coeff': 3, 'icon': 'assets/icons/arabic.png', 'color': Colors.pink},
      {'name': 'العلوم الإسلامية', 'coeff': 2, 'icon': 'assets/icons/islamic.png', 'color': Colors.teal},
      {'name': 'التاريخ والجغرافيا', 'coeff': 2, 'icon': 'assets/icons/his_geo.png', 'color': Colors.brown},
    ],
    'شعبة تسيير واقتصاد': [
      {'name': 'التسيير المحاسبي والمالي', 'coeff': 6, 'icon': 'assets/icons/gestion.png', 'color': Colors.deepOrange},
      {'name': 'الإقتصاد والمناجمنت', 'coeff': 5, 'icon': 'assets/icons/eco.png', 'color': Colors.amber},
      {'name': 'الرياضيات', 'coeff': 5, 'icon': 'assets/icons/math.png', 'color': Colors.green},
      {'name': 'القانون', 'coeff': 2, 'icon': 'assets/icons/droit.png', 'color': Colors.blueGrey},
      {'name': 'الفلسفة', 'coeff': 2, 'icon': 'assets/icons/philo.png', 'color': Colors.deepPurple},
      {'name': 'اللغة العربية', 'coeff': 3, 'icon': 'assets/icons/arabic.png', 'color': Colors.pink},
      {'name': 'التاريخ والجغرافيا', 'coeff': 4, 'icon': 'assets/icons/his_geo.png', 'color': Colors.brown},
      {'name': 'العلوم الإسلامية', 'coeff': 2, 'icon': 'assets/icons/islamic.png', 'color': Colors.teal},
    ],
    'شعبة آداب وفلسفة': [
      {'name': 'الفلسفة', 'coeff': 6, 'icon': 'assets/icons/philo.png', 'color': Colors.deepPurple},
      {'name': 'اللغة العربية', 'coeff': 6, 'icon': 'assets/icons/arabic.png', 'color': Colors.pink},
      {'name': 'التاريخ والجغرافيا', 'coeff': 4, 'icon': 'assets/icons/his_geo.png', 'color': Colors.brown},
      {'name': 'اللغة الفرنسية', 'coeff': 3, 'icon': 'assets/icons/french.png', 'color': Colors.blue},
      {'name': 'اللغة الإنجليزية', 'coeff': 3, 'icon': 'assets/icons/english.png', 'color': Colors.purple},
      {'name': 'العلوم الإسلامية', 'coeff': 2, 'icon': 'assets/icons/islamic.png', 'color': Colors.teal},
      {'name': 'الرياضيات', 'coeff': 2, 'icon': 'assets/icons/math.png', 'color': Colors.green},
    ],
    'شعبة لغات أجنبية': [
      {'name': 'اللغة الفرنسية', 'coeff': 5, 'icon': 'assets/icons/french.png', 'color': Colors.blue},
      {'name': 'اللغة الإنجليزية', 'coeff': 5, 'icon': 'assets/icons/english.png', 'color': Colors.purple},
      {'name': 'اللغة الإسبانية', 'coeff': 4, 'icon': 'assets/icons/espanol.png', 'color': Colors.redAccent},
      {'name': 'اللغة الألمانية', 'coeff': 4, 'icon': 'assets/icons/deutsch.png', 'color': Colors.deepPurple},
      {'name': 'اللغة الإيطالية', 'coeff': 4, 'icon': 'assets/icons/italian.png', 'color': Colors.green},
      {'name': 'اللغة العربية', 'coeff': 5, 'icon': 'assets/icons/arabic.png', 'color': Colors.pink},
      {'name': 'الفلسفة', 'coeff': 2, 'icon': 'assets/icons/philo.png', 'color': Colors.deepPurple},
      {'name': 'التاريخ والجغرافيا', 'coeff': 2, 'icon': 'assets/icons/his_geo.png', 'color': Colors.brown},
      {'name': 'العلوم الإسلامية', 'coeff': 2, 'icon': 'assets/icons/islamic.png', 'color': Colors.teal},
    ],
  };

  // خريطة الشعب التي تدرس فيها كل مادة
  final Map<String, List<String>> _subjectStreams = {
    'الرياضيات': ['شعبة رياضيات', 'شعبة علوم تجريبية', 'شعبة تقني رياضي', 'شعبة تسيير واقتصاد', 'شعبة آداب وفلسفة'],
    'العلوم الفيزيائية': ['شعبة علوم تجريبية', 'شعبة رياضيات', 'شعبة تقني رياضي'],
    'العلوم الطبيعية': ['شعبة علوم تجريبية', 'شعبة رياضيات'],
    'الفلسفة': ['شعبة آداب وفلسفة', 'شعبة علوم تجريبية', 'شعبة رياضيات', 'شعبة تسيير واقتصاد', 'شعبة لغات أجنبية', 'شعبة تقني رياضي'],
    'اللغة العربية': ['شعبة آداب وفلسفة', 'شعبة لغات أجنبية', 'شعبة علوم تجريبية', 'شعبة رياضيات', 'شعبة تسيير واقتصاد'],
    'التاريخ والجغرافيا': ['شعبة آداب وفلسفة', 'شعبة تسيير واقتصاد', 'شعبة علوم تجريبية', 'شعبة رياضيات', 'شعبة لغات أجنبية'],
    'العلوم الإسلامية': ['شعبة علوم تجريبية', 'شعبة رياضيات', 'شعبة آداب وفلسفة', 'شعبة تسيير واقتصاد', 'شعبة لغات أجنبية'],
    'التسيير المحاسبي والمالي': ['شعبة تسيير واقتصاد'],
    'الإقتصاد والمناجمنت': ['شعبة تسيير واقتصاد'],
    'القانون': ['شعبة تسيير واقتصاد'],
    'الهندسة الميكانيكية': ['شعبة تقني رياضي'],
    'الهندسة الكهربائية': ['شعبة تقني رياضي'],
    'الهندسة المدنية': ['شعبة تقني رياضي'],
    'هندسة الطرائق': ['شعبة تقني رياضي'],
  };

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    _selectedTarget = widget.initialTarget;

    if (_mode == 'stream') {
      final years = _streamYears[_selectedTarget] ?? ['السنة الثالثة ثانوي (BAC)'];
      _selectedYear = years.first;
      _selectedStream = _selectedTarget;
    } else {
      final streams = _subjectStreams[_selectedTarget] ?? ['شعبة علوم تجريبية'];
      _selectedStream = streams.first;
      _selectedYear = 'السنة الثالثة ثانوي (BAC)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _mode == 'stream' ? 'مسار الشعبة: $_selectedTarget' : 'مسار المادة: $_selectedTarget',
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          actions: [
            // زر التبديل السريع بين المنظورين
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _mode = _mode == 'stream' ? 'subject' : 'stream';
                  _selectedTarget = _mode == 'stream' ? 'شعبة علوم تجريبية' : 'الرياضيات';
                });
              },
              icon: Icon(_mode == 'stream' ? Icons.subject : Icons.account_tree, color: Colors.amberAccent, size: 18),
              label: Text(
                _mode == 'stream' ? 'عرض بالمواد' : 'عرض بالشعب',
                style: const TextStyle(fontFamily: 'Cairo', color: Colors.amberAccent, fontSize: 12),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_background2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (_mode == 'stream') _buildStreamFirstView() else _buildSubjectFirstView(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. منظور الشعبة -> اختيار السنة -> المواد والمعاملات
  // ==========================================
  Widget _buildStreamFirstView() {
    final availableYears = _streamYears[_selectedTarget] ?? ['السنة الثالثة ثانوي (BAC)'];
    final subjects = _streamCurriculum[_selectedTarget] ?? _streamCurriculum['شعبة علوم تجريبية']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // بطاقة ملخص الشعبة
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white.withAlpha(240),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.school, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedTarget,
                            style: const TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'اختر السنة الدراسية ثم حدد المادة للدخول المباشر إلى الدروس والأنشطة والاختبارات',
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('السنة الدراسية المستهدفة:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableYears.map((yr) {
                    final isSel = yr == _selectedYear;
                    return ChoiceChip(
                      label: Text(yr, style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: isSel ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                      selected: isSel,
                      selectedColor: Colors.deepPurple,
                      backgroundColor: Colors.grey.shade200,
                      onSelected: (val) {
                        if (val) setState(() => _selectedYear = yr);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'مواد $_selectedTarget ($_selectedYear):',
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 14.5, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.amber.shade200, borderRadius: BorderRadius.circular(8)),
              child: Text(
                '${subjects.length} مواد رسمية',
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // شبكة المواد التابعة للشعبة مع المعاملات الرسمية
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final s = subjects[index];
            final String name = s['name'];
            final int coeff = s['coeff'];
            final String icon = s['icon'];
            final Color color = s['color'];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withAlpha(30),
                  child: Image.asset(
                    icon,
                    height: 26,
                    errorBuilder: (_, __, ___) => Icon(Icons.book, color: color),
                  ),
                ),
                title: Text(
                  name,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'المعامل الرسمي: $coeff | $_selectedYear',
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: Colors.grey),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.deepPurple.shade200),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('فتح المادة', style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Colors.deepPurple),
                    ],
                  ),
                ),
                onTap: () {
                  final resolvedProgram = CurriculumRepository.resolveProgram(
                    title: name,
                    stageName: '$_selectedTarget - $_selectedYear',
                    iconPath: icon,
                    accentColor: color,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubjectHubScreen(
                        title: name,
                        stageName: '$_selectedTarget - $_selectedYear',
                        iconPath: icon,
                        accentColor: color,
                        program: resolvedProgram,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================
  // 2. منظور المادة -> اختيار الشعبة والسنة -> تحديد الدروس
  // ==========================================
  Widget _buildSubjectFirstView() {
    final availableStreams = _subjectStreams[_selectedTarget] ?? ['شعبة علوم تجريبية', 'شعبة رياضيات', 'شعبة آداب وفلسفة'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white.withAlpha(240),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.menu_book, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مادة: $_selectedTarget',
                            style: const TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'حدد الشعبة والسنة لعرض الدروس والمحتوى المخصص لها بدقة',
                            style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('الشعبة المقررة:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableStreams.map((st) {
                    final isSel = st == _selectedStream;
                    return ChoiceChip(
                      label: Text(st, style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: isSel ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                      selected: isSel,
                      selectedColor: Colors.teal,
                      backgroundColor: Colors.grey.shade200,
                      onSelected: (val) {
                        if (val) setState(() => _selectedStream = st);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                const Text('السنة الدراسية:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    'السنة الثالثة ثانوي (BAC)',
                    'السنة الثانية ثانوي',
                    'السنة الأولى ثانوي',
                  ].map((yr) {
                    final isSel = yr == _selectedYear;
                    return ChoiceChip(
                      label: Text(yr, style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: isSel ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                      selected: isSel,
                      selectedColor: Colors.deepPurple,
                      backgroundColor: Colors.grey.shade200,
                      onSelected: (val) {
                        if (val) setState(() => _selectedYear = yr);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        // بطاقة الدخول المباشر إلى المادة
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade800,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
          ),
          icon: const Icon(Icons.rocket_launch, color: Colors.amberAccent),
          label: Text(
            'عرض برنامج $_selectedTarget لـ ($_selectedStream - $_selectedYear)',
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            final resolvedProgram = CurriculumRepository.resolveProgram(
              title: _selectedTarget,
              stageName: '$_selectedStream - $_selectedYear',
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SubjectHubScreen(
                  title: _selectedTarget,
                  stageName: '$_selectedStream - $_selectedYear',
                  iconPath: 'assets/icons/book_cover.png',
                  accentColor: Colors.teal,
                  program: resolvedProgram,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
