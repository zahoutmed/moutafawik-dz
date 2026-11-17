import 'package:flutter/material.dart';

/// فقرة أو محور فرعي مفصل داخل الدرس
class LessonSection {
  final String title;
  final String content;
  final List<String> bulletPoints;

  const LessonSection({
    required this.title,
    required this.content,
    this.bulletPoints = const [],
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'content': content,
        'bulletPoints': bulletPoints,
      };
}

/// نموذج درس أو وحدة تعليمية وفق المنهاج الرسمي الجزائري
class LessonData {
  final String section;
  final String title;
  final String summary;
  final List<String> keyPoints;
  final String duration;
  final String audience;
  final String image;
  final String? pdfFile;
  final String fullExplanation;
  final List<LessonSection> detailedSections;
  final List<String> examples;
  final String mindMapSummary;
  final List<String> reviewQuestions;

  const LessonData({
    required this.section,
    required this.title,
    required this.summary,
    required this.keyPoints,
    this.duration = 'الوقت: 30د',
    this.audience = '',
    this.image = 'assets/images/lesson1.jpg',
    this.pdfFile,
    this.fullExplanation = '',
    this.detailedSections = const [],
    this.examples = const [],
    this.mindMapSummary = '',
    this.reviewQuestions = const [],
  });

  Map<String, dynamic> toMap() => {
        'section': section,
        'title': title,
        'desc': summary,
        'keyPoints': keyPoints,
        'duration': duration,
        'audience': audience,
        'image': image,
        if (pdfFile != null) 'pdfFile': pdfFile,
        'fullExplanation': fullExplanation,
        'detailedSections': detailedSections.map((s) => s.toMap()).toList(),
        'examples': examples,
        'mindMapSummary': mindMapSummary,
        'reviewQuestions': reviewQuestions,
      };
}

/// نموذج سؤال اختبار تفاعلي مع التصحيح والشرح
class QuizQuestionData {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestionData({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation = '',
  });
}

/// نموذج موضوع اختبار لوحدة أو محور دراسي
class QuizTopicData {
  final String section;
  final String title;
  final String image;
  final List<QuizQuestionData> questions;

  const QuizTopicData({
    required this.section,
    required this.title,
    this.image = 'assets/images/exam.jpg',
    required this.questions,
  });
}

/// نموذج مرجع أو كتاب أو ملخص في المكتبة الداخلية أو عبر رابط رسمي/PDF
class LibraryItemData {
  final String section;
  final String title;
  final String author;
  final String summary;
  final String fullContent;
  final List<String> tags;
  final String image;
  final String? pdfPath;
  final String? url;

  const LibraryItemData({
    required this.section,
    required this.title,
    required this.author,
    required this.summary,
    required this.fullContent,
    this.tags = const [],
    this.image = 'assets/images/book_cover.png',
    this.pdfPath,
    this.url,
  });
}

/// نموذج مادة ميلتيميديا وشرح مرئي/تفاعلي (محلي أو عبر رابط تعليمي)
class MediaItemData {
  final String section;
  final String title;
  final String presenter;
  final String duration;
  final String summary;
  final List<String> steps;
  final String image;
  final String? localVideoAsset;
  final String? videoUrl;

  const MediaItemData({
    required this.section,
    required this.title,
    required this.presenter,
    this.duration = '15 دقيقة',
    required this.summary,
    required this.steps,
    this.image = 'assets/images/video_list.jpg',
    this.localVideoAsset,
    this.videoUrl,
  });
}

/// نموذج البرنامج الكامل لمادة دراسية في طور ومستوى/شعبة محددة
class SubjectProgram {
  final String id;
  final String title;
  final String stage;
  final String levelOrStream;
  final String iconPath;
  final Color color;
  final String description;
  final List<LessonData> lessons;
  final List<QuizTopicData> quizzes;
  final List<LibraryItemData> libraryItems;
  final List<MediaItemData> mediaItems;

  const SubjectProgram({
    required this.id,
    required this.title,
    required this.stage,
    required this.levelOrStream,
    required this.iconPath,
    required this.color,
    required this.description,
    required this.lessons,
    required this.quizzes,
    required this.libraryItems,
    required this.mediaItems,
  });

  List<String> get uniqueUnits {
    final seen = <String>{};
    final result = <String>[];
    for (final l in lessons) {
      if (seen.add(l.section)) {
        result.add(l.section);
      }
    }
    return result;
  }
}

/// نموذج بيانات موحد للمادة الدراسية
class SubjectItem {
  final String id;
  final String title;
  final String stage;
  final String iconPath;
  final Color color;
  final String description;
  final List<String> units;

  const SubjectItem({
    required this.id,
    required this.title,
    required this.stage,
    required this.iconPath,
    required this.color,
    required this.description,
    required this.units,
  });
}

/// نموذج بيانات موحد للطور التعليمي أو الشعبة أو السنة
class StageFilterItem {
  final String title;
  final String subtitle;
  final String iconPath;
  final Color color;

