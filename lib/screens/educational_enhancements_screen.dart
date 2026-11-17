import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:i_love_philosophy/data/educational_enhancements_data.dart';
import 'package:i_love_philosophy/screens/shared/official_exams_screen.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';

class EducationalEnhancementsScreen extends StatefulWidget {
  final int initialTab;

  const EducationalEnhancementsScreen({super.key, this.initialTab = 0});

  @override
  State<EducationalEnhancementsScreen> createState() =>
      _EducationalEnhancementsScreenState();
}

class _EducationalEnhancementsScreenState
    extends State<EducationalEnhancementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Timer? _liveCountdownTimer;

  // حالة بطاقات التكرار المتباعد
  int _currentCardIndex = 0;
  bool _isFlipped = false;
  bool _showExplanation = false;
  String _selectedStage = 'الكل';
  String _selectedSubject = 'الكل';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );

    // مؤقت حي لتحديث الثواني والدقائق والساعات للعد التنازلي لحظياً
    _liveCountdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });

    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedStage = prefs.getString('user_stage') ?? prefs.getString('saved_stage');
      if (savedStage != null && savedStage.isNotEmpty) {
        if (mounted) {
          setState(() {
            _selectedStage = savedStage;
          });
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _liveCountdownTimer?.cancel();
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
            '🌟 ملحق التفوق، العد التنازلي والبطاقات',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.amberAccent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 12.5,
            ),
            tabs: const [
              Tab(icon: Icon(Icons.timer_outlined), text: 'العد التنازلي الحي'),
              Tab(icon: Icon(Icons.style_outlined), text: 'بطاقات التكرار'),
              Tab(icon: Icon(Icons.psychology_outlined), text: 'التوجيه المنهجي'),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_background2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCountdownTab(),
                _buildFlashcardsTab(),
                _buildPedagogicalAssistantTab(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      ),
    );
  }

  // ==========================================
  // تبويب 1: العد التنازلي التفاعلي الحي
  // ==========================================
  Widget _buildCountdownTab() {
    final exams = EducationalEnhancementsData.upcomingExams;

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // بانر الانتقال السريع لبنك الامتحانات الرسمية
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OfficialExamsScreen()),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.workspace_premium, color: Colors.amberAccent, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'بنك مواضيع البكالوريا والبيام الرسمية مع الحلول',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'تصفح نصوص الامتحانات وسلم التنقيط المعتمد من وزارة التربية',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // بطاقات الامتحانات المتبقية مع العد التنازلي الحي
        ...exams.map((exam) {
          final remaining = exam.remaining;
          final days = remaining.inDays;
          final hours = remaining.inHours % 24;
          final minutes = remaining.inMinutes % 60;
          final seconds = remaining.inSeconds % 60;
          final nextDate = exam.nextDate;

          return Card(
            elevation: 5,
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            color: Colors.white.withAlpha(245),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: exam.color.withAlpha(35),
                        child: Icon(exam.icon, color: exam.color, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exam.name,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 15.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              exam.stage,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11.5,
                                color: exam.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: exam.color.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: exam.color.withAlpha(60)),
                        ),
                        child: Text(
                          '${nextDate.day}/${nextDate.month}/${nextDate.year}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: exam.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 22),
                  // عدادات الوقت الأربعة (أيام، ساعات، دقائق، ثوانٍ)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTimeBadge('$days', 'يوم', Colors.deepPurple),
                      _buildTimeBadge('$hours', 'ساعة', Colors.teal),
                      _buildTimeBadge('$minutes', 'دقيقة', Colors.indigo),
                      _buildTimeBadge('$seconds', 'ثانية', Colors.deepOrange),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.tips_and_updates, size: 18, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'نصيحة المنهاج: تخصيص 45 دقيقة يومياً لحل التمارين الرسمية يضمن تثبيت المفاهيم وبلوغ التفوق.',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11.5,
                              color: Colors.brown.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTimeBadge(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 58,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(80)),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // تبويب 2: بطاقات التكرار المتباعد التكيفية
  // ==========================================
  Widget _buildFlashcardsTab() {
    final allCards = EducationalEnhancementsData.flashcards;

    // استخراج الأطوار والمواد
    final stages = ['الكل', 'التعليم الثانوي', 'التعليم المتوسط', 'التعليم الابتدائي'];
    final subjects = ['الكل', ...allCards.map((c) => c.subject).toSet()];

    final cards = allCards.where((c) {
      final matchesStage = _selectedStage == 'الكل' || c.stage.contains(_selectedStage) || _selectedStage.contains(c.stage);
      final matchesSubject = _selectedSubject == 'الكل' || c.subject == _selectedSubject;
      return matchesStage && matchesSubject;
    }).toList();

    if (_currentCardIndex >= cards.length) {
      _currentCardIndex = 0;
    }

    if (cards.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(230),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.filter_alt_off, size: 40, color: Colors.grey),
              const SizedBox(height: 10),
              const Text('لا توجد بطاقات للمستوى أو المادة المحددة.', style: TextStyle(fontFamily: 'Cairo', fontSize: 13.5)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => setState(() {
                  _selectedStage = 'الكل';
                  _selectedSubject = 'الكل';
                }),
                child: const Text('عرض جميع البطاقات', style: TextStyle(fontFamily: 'Cairo', fontSize: 12)),
              ),
            ],
          ),
        ),
      );
    }

    final card = cards[_currentCardIndex];

    return Column(
      children: [
        // شريط الفلاتر المزدوج (الطور + المادة)
        Container(
          color: Colors.white.withAlpha(240),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              // اختيار الطور
              Row(
                children: [
                  const Text('الطور:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: stages.map((st) {
                          final isSel = _selectedStage == st;
                          return Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: ChoiceChip(
                              label: Text(st, style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isSel ? Colors.white : Colors.black87)),
                              selected: isSel,
                              selectedColor: Colors.deepPurple,
                              backgroundColor: Colors.grey.shade200,
                              onSelected: (_) => setState(() {
                                _selectedStage = st;
                                _currentCardIndex = 0;
                                _isFlipped = false;
                                _showExplanation = false;
                              }),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // اختيار المادة
              Row(
                children: [
                  const Text('المادة:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: subjects.map((sub) {
                          final isSel = _selectedSubject == sub;
                          return Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: ChoiceChip(
                              label: Text(sub, style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: isSel ? Colors.white : Colors.black87)),
                              selected: isSel,
                              selectedColor: Colors.teal,
                              backgroundColor: Colors.grey.shade200,
                              onSelected: (_) => setState(() {
                                _selectedSubject = sub;
                                _currentCardIndex = 0;
                                _isFlipped = false;
                                _showExplanation = false;
                              }),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // رأس البطاقة (الرقم والحالة)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'البطاقة ${_currentCardIndex + 1} من ${cards.length}',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.deepPurple,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.touch_app, size: 16, color: Colors.black54),
                  const SizedBox(width: 4),
                  Text(
                    _isFlipped ? 'الإجابة والحل 💡' : 'المفهوم / السؤال (المس للقلب)',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11.5,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // البطاقة التفاعلية القابلة للقلب
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isFlipped = !_isFlipped;
                });
              },
              borderRadius: BorderRadius.circular(22),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _isFlipped ? Colors.indigo.shade50 : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: _isFlipped ? Colors.indigo : Colors.deepPurple.shade300,
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // شارة التصنيف
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isFlipped ? Colors.indigo : Colors.deepPurple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            card.category,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '${card.stage} • ${card.subject}',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    // محتوى السؤال أو الإجابة
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isFlipped ? card.back : card.front,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: _isFlipped ? 18 : 20,
                                  fontWeight: _isFlipped ? FontWeight.normal : FontWeight.bold,
                                  height: 1.6,
                                  color: Colors.black87,
                                ),
                              ),
                              if (!_isFlipped && card.hint.isNotEmpty) ...[
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.amber.shade200),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.lightbulb_outline, size: 16, color: Colors.amber),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          'تلميح: ${card.hint}',
                                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: Colors.brown),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              if (_isFlipped && card.explanation.isNotEmpty && _showExplanation) ...[
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.teal.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.menu_book, color: Colors.teal, size: 16),
                                          SizedBox(width: 6),
                                          Text('الشرح البيداغوجي الموسع:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal)),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        card.explanation,
                                        style: const TextStyle(fontFamily: 'Amiri', fontSize: 14.5, height: 1.6, color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (_isFlipped && card.explanation.isNotEmpty)
                      TextButton.icon(
                        icon: Icon(_showExplanation ? Icons.visibility_off : Icons.visibility, size: 16),
                        label: Text(_showExplanation ? 'إخفاء الشرح' : 'عرض الشرح والتحليل المنهجي', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5)),
                        onPressed: () => setState(() => _showExplanation = !_showExplanation),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // أزرار تقييم الحفظ والتنقل (Spaced Repetition Mastery)
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              if (_isFlipped) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.sentiment_dissatisfied, size: 16),
                        label: const Text('صعبة (أعدها)'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600, foregroundColor: Colors.white),
                        onPressed: () => _nextCard(cards.length),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.sentiment_neutral, size: 16),
                        label: const Text('متوسطة'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700, foregroundColor: Colors.white),
                        onPressed: () => _nextCard(cards.length),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.sentiment_very_satisfied, size: 16),
                        label: const Text('أتقنتها'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, foregroundColor: Colors.white),
                        onPressed: () => _nextCard(cards.length),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back_ios, size: 14),
                    label: const Text('السابقة'),
                    onPressed: _currentCardIndex > 0 ? () => setState(() {
                      _currentCardIndex--;
                      _isFlipped = false;
                      _showExplanation = false;
                    }) : null,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.flip, size: 16),
                    label: Text(_isFlipped ? 'إخفاء الإجابة' : 'إظهار الحل'),
                    onPressed: () => setState(() => _isFlipped = !_isFlipped),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward_ios, size: 14),
                    label: const Text('التالية'),
                    onPressed: _currentCardIndex < cards.length - 1 ? () => _nextCard(cards.length) : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _nextCard(int total) {
    if (_currentCardIndex < total - 1) {
      setState(() {
        _currentCardIndex++;
        _isFlipped = false;
        _showExplanation = false;
      });
    }
  }

  // ==========================================
  // تبويب 3: التوجيه المنهجي البيداغوجي
  // ==========================================
  Widget _buildPedagogicalAssistantTab() {
    final tips = [
      {
        'title': '1. استراتيجية تقنية بومودورو الفعالة في الامتحانات',
        'desc': 'المذاكرة المركزة لمدة 25 دقيقة متبوعة بـ 5 دقائق راحة تزيد التركيز الذهني بنسبة 40% وتمنع التشتت والملل.',
        'color': Colors.deepOrange,
        'icon': Icons.timer,
      },
      {
        'title': '2. منهجية التعامل مع موضوع الامتحان (BAC & BEM)',
        'desc': 'قراءة الموضوعين بتمعن لمدة 15 دقيقة، اختيار الموضوع الأنسب بوضع إشارات على الأسئلة المضمونة، والبدء بالمسودة لتنظيم الأفكار.',
        'color': Colors.indigo,
        'icon': Icons.menu_book,
      },
      {
        'title': '3. منهجية صياغة المقال الفلسفي والأدبي',
        'desc': 'الالتزام الصارم بالخطوات (المقدمة الوظيفية، الأطروحة ونقدها، نقيض الأطروحة ونقده، التركيب والتجاوز، والخاتمة الاستنتاجية).',
        'color': Colors.deepPurple,
        'icon': Icons.edit_note,
      },
      {
        'title': '4. حل المسائل الرياضية والفيزيائية',
        'desc': 'استخراج المعطيات والوحدات بدقة (التحويل إلى النظام الدولي SI)، كتابة القانون الحرفي أولاً قبل التطبيق العددي، والتأكد من منطقية النتيجة.',
        'color': Colors.teal,
        'icon': Icons.calculate,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: tips.length,
      itemBuilder: (context, index) {
        final tip = tips[index];
        final color = tip['color'] as Color;

        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: color.withAlpha(30),
                  child: Icon(tip['icon'] as IconData, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['title'] as String,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        tip['desc'] as String,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 14.5,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
