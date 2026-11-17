import 'package:i_love_philosophy/models/education_models.dart';

/// مساعد لتصنيف الدروس بدقة حسب السنة الدراسية والميدان ومنع خلط المستويات والشعب
class CurriculumFilterHelper {
  static const List<String> _orderedLevels = [
    'التحضيري',
    '1 ابتدائي',
    '2 ابتدائي',
    '3 ابتدائي',
    '4 ابتدائي',
    '5 ابتدائي',
    '1 متوسط',
    '2 متوسط',
    '3 متوسط',
    '4 متوسط',
    '1 ثانوي',
    '2 ثانوي',
    '3 ثانوي',
  ];

  /// استخراج اسم السنة الدراسية الموحّد للدرس
  static String extractLevel(LessonData lesson) {
    final text = '${lesson.audience} ${lesson.section}';
    if (text.contains('التحضيري') || text.contains('5-6 سنوات')) return 'التحضيري';
    if (text.contains('الأولى ابتدائي') || text.contains('1 ابتدائي')) return '1 ابتدائي';
    if (text.contains('الثانية ابتدائي') || text.contains('2 ابتدائي')) return '2 ابتدائي';
    if (text.contains('الثالثة ابتدائي') || text.contains('3 ابتدائي')) return '3 ابتدائي';
    if (text.contains('الرابعة ابتدائي') || text.contains('4 ابتدائي')) return '4 ابتدائي';
    if (text.contains('الخامسة ابتدائي') || text.contains('5 ابتدائي')) return '5 ابتدائي';
    if (text.contains('الأولى متوسط') || text.contains('1 متوسط')) return '1 متوسط';
    if (text.contains('الثانية متوسط') || text.contains('2 متوسط')) return '2 متوسط';
    if (text.contains('الثالثة متوسط') || text.contains('3 متوسط')) return '3 متوسط';
    if (text.contains('الرابعة متوسط') || text.contains('4 متوسط') || text.contains('BEM')) return '4 متوسط';
    if (text.contains('الأولى ثانوي') || text.contains('1 ثانوي')) return '1 ثانوي';
    if (text.contains('الثانية ثانوي') || text.contains('2 ثانوي')) return '2 ثانوي';
    if (text.contains('الثالثة ثانوي') || text.contains('3 ثانوي') || text.contains('البكالوريا')) return '3 ثانوي';
    return lesson.audience.isNotEmpty ? lesson.audience : 'عام';
  }

  /// استخراج قائمة السنوات المتوفرة داخل برنامج مادة مرتبةً تصاعدياً
  static List<String> extractAvailableLevels(List<LessonData> lessons) {
    final found = <String>{};
    for (final l in lessons) {
      found.add(extractLevel(l));
    }
    final list = found.toList();
    list.sort((a, b) {
      final ia = _orderedLevels.indexOf(a);
      final ib = _orderedLevels.indexOf(b);
      if (ia != -1 && ib != -1) return ia.compareTo(ib);
      if (ia != -1) return -1;
      if (ib != -1) return 1;
      return a.compareTo(b);
    });
    return list;
  }

  /// تصفية الدروس حسب السنة المختارة
  static List<LessonData> filterByLevel(List<LessonData> lessons, String selectedLevel) {
    if (selectedLevel == 'الكل' || selectedLevel.isEmpty) return lessons;
    return lessons.where((l) => extractLevel(l) == selectedLevel).toList();
  }
}
