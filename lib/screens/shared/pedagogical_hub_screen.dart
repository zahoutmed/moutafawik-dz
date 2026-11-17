import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/pedagogical_hub_data.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';

/// الشاشة المركزية للأقسام البيداغوجية التخصصية الثمانية:
/// متفرقات - ألعاب تربوية - البرنامج المقرر - نصائح - جداول - مذكرات للأساتذة - ملخصات - أسئلة
class PedagogicalHubScreen extends StatefulWidget {
  final int initialTabIndex;

  const PedagogicalHubScreen({super.key, this.initialTabIndex = 0});

  @override
  State<PedagogicalHubScreen> createState() => _PedagogicalHubScreenState();
}

class _PedagogicalHubScreenState extends State<PedagogicalHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _gameScore = 0;
  final Map<String, int> _selectedAnswers = {};

  final List<Map<String, dynamic>> _tabs = const [
    {'title': 'ألعاب تربوية', 'icon': Icons.sports_esports},
    {'title': 'البرنامج المقرر', 'icon': Icons.assignment_outlined},
    {'title': 'نصائح وتوجيهات', 'icon': Icons.lightbulb_outline},
    {'title': 'جداول المراجعة', 'icon': Icons.calendar_month},
    {'title': 'مذكرات الأساتذة', 'icon': Icons.history_edu},
    {'title': 'ملخصات سريعة', 'icon': Icons.menu_book},
    {'title': 'بنك الأسئلة', 'icon': Icons.quiz_outlined},
    {'title': 'متفرقات', 'icon': Icons.auto_awesome},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      initialIndex: widget.initialTabIndex.clamp(0, _tabs.length - 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '🌟 الأقسام البيداغوجية والتفوق',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16),
          ),
          backgroundColor: const Color(0xFF3F1D77),
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.amberAccent,
            indicatorWeight: 3,
            labelColor: Colors.amberAccent,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold),
            tabs: _tabs.map((t) => Tab(icon: Icon(t['icon'] as IconData, size: 18), text: t['title'] as String)).toList(),
          ),
        ),
        drawer: const CustomDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_background2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildGamesTab(),
              _buildCurriculaTab(),
              _buildTipsTab(),
              _buildSchedulesTab(),
              _buildTeacherPlansTab(),
              _buildQuickSummariesTab(),
              _buildQuestionBankTab(),
              _buildMiscellaneousTab(),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. ألعاب تربوية هادفة
  // ==========================================
  Widget _buildGamesTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Card(
          color: const Color(0xFF2E1254),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.amberAccent, size: 28),
                    SizedBox(width: 10),
                    Text(
                      'رصيد نقاط التحدي:',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(color: Colors.amberAccent, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    '$_gameScore نقطة',
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...PedagogicalHubData.educationalGames.map((game) {
          final title = game['title'] as String;
          final desc = game['description'] as String;
          final questions = game['questions'] as List<dynamic>;

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        radius: 16,
                        child: Icon(Icons.gamepad, size: 18, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(desc, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: Colors.grey)),
                  const Divider(height: 20),
                  ...questions.asMap().entries.map((qEntry) {
                    final qIdx = qEntry.key;
                    final qData = qEntry.value as Map<String, dynamic>;
                    final qText = qData['q'] as String;
                    final options = qData['options'] as List<dynamic>;
                    final correctAns = qData['ans'] as int;
                    final exp = qData['explanation'] as String;
                    final questionKey = '$title-$qIdx';
                    final selected = _selectedAnswers[questionKey];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('سؤال ${qIdx + 1}: $qText', style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: options.asMap().entries.map((opt) {
                              final optIdx = opt.key;
                              final optText = opt.value as String;
                              final isChosen = selected == optIdx;
                              final isCorrect = isChosen && optIdx == correctAns;

                              return ChoiceChip(
                                label: Text(optText, style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: isChosen ? Colors.white : Colors.black87)),
                                selected: isChosen,
                                selectedColor: isCorrect ? Colors.green : Colors.redAccent,
                                backgroundColor: Colors.grey.shade100,
                                onSelected: (val) {
                                  if (selected == null) {
                                    setState(() {
                                      _selectedAnswers[questionKey] = optIdx;
                                      if (optIdx == correctAns) _gameScore += 10;
                                    });
                                  }
                                },
                              );
                            }).toList(),
                          ),
                          if (selected != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text('💡 التوضيح: $exp', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: Colors.teal)),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ==========================================
  // 2. البرنامج المقرر والتدرجات السنوية الوزارية
  // ==========================================
  Widget _buildCurriculaTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        const Text(
          '📜 التدرجات السنوية الرسمية لوزارة التربية الوطنية لكل مادة وطور:',
          style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        ...PedagogicalHubData.officialCurricula.map((curr) {
          final subject = curr['subject'] as String;
          final stage = curr['stage'] as String;
          final hours = curr['hours'] as String;
          final coeff = curr['coeff'] as String;
          final ref = curr['officialReference'] as String;
          final progs = curr['progressions'] as List<String>;
          final comps = curr['competencies'] as String;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: ExpansionTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.menu_book, color: Colors.white, size: 20),
              ),
              title: Text('$subject - $stage', style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold)),
              subtitle: Text('الحجم الساعي: $hours | المعامل: $coeff', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: Colors.grey)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('المرجع الرسمي: $ref', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('الكفاءات الختامية المستهدفة:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
                      Text(comps, style: const TextStyle(fontFamily: 'Amiri', fontSize: 14.5, color: Colors.black87)),
                      const Divider(height: 16),
                      const Text('توزيع المحاور والوحدات عبر الفصول:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      ...progs.map((p) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('🔹 '),
                                Expanded(child: Text(p, style: const TextStyle(fontFamily: 'Amiri', fontSize: 14))),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ==========================================
  // 3. نصائح وتوجيهات التفوق
  // ==========================================
  Widget _buildTipsTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: PedagogicalHubData.tipsAndGuidance.map((tip) {
        final title = tip['title'] as String;
        final cat = tip['category'] as String;
        final content = tip['content'] as String;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(8)),
                      child: Text(cat, style: TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.amber.shade900)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                const Divider(height: 16),
                Text(content, style: const TextStyle(fontFamily: 'Amiri', fontSize: 15.5, height: 1.7, color: Colors.black87)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ==========================================
  // 4. جداول التوقيت والمراجعة
  // ==========================================
  Widget _buildSchedulesTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: PedagogicalHubData.studySchedules.map((sch) {
        final title = sch['title'] as String;
        final target = sch['target'] as String;
        final days = sch['days'] as List<dynamic>;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: ExpansionTile(
            leading: const CircleAvatar(backgroundColor: Colors.indigo, child: Icon(Icons.calendar_today, color: Colors.white, size: 20)),
            title: Text(title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold)),
            subtitle: Text('الفئة المستهدفة: $target', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: Colors.grey)),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('اليوم', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('الفترة الصباحية (تركيز عالي)', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('الفترة المسائية', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('الفترة الليلية (خفيفة)', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold))),
                  ],
                  rows: days.map((d) {
                    return DataRow(cells: [
                      DataCell(Text(d['day'].toString(), style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.deepPurple))),
                      DataCell(Text(d['morning'].toString(), style: const TextStyle(fontFamily: 'Cairo', fontSize: 12))),
                      DataCell(Text(d['evening'].toString(), style: const TextStyle(fontFamily: 'Cairo', fontSize: 12))),
                      DataCell(Text(d['night'].toString(), style: const TextStyle(fontFamily: 'Cairo', fontSize: 12))),
                    ]);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ==========================================
  // 5. مذكرات بيداغوجية للأساتذة (ليست مفكرة)
  // ==========================================
  Widget _buildTeacherPlansTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        const Text(
          '👩‍🏫 مذكرات بيداغوجية نموذجية لأساتذة التعليم وفق المقاربة بالكفاءات:',
          style: TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        ...PedagogicalHubData.teacherLessonPlans.map((plan) {
          final subject = plan['subject'] as String;
          final level = plan['level'] as String;
          final unit = plan['unit'] as String;
          final lessonTitle = plan['lessonTitle'] as String;
          final details = plan['planDetails'] as Map<String, dynamic>;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: ExpansionTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.history_edu, color: Colors.white, size: 20),
              ),
              title: Text(lessonTitle, style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold)),
              subtitle: Text('$subject | $level | $unit', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: Colors.grey)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPlanItem('🎯 الكفاءة المستهدفة:', details['الكفاءة المستهدفة'].toString()),
                      _buildPlanItem('🛠️ الوسائل والديدكتيك:', details['الوسائل والديدكتيك'].toString()),
                      _buildPlanItem('🚀 وضعية الانطلاق والإشكال:', details['وضعية الانطلاق (10د)'].toString()),
                      const SizedBox(height: 8),
                      const Text('📋 مراحل بناء التعلمات وسيرورة النشاط:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                      const SizedBox(height: 4),
                      if (details['مراحل بناء التعلمات (60د)'] is List)
                        ...(details['مراحل بناء التعلمات (60د)'] as List).map((act) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('📌 '),
                                  Expanded(child: Text(act.toString(), style: const TextStyle(fontFamily: 'Amiri', fontSize: 14.5))),
                                ],
                              ),
                            )),
                      if (details['سيرورة الحصة (35د)'] is List)
                        ...(details['سيرورة الحصة (35د)'] as List).map((act) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('📌 '),
                                  Expanded(child: Text(act.toString(), style: const TextStyle(fontFamily: 'Amiri', fontSize: 14.5))),
                                ],
                              ),
                            )),
                      const SizedBox(height: 8),
                      _buildPlanItem('✅ التقويم التكويني والختامي:', details['التقويم التكويني والختامي (20د)']?.toString() ?? details['التطبيق والإنتاج (15د)'].toString()),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPlanItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.indigo)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontFamily: 'Amiri', fontSize: 14.5, color: Colors.black87)),
        ],
      ),
    );
  }

  // ==========================================
  // 6. ملخصات ومطويات سريعة
  // ==========================================
  Widget _buildQuickSummariesTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: PedagogicalHubData.quickSummaries.map((sum) {
        final title = sum['title'] as String;
        final sub = sum['subject'] as String;
        final bullets = sum['bullets'] as List<String>;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 14.5, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Text(sub, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const Divider(height: 16),
                ...bullets.map((b) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.arrow_right, color: Colors.amber, size: 20),
                          Expanded(child: Text(b, style: const TextStyle(fontFamily: 'Amiri', fontSize: 15, height: 1.6, color: Colors.black87))),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ==========================================
  // 7. بنك الأسئلة الشائعة والمتوقعة
  // ==========================================
  Widget _buildQuestionBankTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: PedagogicalHubData.questionBank.map((qb) {
        final q = qb['question'] as String;
        final sub = qb['subject'] as String;
        final stage = qb['stage'] as String;
        final ans = qb['answer'] as String;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 2,
          child: ExpansionTile(
            leading: CircleAvatar(backgroundColor: Colors.teal.shade50, child: const Icon(Icons.question_answer, color: Colors.teal, size: 20)),
            title: Text(q, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13.5, fontWeight: FontWeight.bold)),
            subtitle: Text('$sub | $stage', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.grey)),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                color: Colors.teal.shade50.withAlpha(120),
                child: Text(ans, style: const TextStyle(fontFamily: 'Amiri', fontSize: 15.5, height: 1.7, color: Colors.black87)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ==========================================
  // 8. متفرقات وثقافة عامة
  // ==========================================
  Widget _buildMiscellaneousTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: PedagogicalHubData.miscellaneous.map((misc) {
        final title = misc['title'] as String;
        final cat = misc['category'] as String;
        final content = misc['content'] as String;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(color: Colors.purple.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Text(cat, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                const Divider(height: 16),
                Text(content, style: const TextStyle(fontFamily: 'Amiri', fontSize: 15.5, height: 1.7, color: Colors.black87)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
