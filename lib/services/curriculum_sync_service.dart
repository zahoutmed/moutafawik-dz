import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:i_love_philosophy/models/education_models.dart';

/// خدمة المزامنة السحابية الفورية مع Firebase Firestore
/// تضمن انعكاس أي تحديثات في الدروس أو الكتب أو الفيديوهات مباشرة على الهاتف والويب معاً
class CurriculumSyncService {
  static final CurriculumSyncService _instance = CurriculumSyncService._internal();
  factory CurriculumSyncService() => _instance;
  CurriculumSyncService._internal();

  final Map<String, List<LessonData>> _remoteLessonOverrides = {};
  final ValueNotifier<int> syncRevision = ValueNotifier<int>(0);
  String? _latestAnnouncement;
  String? _latestAppVersion;

  String? get latestAnnouncement => _latestAnnouncement;
  String? get latestAppVersion => _latestAppVersion;

  /// تهيئة الاستماع اللحظي لتحديثات Firestore (دون تعطيل التطبيق إن كان بدون إنترنت)
  Future<void> startRealtimeSync() async {
    try {
      final db = FirebaseFirestore.instance;

      // الاستماع لإعدادات المنصة والإصدار الحالي
      db.collection('app_config').doc('platform').snapshots().listen((snap) {
        if (snap.exists && snap.data() != null) {
          final data = snap.data()!;
          _latestAnnouncement = data['announcement']?.toString();
          _latestAppVersion = data['version']?.toString();
          syncRevision.value++;
        }
      }, onError: (e) {
        debugPrint('Firestore app_config sync notice: $e');
      });

      // الاستماع لتحديثات الدروس الحية
      db.collection('curriculum_updates').snapshots().listen((snapshot) {
        for (final doc in snapshot.docs) {
          final data = doc.data();
          final programId = data['programId']?.toString() ?? '';
          final lessonsRaw = data['lessons'];
          if (programId.isNotEmpty && lessonsRaw is List) {
            final parsed = lessonsRaw.whereType<Map>().map((m) {
              final sectionsRaw = m['detailedSections'];
              final parsedSections = sectionsRaw is List
                  ? sectionsRaw
                      .whereType<Map>()
                      .map((s) => LessonSection(
                            title: (s['title'] ?? '').toString(),
                            content: (s['content'] ?? '').toString(),
                            bulletPoints: s['bulletPoints'] is List
                                ? List<String>.from((s['bulletPoints'] as List).map((e) => e.toString()))
                                : const [],
                          ))
                      .toList()
                  : const <LessonSection>[];
              return LessonData(
                section: (m['section'] ?? '').toString(),
                title: (m['title'] ?? '').toString(),
                summary: (m['summary'] ?? m['desc'] ?? '').toString(),
                keyPoints: m['keyPoints'] is List
                    ? List<String>.from((m['keyPoints'] as List).map((e) => e.toString()))
                    : const [],
                duration: (m['duration'] ?? '45د').toString(),
                audience: (m['audience'] ?? '').toString(),
                pdfFile: m['pdfFile']?.toString(),
                fullExplanation: (m['fullExplanation'] ?? '').toString(),
                detailedSections: parsedSections,
                examples: m['examples'] is List
                    ? List<String>.from((m['examples'] as List).map((e) => e.toString()))
                    : const [],
                mindMapSummary: (m['mindMapSummary'] ?? '').toString(),
                reviewQuestions: m['reviewQuestions'] is List
                    ? List<String>.from((m['reviewQuestions'] as List).map((e) => e.toString()))
                    : const [],
              );
            }).toList();

            if (parsed.isNotEmpty) {
              _remoteLessonOverrides[programId] = parsed;
            }
          }
        }
        syncRevision.value++;
      }, onError: (e) {
        debugPrint('Firestore curriculum sync notice: $e');
      });
    } catch (e) {
      debugPrint('CurriculumSyncService init warning: $e');
    }
  }

  /// دمج الدروس المحدثة سحابياً مع الدروس المدمجة محلياً (إن وجدت)
  List<LessonData> mergeLessons(String programId, List<LessonData> localLessons) {
    final remote = _remoteLessonOverrides[programId];
    if (remote == null || remote.isEmpty) return localLessons;

    final map = <String, LessonData>{};
    for (final l in localLessons) {
      map[l.title] = l;
    }
    for (final r in remote) {
      map[r.title] = r;
    }
    return map.values.toList();
  }
}
