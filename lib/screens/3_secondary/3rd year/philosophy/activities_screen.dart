import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/secondary_data.dart';
import 'package:i_love_philosophy/models/education_models.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/screens/outils/study_progress_service.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';
import 'package:i_love_philosophy/widgets/program_filter_bar.dart';
import 'package:i_love_philosophy/utils/responsive_ui.dart';

class ActivitiesScreen extends StatefulWidget {
  final SubjectProgram? program;

  const ActivitiesScreen({super.key, this.program});

  @override
  State<ActivitiesScreen> createState() => ActivitiesScreenState();
}

class ActivitiesScreenState extends State<ActivitiesScreen> {
  final StudyProgressService _progressService = StudyProgressService();
  late SubjectProgram _activeProgram;

  @override
  void initState() {
    super.initState();
    _activeProgram = widget.program ?? SecondaryData.programs.first;
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
    final quizzes = _activeProgram.quizzes;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(
            '📝 اختبارات: ${_activeProgram.title}',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: screenWidth * 0.044,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
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
          child: Column(
            children: [
              ProgramFilterBar(
                selectedProgram: _activeProgram,
                onProgramChanged: (prog) {
                  setState(() {
                    _activeProgram = prog;
                  });
                },
              ),
              Expanded(
                child: quizzes.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد اختبارات متوفرة لهذه المادة حالياً.',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(14),
                        itemCount: quizzes.length,
                        itemBuilder: (context, index) {
                          final quiz = quizzes[index];
                          final quizKey = '${_activeProgram.id}: ${quiz.title}';
                          final best = _progressService.quizBestScores[quizKey];
                          final total = _progressService.quizTotals[quizKey] ??
                              quiz.questions.length;

                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(14),
                              leading: CircleAvatar(
                                radius: 26,
                                backgroundColor:
                                    _activeProgram.color.withAlpha(35),
                                child: Icon(
                                  Icons.quiz_rounded,
                                  color: _activeProgram.color,
                                  size: 28,
                                ),
                              ),
                              title: Text(
                                quiz.title,
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  '${quiz.section} • ${quiz.questions.length} أسئلة'
                                  '${best != null ? '\nأفضل نتيجة: $best / $total ✅' : ''}',
                                  style: const TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => QuizRunnerScreen(
                                        quizKey: quizKey,
                                        quiz: quiz,
                                        accentColor: _activeProgram.color,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'ابدأ',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 2,
          currentProgram: _activeProgram,
        ),
      ),
    );
  }
}

class QuizRunnerScreen extends StatefulWidget {
  final String quizKey;
  final QuizTopicData quiz;
  final Color accentColor;

  const QuizRunnerScreen({
    super.key,
    required this.quizKey,
    required this.quiz,
    required this.accentColor,
  });

  @override
  State<QuizRunnerScreen> createState() => _QuizRunnerScreenState();
}

class _QuizRunnerScreenState extends State<QuizRunnerScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOption;
  bool _answered = false;

  void _selectOption(int index) {
    if (_answered) return;
    final currentQ = widget.quiz.questions[_currentIndex];
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (index == currentQ.correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex + 1 < widget.quiz.questions.length) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
      });
    } else {
      StudyProgressService().saveQuizScore(
        widget.quizKey,
        _score,
        widget.quiz.questions.length,
      );
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.quiz.questions;
    final isFinished = _currentIndex >= questions.length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.quiz.title,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
          ),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_background2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: isFinished
              ? Center(
                  child: Card(
                    margin: const EdgeInsets.all(24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.emoji_events,
                              size: 64, color: Colors.amber),
                          const SizedBox(height: 12),
                          Text(
                            'نتيجتك النهائية: $_score / ${questions.length}',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _score == questions.length
                                ? 'ممتاز! إتقان كامل للمحور 🌟'
                                : 'أحسنت! واصل المراجعة لتحقيق العلامة الكاملة.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _currentIndex = 0;
                                _score = 0;
                                _selectedOption = null;
                                _answered = false;
                              });
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text(
                              'إعادة الاختبار',
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LinearProgressIndicator(
                        value: (_currentIndex + 1) / questions.length,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.deepPurple,
                        backgroundColor: Colors.white70,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'السؤال ${_currentIndex + 1} من ${questions.length}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            questions[_currentIndex].question,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      ...List.generate(
                        questions[_currentIndex].options.length,
                        (optIdx) {
                          final q = questions[_currentIndex];
                          Color bg = Colors.white;
                          Color border = Colors.grey.shade300;
                          if (_answered) {
                            if (optIdx == q.correctIndex) {
                              bg = Colors.green.shade50;
                              border = Colors.green;
                            } else if (optIdx == _selectedOption) {
                              bg = Colors.red.shade50;
                              border = Colors.red;
                            }
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              onTap: () => _selectOption(optIdx),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: border, width: 1.5),
                                ),
                                child: Text(
                                  q.options[optIdx],
                                  style: const TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (_answered) ...[
                        if (questions[_currentIndex].explanation.isNotEmpty)
                          Card(
                            color: Colors.amber.shade50,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                'التوضيح: ${questions[_currentIndex].explanation}',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            _currentIndex + 1 < questions.length
                                ? 'السؤال التالي'
                                : 'عرض النتيجة',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
