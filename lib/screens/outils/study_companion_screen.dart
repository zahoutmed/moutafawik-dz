import 'dart:async';
import 'package:flutter/material.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/screens/outils/study_progress_service.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';

class StudyCompanionScreen extends StatefulWidget {
  final int initialTab;
  const StudyCompanionScreen({super.key, this.initialTab = 0});

  @override
  State<StudyCompanionScreen> createState() => _StudyCompanionScreenState();
}

class _StudyCompanionScreenState extends State<StudyCompanionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StudyProgressService _progressService = StudyProgressService();
  final TextEditingController _noteController = TextEditingController();

  // المؤقت الدراسي (Pomodoro)
  static const int _focusDuration = 25 * 60;
  int _remainingSeconds = _focusDuration;
  bool _isTimerRunning = false;
  Timer? _pomodoroTimer;

  // منهجيات المقال الفلسفي
  final List<Map<String, dynamic>> _methodologies = [
    {
      'title': '1. المنهجية الجدلية (المقابلة بين موقفين)',
      'subtitle':
          'تُستخدم عندما يدور السؤال حول قضية خلافية تحتمل رأيين متعارضين (هل...؟)',
      'color': Colors.indigo,
      'steps': [
        'طرح المشكلة (المقدمة): تمهيد وظيفي + إبراز العناد الفلسفي + صياغة السؤال بدقة.',
        'محاولة حل المشكلة - الأطروحة الأولى: عرض المسلمات والحجج والأمثلة وأقوال الفلاسفة + النقد (المناقشة).',
        'نقيض الأطروحة (الموقف الثاني): عرض الموقف المعارض وحججه وأقوال الفلاسفة + النقد.',
        'التركيب (التجاوز/التوفيق): الجمع بين الموقفين أو تغليب أحدهما أو تجاوزهما لموقف أرقى.',
        'حل المشكلة (الخاتمة): استنتاج عام ومنطقي يجيب مباشرة عن الإشكالية المطروحة.',
      ],
    },
    {
      'title': '2. منهجية الاستقصاء بالوضع (الدفاع عن أطروحة)',
      'subtitle':
          'تُستخدم عندما يُطلب منك إثبات صحة مقولة تبدو غير مألوفة (دافع عن الأطروحة القائلة...)',
      'color': Colors.teal,
      'steps': [
        'طرح المشكلة: تمهيد عام + عرض الفكرة الشائعة (النقيض) + عرض الفكرة المراد الدفاع عنها + طرح التساؤل: كيف يمكن إثبات صحة هذه الأطروحة؟',
        'عرض منطق الأطروحة: شرح موقفها وضبط مسلماتها وحججها.',
        'عرض منطق الخصوم ونقدهم: ذكر حجج المعارضين ثم إبطالها وتفنيدها لإضعاف موقفهم.',
        'الدفاع عن الأطروحة بحجج شخصية: تدعيم الأطروحة بأدلة جديدة وأمثلة واقعية ومذاهب فلسفية مؤيدة.',
        'حل المشكلة: التأكيد القطعي بأن الأطروحة صحيحة ومشروعة وقابلة للدفاع عنها.',
      ],
    },
    {
      'title': '3. منهجية المقارنة (التمييز والعلاقة)',
      'subtitle':
          'تُستخدم عند السؤال عن العلاقة بين مفهومين متداخلين (قارن بين العلم والفلسفة، الإحساس والإدراك...)',
      'color': Colors.deepOrange,
      'steps': [
        'طرح المشكلة: تمهيد + الحذر من المظاهر الخادعة للتشابه أو الاختلاف + طرح سؤال المقارنة.',
        'أوجه الاختلاف: إبراز الفوارق في التعريف والطبيعة والمنهج والغاية.',
        'أوجه التشابه: إبراز النقاط المشتركة والخصائص المتقاربة بين المفهومين.',
        'أوجه التداخل (طبيعة العلاقة): بيان علاقة التكامل الوظيفي أو الاتصال بينهما.',
        'حل المشكلة: استخلاص طبيعة العلاقة النهائية التي تربط المفهومين.',
      ],
    },
    {
      'title': '4. منهجية تحليل نص فلسفي',
      'subtitle': 'تُستخدم لتحليل نص لفيلسوف واستخراج إشكاليته وموقفه وحججه',
      'color': Colors.purple,
      'steps': [
        'طرح المشكلة: التعريف بصاحب النص + الإطار الفلسفي للنص + الدافع لكتابته + طرح الإشكالية.',
        'موقف صاحب النص: تحديد رأي الفيلسوف مضموناً وشكلاً (العبارات الدالة من النص).',
        'الحجج والبراهين: استخراج الحجج العقلية والواقعية والمنطقية التي اعتمدها صاحب النص.',
        'النقد والتقييم: بيان قيمة النص ومكاسب الفيلسوف ثم حدود موقفه مع إبداء الرأي الشخصي المعلل.',
        'حل المشكلة: خلاصة موجزة تجيب عن الإشكالية التي عالجها النص.',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: widget.initialTab);
    _progressService.addListener(_onProgressUpdated);
  }

  void _onProgressUpdated() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _pomodoroTimer?.cancel();
    _progressService.removeListener(_onProgressUpdated);
    _tabController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isTimerRunning) {
      _pomodoroTimer?.cancel();
      setState(() {
        _isTimerRunning = false;
      });
    } else {
      setState(() {
        _isTimerRunning = true;
      });
      _pomodoroTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          timer.cancel();
          setState(() {
            _isTimerRunning = false;
            _remainingSeconds = _focusDuration;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    '🎉 أحسنت! أتممت جلسة تركيز كاملة (25 دقيقة). خذ استراحة 5 دقائق!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      });
    }
  }

  void _resetTimer() {
    _pomodoroTimer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _remainingSeconds = _focusDuration;
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          title: Text(
            '🎓 رفيق التفوق والمنهجية',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: screenWidth * 0.048,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.amberAccent,
            labelColor: Colors.amberAccent,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(
                fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(icon: Icon(Icons.architecture), text: 'المنهجية'),
              Tab(icon: Icon(Icons.edit_note), text: 'مذكرتي'),
              Tab(icon: Icon(Icons.timer), text: 'المؤقت'),
              Tab(icon: Icon(Icons.emoji_events), text: 'إنجازاتي'),
            ],
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
              _buildMethodologyTab(screenWidth),
              _buildNotesTab(screenWidth),
              _buildPomodoroTab(screenWidth),
              _buildAchievementsTab(screenWidth),
            ],
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildMethodologyTab(double screenWidth) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _methodologies.length,
      itemBuilder: (context, index) {
        final item = _methodologies[index];
        final Color cardColor = item['color'] as Color;
        final List<String> steps = item['steps'] as List<String>;

        return Card(
          elevation: 6,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ExpansionTile(
            initiallyExpanded: index == 0,
            leading: CircleAvatar(
              backgroundColor: cardColor,
              child: const Icon(Icons.menu_book, color: Colors.white),
            ),
            title: Text(
              item['title'] as String,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: screenWidth * 0.042,
                fontWeight: FontWeight.bold,
                color: cardColor,
              ),
            ),
            subtitle: Text(
              item['subtitle'] as String,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: screenWidth * 0.038,
                color: Colors.black87,
              ),
            ),
            children: steps
                .map(
                  (step) => ListTile(
                    leading: Icon(Icons.check_circle_outline, color: cardColor),
                    title: Text(
                      step,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: screenWidth * 0.036,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildNotesTab(double screenWidth) {
    final notes = _progressService.personalNotes;
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '✍️ أضف مقولة فلسفية أو ملخصاً أو فكرة مهمة:',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          'مثال: ديكارت: "أنا أفكر إذن أنا موجود" - الحجة العقلية في الإدراك...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_noteController.text.trim().isNotEmpty) {
                        await _progressService.addNote(_noteController.text);
                        _noteController.clear();
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'حفظ في مذكرتي',
                      style: TextStyle(
                          fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: notes.isEmpty
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'لا توجد ملاحظات محفوظة بعد.\nابدأ بتدوين أهم الأقوال الفلسفية والملخصات هنا!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.amber,
                            child: Icon(Icons.lightbulb, color: Colors.black87),
                          ),
                          title: Text(
                            notes[index],
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () =>
                                _progressService.removeNoteAt(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPomodoroTab(double screenWidth) {
    final double progress = _remainingSeconds / _focusDuration;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.white.withAlpha(235),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '⏱️ مؤقت المراجعة المركزة (Pomodoro)',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: screenWidth * 0.048,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'ادرس بتركيز تام لمدة 25 دقيقة ثم خذ استراحة 5 دقائق لتنشيط الذاكرة',
                  style: TextStyle(fontFamily: 'Amiri', fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _isTimerRunning ? Colors.teal : Colors.deepPurple,
                        ),
                      ),
                    ),
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _toggleTimer,
                      icon: Icon(
                          _isTimerRunning ? Icons.pause : Icons.play_arrow),
                      label: Text(
                        _isTimerRunning ? 'إيقاف مؤقت' : 'ابدأ التركيز',
                        style: const TextStyle(
                            fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isTimerRunning ? Colors.orange : Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: _resetTimer,
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        'إعادة ضبط',
                        style: TextStyle(
                            fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementsTab(double screenWidth) {
    final bookmarks = _progressService.bookmarks.toList();
    final completed = _progressService.completedLessons.toList();
    final scores = _progressService.quizBestScores;
    final totals = _progressService.quizTotals;

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Card(
          color: Colors.deepPurple,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatBadge(
                    Icons.check_circle, '${completed.length}', 'دروس مكتملة'),
                _buildStatBadge(
                    Icons.bookmark, '${bookmarks.length}', 'في المفضلة'),
                _buildStatBadge(
                    Icons.quiz, '${scores.length}', 'اختبارات منجزة'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🏆 نتائج الاختبارات التفاعلية:',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const Divider(),
                if (scores.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'لم تقم بإجراء أي اختبار بعد. انتقل إلى قسم الأنشطة واختبر معلوماتك!',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                    ),
                  )
                else
                  ...scores.entries.map((entry) {
                    final total = totals[entry.key] ?? 1;
                    final pct = ((entry.value / total) * 100).round();
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            pct >= 50 ? Colors.green : Colors.orange,
                        child: Text(
                          '$pct%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        entry.key,
                        style: const TextStyle(
                            fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '${entry.value} / $total',
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🔖 الدروس والكتب المحفوظة في المفضلة:',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const Divider(),
                if (bookmarks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'اضغط على أيقونة الحفظ (🔖) داخل أي درس لإضافته إلى مفضلتك السريعة.',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                    ),
                  )
                else
                  ...bookmarks.map(
                    (b) => ListTile(
                      leading: const Icon(Icons.bookmark, color: Colors.amber),
                      title: Text(
                        b,
                        style: const TextStyle(
                            fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _progressService.toggleBookmark(b),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatBadge(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.amberAccent, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
