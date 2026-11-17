import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/middle_data.dart';
import 'package:i_love_philosophy/data/preparatory_data.dart';
import 'package:i_love_philosophy/data/primary_data.dart';
import 'package:i_love_philosophy/data/secondary_data.dart';
import 'package:i_love_philosophy/models/education_models.dart';
import 'package:i_love_philosophy/services/curriculum_sync_service.dart';

/// المستودع المركزي للمناهج والبرامج الجزائرية المخزنة داخلياً في التطبيق
class CurriculumRepository {
  static List<SubjectProgram> get allPrograms => [
        ...PreparatoryData.programs,
        ...PrimaryData.programs,
        ...MiddleData.programs,
        ...SecondaryData.programs,
      ];

  static List<String> get stages => const [
        'الكل',
        'التعليم التحضيري',
        'التعليم الابتدائي',
        'التعليم المتوسط',
        'التعليم الثانوي',
      ];

  static List<SubjectProgram> programsForStage(String stage) {
    if (stage == 'الكل' || stage.trim().isEmpty) return allPrograms;
    return allPrograms.where((p) => p.stage == stage).toList();
  }

  /// إرجاع البرنامج الحقيقي المناسب للمادة والطور/المستوى المطلوب
  static SubjectProgram resolveProgram({
    required String title,
    required String stageName,
    String iconPath = 'assets/icons/book_cover.png',
    Color accentColor = Colors.deepPurple,
  }) {
    final normalizedTitle = title.trim();
    final normalizedStage = stageName.trim();

    // 1. تحديد الطور المستهدف بدقة
    List<SubjectProgram> candidates;
    if (normalizedStage.contains('تحضير')) {
      candidates = PreparatoryData.programs;
    } else if (normalizedStage.contains('ابتدائي') ||
        normalizedStage.contains('أولى ابتدائي') ||
        normalizedStage.contains('ثانية ابتدائي') ||
        normalizedStage.contains('ثالثة ابتدائي') ||
        normalizedStage.contains('رابعة ابتدائي') ||
        normalizedStage.contains('خامسة ابتدائي')) {
      candidates = PrimaryData.programs;
    } else if (normalizedStage.contains('متوسط')) {
      candidates = MiddleData.programs;
    } else if (normalizedStage.contains('ثانوي') ||
        normalizedStage.contains('شعبة') ||
        normalizedStage.contains('آداب') ||
        normalizedStage.contains('علوم') ||
        normalizedStage.contains('رياضي') ||
        normalizedStage.contains('تسيير') ||
        normalizedStage.contains('لغات')) {
      candidates = SecondaryData.programs;
    } else {
      candidates = allPrograms;
    }

    // 2. مطابقة المادة داخل الطور
    final matched = _matchByTitle(candidates, normalizedTitle) ??
        _matchByTitle(allPrograms, normalizedTitle);

    if (matched != null) {
      // إذا كان العنوان أو الطور مخصصاً (مثل سنة محددة أو شعبة محددة)، نُبقي على المحتوى الأصلي مع عنوان السياق الدقيق
      return SubjectProgram(
        id: '${matched.id}_${normalizedTitle.hashCode}',
        title: normalizedTitle,
        stage: matched.stage,
        levelOrStream: normalizedStage.isNotEmpty
            ? normalizedStage
            : matched.levelOrStream,
        iconPath: iconPath.isNotEmpty ? iconPath : matched.iconPath,
        color: accentColor,
        description: matched.description,
        lessons: CurriculumSyncService().mergeLessons(matched.id, matched.lessons),
        quizzes: matched.quizzes,
        libraryItems: matched.libraryItems,
        mediaItems: matched.mediaItems,
      );
    }

    // 3. في حال اختيار بطاقة سنة كاملة أو شعبة كاملة (مثل: السنة الخامسة ابتدائي أو شعبة علوم تجريبية)
    return _buildCompositeStageProgram(
      title: normalizedTitle,
      stageName: normalizedStage,
      iconPath: iconPath,
      accentColor: accentColor,
      sourcePrograms: candidates,
    );
  }

