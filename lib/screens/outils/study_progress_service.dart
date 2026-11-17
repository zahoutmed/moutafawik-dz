import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudyProgressService extends ChangeNotifier {
  static final StudyProgressService _instance =
      StudyProgressService._internal();
  factory StudyProgressService() => _instance;
  StudyProgressService._internal() {
    _loadData();
  }

  Set<String> _bookmarks = {};
  Set<String> _completedLessons = {};
  final Map<String, int> _quizBestScores = {};
  final Map<String, int> _quizTotals = {};
  List<String> _personalNotes = [];

  Set<String> get bookmarks => _bookmarks;
  Set<String> get completedLessons => _completedLessons;
  Map<String, int> get quizBestScores => _quizBestScores;
  Map<String, int> get quizTotals => _quizTotals;
  List<String> get personalNotes => _personalNotes;

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _bookmarks = (prefs.getStringList('study_bookmarks') ?? []).toSet();
    _completedLessons = (prefs.getStringList('study_completed') ?? []).toSet();
    _personalNotes = prefs.getStringList('study_notes') ?? [];

    final quizKeys = prefs.getStringList('study_quiz_keys') ?? [];
    for (final k in quizKeys) {
      _quizBestScores[k] = prefs.getInt('quiz_score_$k') ?? 0;
      _quizTotals[k] = prefs.getInt('quiz_total_$k') ?? 1;
    }
    notifyListeners();
  }

  bool isBookmarked(String title) => _bookmarks.contains(title);

  Future<void> toggleBookmark(String title) async {
    final prefs = await SharedPreferences.getInstance();
    if (_bookmarks.contains(title)) {
      _bookmarks.remove(title);
    } else {
      _bookmarks.add(title);
    }
    await prefs.setStringList('study_bookmarks', _bookmarks.toList());
    notifyListeners();
  }

  bool isLessonCompleted(String title) => _completedLessons.contains(title);

  Future<void> toggleLessonCompleted(String title) async {
    final prefs = await SharedPreferences.getInstance();
    if (_completedLessons.contains(title)) {
      _completedLessons.remove(title);
    } else {
      _completedLessons.add(title);
    }
    await prefs.setStringList('study_completed', _completedLessons.toList());
    notifyListeners();
  }

  Future<void> saveQuizScore(String quizTitle, int score, int total) async {
    final prefs = await SharedPreferences.getInstance();
    final prev = _quizBestScores[quizTitle] ?? 0;
    if (score >= prev) {
      _quizBestScores[quizTitle] = score;
      _quizTotals[quizTitle] = total;
      await prefs.setInt('quiz_score_$quizTitle', score);
      await prefs.setInt('quiz_total_$quizTitle', total);
      await prefs.setStringList(
          'study_quiz_keys', _quizBestScores.keys.toList());
      notifyListeners();
    }
  }

  Future<void> addNote(String note) async {
    if (note.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _personalNotes.insert(0, note.trim());
    await prefs.setStringList('study_notes', _personalNotes);
    notifyListeners();
  }

  Future<void> removeNoteAt(int index) async {
    if (index < 0 || index >= _personalNotes.length) return;
    final prefs = await SharedPreferences.getInstance();
    _personalNotes.removeAt(index);
    await prefs.setStringList('study_notes', _personalNotes);
    notifyListeners();
  }
}
