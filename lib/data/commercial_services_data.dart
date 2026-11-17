import 'package:i_love_philosophy/models/education_models.dart';

/// قاعدة بيانات الخدمات الإشهارية والاستشارية والربحية
class CommercialServicesData {
  /// رقم هاتف وبريد إدارة التطبيق لحجز المساحات الإعلانية والتواصل الرسمي
  static const String adminPhone = '+213555000111';
  static const String adminWhatsapp = '213555000111';
  static const String adminEmail = 'contact@edudz-platform.com';

  /// قائمة الأساتذة في الكاتلوج الإشهاري
  static final List<TeacherProfileData> sampleTeachers = [
    TeacherProfileData(
      id: 'teacher_1',
      name: 'أ. مراد بن يوسف',
      title: 'أستاذ مبرز في مادة الفلسفة (خبرة 18 سنة)',
      subject: 'الفلسفة',
      stage: 'التعليم الثانوي (شعبة آداب وفلسفة ولغات وعلمي)',
      wilaya: 'الجزائر العاصمة / بومرداس',
      phone: '0551234567',
      whatsapp: '213551234567',
      telegram: 'prof_mourad_philo',
      email: 'mourad.philo@gmail.com',
      bio: 'مؤلف سلسلة التفوق في مقالات البكالوريا، مدرب معتمد في بناء المنهجيات الفلسفية وتفكيك الإشكاليات المعقدة.',
      offers: '• دورات مراجعة نهائية حضورية وعبر تطبيق Zoom\n• تصحيح فردي للمقالات الفلسفية مع سلم التنقيط الوزاري\n• ملخصات شاملة ومخططات ذهنية لكل الشعب',
      isVolunteer: true,
      isVerified: true,
      rating: 4.95,
      avatar: 'assets/icons/avatar01.png',
    ),
    TeacherProfileData(
      id: 'teacher_2',
      name: 'أ. سهام قادري',
      title: 'أستاذة رئيسية في الرياضيات للطورين الثانوي والمتوسط',
      subject: 'الرياضيات',
      stage: 'التعليم الثانوي والمتوسط (BAC & BEM)',
      wilaya: 'وهران / عين تموشنت',
      phone: '0662345678',
      whatsapp: '213662345678',
      telegram: 'maths_avec_siham',
      email: 'siham.maths@gmail.com',
      bio: 'متخصصة في تبسيط الدوال الأسية واللوغاريتمية والمتتاليات والاحتمالات، مرافقة لأكثر من 500 طالب حاصل على البكالوريا بامتياز.',
      offers: '• مجموعات مغلقة لتمارين البكالوريا والبيام النموذجية\n• بنك سلاسل تمارين محلولة بالفيديو\n• دروس دعم أسبوعية فردية وجماعية',
      isVolunteer: false,
      isVerified: true,
      rating: 4.9,
      avatar: 'assets/icons/avatar02.png',
    ),
    TeacherProfileData(
      id: 'teacher_3',
      name: 'د. لخضر بلحاج',
      title: 'دكتوراه في العلوم الفيزيائية ومكون أساتذة',
      subject: 'العلوم الفيزيائية',
      stage: 'التعليم الثانوي (علوم تجريبية ورياضي وتقني رياضي)',
      wilaya: 'قسنطينة / سطيف',
      phone: '0773456789',
      whatsapp: '213773456789',
      telegram: 'physique_belhadj',
      email: 'dr.belhadj.phys@gmail.com',
      bio: 'خبرة 22 سنة في التدريس الجامعي والثانوي، مشرف على حقائب التجارب الفيزيائية التفاعلية.',
      offers: '• تفكيك شامل لتمارين الميكانيك وحركة الكواكب والأقمار\n• حصص تطبيقية للدارة RC و RL وتفاعلات الأسترة\n• مرافقة مجانية للطلبة المتفوقين والمعوزين (عمل تطوعي)',
      isVolunteer: true,
      isVerified: true,
      rating: 4.98,
      avatar: 'assets/icons/avatar01.png',
    ),
    TeacherProfileData(
      id: 'teacher_4',
      name: 'أ. فتيحة رحماني',
      title: 'مفتشة تربوية متقاعدة وأستاذة علوم الطبيعة والحياة',
      subject: 'علوم الطبيعة والحياة',
      stage: 'التعليم الثانوي (شعبة علوم تجريبية ورياضيات)',
      wilaya: 'البليدة / تيبازة',
      phone: '0559876543',
      whatsapp: '213559876543',
      telegram: 'science_rahmani',
      email: 'rahmani.fatiha@gmail.com',
      bio: 'أستاذة ومؤلفة كتب مدرسية معتمدة، مختصة في منهجية التحليل والمقارنة والتفسير للوثائق البيولوجية.',
      offers: '• تدريب دقيق على منهجية تقييم الكفاءات في العلوم\n• وحدات المناعة والاتصال العصبي وتركيب البروتين\n• جلسات تصحيح فردية لمواضيع البكالوريا',
      isVolunteer: false,
      isVerified: true,
      rating: 4.88,
      avatar: 'assets/icons/avatar02.png',
    ),
  ];

  /// قائمة افتراضية لطلبات المتابعة التربوية للأولياء
  static final List<MentorshipRequestData> mentorshipRequests = [];

  /// قائمة افتراضية للاستشارات وحل المشكلات الدراسية
  static final List<AcademicConsultationData> consultations = [];
}