  static SubjectProgram? _matchByTitle(
      List<SubjectProgram> list, String query) {
    final q = query.toLowerCase();
    for (final p in list) {
      if (p.title == query) return p;
    }
    if (q.contains('فلسف')) {
      return SecondaryData.programs.firstWhere((p) => p.id == 'sec_philosophy');
    }
    if (q.contains('عرب') || q.contains('أدب') || q.contains('تعبير') || q.contains('لغوي')) {
      return list.where((p) => p.title.contains('العربية')).firstOrNull;
    }
    if (q.contains('رياضيات') || q.contains('حساب')) {
      return list.where((p) => p.title.contains('الرياضيات')).firstOrNull;
    }
    if (q.contains('فيزياء') || q.contains('فيزيائ')) {
      return list.where((p) => p.title.contains('الفيزيائ') || p.title.contains('العلمية')).firstOrNull;
    }
    if (q.contains('طبيع') || q.contains('حياة') || q.contains('علمي') || q.contains('علمية')) {
      return list
          .where((p) =>
              p.title.contains('الطبيعة') ||
              p.title.contains('العلمية') ||
              p.title.contains('العلمي'))
          .firstOrNull;
    }
    if (q.contains('تاريخ') || q.contains('جغرافيا')) {
      return list.where((p) => p.title.contains('التاريخ')).firstOrNull;
    }
    if (q.contains('إسلامي') || q.contains('شريعة')) {
      return list.where((p) => p.title.contains('الإسلامية')).firstOrNull;
    }
    if (q.contains('مدني')) {
      return list.where((p) => p.title.contains('المدنية') || p.title.contains('التاريخ')).firstOrNull;
    }
    if (q.contains('إنجليز') || q.contains('انجليز')) {
      return list.where((p) => p.title.contains('الإنجليزية') || p.title.contains('اللغات')).firstOrNull;
    }
    if (q.contains('فرنس')) {
      return list.where((p) => p.title.contains('الفرنسية') || p.title.contains('اللغات')).firstOrNull;
    }
    if (q.contains('ألماني') ||
        q.contains('إسباني') ||
        q.contains('إيطالي') ||
        q.contains('أمازيغي')) {
      return SecondaryData.programs
          .where((p) => p.id == 'sec_third_languages')
          .firstOrNull;
    }
    if (q.contains('تسيير') ||
        q.contains('محاسب') ||
        q.contains('اقتصاد') ||
        q.contains('قانون')) {
      return SecondaryData.programs.where((p) => p.id == 'sec_gestion').firstOrNull;
    }
    if (q.contains('هندسة') ||
        q.contains('تكنولوجيا') ||
        q.contains('طرائق') ||
        q.contains('ميكانيك') ||
        q.contains('كهربائ') ||
        q.contains('مدنية')) {
      return SecondaryData.programs.where((p) => p.id == 'sec_tech_eng').firstOrNull;
    }
    if (q.contains('إعلام') || q.contains('معلومات')) {
      return MiddleData.programs
          .where((p) => p.id == 'mid_islamic_civic_info')
          .firstOrNull;
    }
    if (q.contains('رسم') ||
        q.contains('تشكيل') ||
        q.contains('موسيق') ||
        q.contains('بدني') ||
        q.contains('رياضة') ||
        q.contains('فنون')) {
      return PreparatoryData.programs.where((p) => p.id == 'prep_art').firstOrNull;
    }
    return null;
  }

  static SubjectProgram _buildCompositeStageProgram({
    required String title,
    required String stageName,
    required String iconPath,
    required Color accentColor,
    required List<SubjectProgram> sourcePrograms,
  }) {
    final lessons = <LessonData>[];
    final quizzes = <QuizTopicData>[];
    final library = <LibraryItemData>[];
    final media = <MediaItemData>[];

    for (final p in sourcePrograms.take(5)) {
      lessons.addAll(p.lessons);
      quizzes.addAll(p.quizzes);
      library.addAll(p.libraryItems);
      media.addAll(p.mediaItems);
    }

    return SubjectProgram(
      id: 'composite_${title.hashCode}',
      title: title,
      stage: stageName,
      levelOrStream: title,
      iconPath: iconPath,
      color: accentColor,
      description: 'البرنامج الشامل لمواد $title وفق المنهاج الرسمي الجزائري.',
      lessons: lessons,
      quizzes: quizzes,
      libraryItems: library,
      mediaItems: media,
    );
  }
}
