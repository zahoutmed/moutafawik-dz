import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_love_philosophy/data/curriculum_repository.dart';
import 'package:i_love_philosophy/utils/security_utils.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';

void main() {
  group('SecurityUtils tests', () {
    test('hashes password with unique salt and verifies correctly', () {
      const password = 'Strong@Password123';
      final hash1 = SecurityUtils.hashPassword(password);
      final hash2 = SecurityUtils.hashPassword(password);

      expect(hash1, startsWith('pbkdf2_sha256\$'));
      expect(hash1, isNot(equals(hash2)));
      expect(SecurityUtils.verifyPassword(password, hash1), isTrue);
      expect(SecurityUtils.verifyPassword(password, hash2), isTrue);
      expect(SecurityUtils.verifyPassword('WrongPassword', hash1), isFalse);
      expect(SecurityUtils.verifyPassword(password, password), isFalse);
    });

    test('validates external URLs safely', () {
      expect(SecurityUtils.isSafeExternalUrl('https://example.org'), isTrue);
      expect(SecurityUtils.isSafeExternalUrl('http://example.org/doc'), isTrue);
      expect(SecurityUtils.isSafeExternalUrl('javascript:alert(1)'), isFalse);
      expect(SecurityUtils.isSafeExternalUrl('file:///etc/passwd'), isFalse);
      expect(SecurityUtils.isSafeExternalUrl(''), isFalse);
    });
  });

  group('CurriculumRepository tests', () {
    test('resolves distinct authentic programs per stage and subject', () {
      final prepMath = CurriculumRepository.resolveProgram(
        title: 'الرياضيات',
        stageName: 'التعليم التحضيري',
      );
      final primArabic = CurriculumRepository.resolveProgram(
        title: 'اللغة العربية',
        stageName: 'التعليم الابتدائي',
      );
      final midPhysics = CurriculumRepository.resolveProgram(
        title: 'العلوم الفيزيائية',
        stageName: 'التعليم المتوسط',
      );
      final secPhilo = CurriculumRepository.resolveProgram(
        title: 'الفلسفة',
        stageName: 'التعليم الثانوي',
      );

      expect(prepMath.stage, equals('التعليم التحضيري'));
      expect(primArabic.stage, equals('التعليم الابتدائي'));
      expect(midPhysics.stage, equals('التعليم المتوسط'));
      expect(secPhilo.stage, equals('التعليم الثانوي'));

      expect(primArabic.lessons.first.title,
          isNot(equals(secPhilo.lessons.first.title)));
      expect(midPhysics.quizzes, isNotEmpty);
      expect(midPhysics.libraryItems, isNotEmpty);
      expect(midPhysics.mediaItems, isNotEmpty);
    });

    test('all programs have non-empty lessons, quizzes, library, and media', () {
      for (final program in CurriculumRepository.allPrograms) {
        expect(program.lessons, isNotEmpty,
            reason: '${program.id} should have lessons');
        expect(program.quizzes, isNotEmpty,
            reason: '${program.id} should have quizzes');
        expect(program.libraryItems, isNotEmpty,
            reason: '${program.id} should have library items');
        expect(program.mediaItems, isNotEmpty,
            reason: '${program.id} should have media items');
      }
    });
  });

  group('AppBottomNavBar widget test', () {
    testWidgets('renders all 5 icons and Arabic category labels',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppBottomNavBar(currentIndex: 0),
          ),
        ),
      );

      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('الدروس'), findsOneWidget);
      expect(find.text('الاختبارات'), findsOneWidget);
      expect(find.text('المكتبة'), findsOneWidget);
      expect(find.text('الميلتيميديا'), findsOneWidget);
    });
  });
}