  const StageFilterItem({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.color,
  });
}

/// نموذج موضوع امتحان رسمي (بكالوريا BAC أو شهادة التعليم المتوسط BEM) مع التصحيح وسلم التنقيط
class OfficialExamData {
  final String id;
  final String examType; // 'BAC' أو 'BEM'
  final String year; // مثل '2024', '2023'
  final String subject; // مثل 'الفلسفة', 'الرياضيات'
  final String streamOrLevel; // مثل 'شعبة علوم تجريبية', 'الرابعة متوسط'
  final String session; // مثل 'الدورة العادية'
  final String topicTitle; // مثل 'الموضوع الأول: الإشكالية الفلسفية'
  final String topicContent; // نص الموضوع كاملاً
  final String solutionContent; // الحل النموذجي المفصل
  final List<String> gradingCriteria; // سلم التنقيط الرسمي وعناصر الإجابة
  final String duration; // مثل '3 ساعات ونصف'
  final String coefficient; // المعامل مثل '6'

  const OfficialExamData({
    required this.id,
    required this.examType,
    required this.year,
    required this.subject,
    required this.streamOrLevel,
    required this.session,
    required this.topicTitle,
    required this.topicContent,
    required this.solutionContent,
    required this.gradingCriteria,
    this.duration = '3 ساعات',
    this.coefficient = '5',
  });
}

/// نموذج بطاقة أستاذ في الكاتلوج الإشهاري والتربوي
class TeacherProfileData {
  final String id;
  final String name;
  final String title; // مثل 'أستاذ مبرز في مادة العلوم الفيزيائية'
  final String subject; // المادة
  final String stage; // مثل 'التعليم الثانوي', 'التعليم المتوسط'
  final String wilaya; // الولاية مثل 'الجزائر العاصمة', 'وهران', 'قسنطينة'
  final String phone;
  final String whatsapp;
  final String telegram;
  final String email;
  final String bio; // نبذة وسنوات الخبرة
  final String offers; // مثل 'دروس خصوصية حضورية وعن بعد، ملخصات، مراجعة نهائية'
  final bool isVolunteer; // هل يقدم أعمالاً تطوعية مجانية للطلبة المعوزين
  final bool isVerified; // موثق من إدارة التطبيق
  final double rating;
  final String avatar;

  const TeacherProfileData({
    required this.id,
    required this.name,
    required this.title,
    required this.subject,
    required this.stage,
    required this.wilaya,
    required this.phone,
    required this.whatsapp,
    this.telegram = '',
    this.email = '',
    required this.bio,
    required this.offers,
    this.isVolunteer = false,
    this.isVerified = true,
    this.rating = 4.9,
    this.avatar = 'assets/icons/avatar01.png',
  });
}

/// نموذج طلب متابعة تربوية من طرف الأولياء
class MentorshipRequestData {
  final String id;
  final String parentName;
  final String studentName;
  final String phone;
  final String wilaya;
  final String stage; // الطور
  final String gradeLevel; // السنة الدراسية
  final List<String> targetSubjects; // المواد المراد متابعتها
  final String notes; // تفاصيل إضافية
  final DateTime createdAt;
  final String status; // 'قيد المراجعة', 'تم التعيين', 'مكتمل'

  const MentorshipRequestData({
    required this.id,
    required this.parentName,
    required this.studentName,
    required this.phone,
    required this.wilaya,
    required this.stage,
    required this.gradeLevel,
    required this.targetSubjects,
    required this.notes,
    required this.createdAt,
    this.status = 'قيد المراجعة',
  });
}

/// نموذج استشارة أو طلب حل مشكلة وصعوبة دراسية (قسم ربحي / تخصصي)
class AcademicConsultationData {
  final String id;
  final String requesterType; // 'طالب', 'ولي أمر', 'أستاذ'
  final String name;
  final String contact; // رقم الهاتف أو البريد
  final String wilaya;
  final String category; // 'صعوبة استيعاب مادة', 'قلق الامتحانات وتنظيم الوقت', 'منهجية الإجابة', 'استشارة تربوية خاصة'
  final String urgency; // 'عادي (خلال 48 ساعة)', 'مستعجل وممتاز (خلال 24 ساعة)'
  final String description; // شرح الصعوبة أو المشكلة
  final DateTime createdAt;
  final String status; // 'جديد', 'قيد التحليل', 'تم الرد'
  final String? adminReply;

  const AcademicConsultationData({
    required this.id,
    required this.requesterType,
    required this.name,
    required this.contact,
    required this.wilaya,
    required this.category,
    required this.urgency,
    required this.description,
    required this.createdAt,
    this.status = 'جديد',
    this.adminReply,
  });
}
