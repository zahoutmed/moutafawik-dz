import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:i_love_philosophy/firebase_options.dart';
import 'package:i_love_philosophy/services/curriculum_sync_service.dart';
import 'package:i_love_philosophy/screens/educational_enhancements_screen.dart';
import 'package:i_love_philosophy/screens/outils/activation_screen.dart';
import 'package:i_love_philosophy/screens/outils/about_us_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/activities_screen.dart';
import 'package:i_love_philosophy/screens/outils/banner_ad_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/book_detail_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/books_screen.dart';
import 'package:i_love_philosophy/screens/outils/forgot_password_screen.dart';
import 'package:i_love_philosophy/screens/outils/theme_provider.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/video_detail_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/lessons_screen.dart';
import 'package:i_love_philosophy/screens/outils/settings_screen.dart';
import 'package:i_love_philosophy/screens/splash_screen.dart';
import 'package:i_love_philosophy/screens/outils/guest_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/videos_screen.dart';
import 'package:i_love_philosophy/screens/outils/signup_screen.dart';
import 'package:i_love_philosophy/screens/outils/login_screen.dart';
import 'package:i_love_philosophy/screens/home_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/pdf_view_screen.dart';
import 'package:i_love_philosophy/screens/outils/study_companion_screen.dart';
import 'package:i_love_philosophy/screens/services/academic_problem_screen.dart';
import 'package:i_love_philosophy/screens/services/mentorship_request_screen.dart';
import 'package:i_love_philosophy/screens/services/teacher_catalog_screen.dart';
import 'package:i_love_philosophy/screens/shared/official_exams_screen.dart';
import 'package:i_love_philosophy/screens/shared/pedagogical_hub_screen.dart';
import 'package:i_love_philosophy/screens/user_preferences_screen.dart';
import 'package:i_love_philosophy/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await CurriculumSyncService().startRealtimeSync();
  } catch (e) {
    debugPrint('Firebase initialization warning: $e');
  }
  runApp(const ILovePhilosophy());
}

class ILovePhilosophy extends StatelessWidget {
  const ILovePhilosophy({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          // تحديد الموضوع بناءً على وضع التطبيق (فاتح أو مظلم)
          final isDarkMode = themeProvider.isDarkMode;

          return MaterialApp(
            title: 'المتفوّق الجزائري - Moutafawik DZ',
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              final media = MediaQuery.of(context);
              // On web or desktop preview screens with large displays, center comfortably.
              // On native mobile devices (Android/iOS, such as realme 11 pro), render 100% full screen with native responsiveness.
              if (kIsWeb && media.size.width > 600) {
                const mobileWidth = 450.0;
                return Container(
                  color: const Color(0xFF1E1E2C),
                  alignment: Alignment.center,
                  child: Container(
                    width: mobileWidth,
                    height: media.size.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: MediaQuery(
                      data: media.copyWith(
                        size: Size(mobileWidth, media.size.height),
                      ),
                      child: child ?? const SizedBox.shrink(),
                    ),
                  ),
                );
              }
              return child ?? const SizedBox.shrink();
            },
            theme: isDarkMode
                ? ThemeData.dark()
                    .copyWith(
                      primaryColor:
                          _createMaterialColor(themeProvider.primaryColor),
                      scaffoldBackgroundColor: themeProvider.backgroundColor,
                      textTheme: TextTheme(
                        bodyLarge: themeProvider.bodyTextStyle
                            .copyWith(fontSize: themeProvider.fontSize),
                        titleLarge: themeProvider.headingTextStyle,
                      ),
                      iconTheme: IconThemeData(size: themeProvider.iconSize),
                    )
                    .copyWith(
                      // تخصيص للموضوع الداكن
                      brightness:
                          isDarkMode ? Brightness.dark : Brightness.light,
                    )
                : ThemeData.light().copyWith(
                    primaryColor:
                        _createMaterialColor(themeProvider.primaryColor),
                    scaffoldBackgroundColor: themeProvider.backgroundColor,
                    textTheme: TextTheme(
                      bodyLarge: themeProvider.bodyTextStyle
                          .copyWith(fontSize: themeProvider.fontSize),
                      titleLarge: themeProvider.headingTextStyle,
                    ),
                    iconTheme: IconThemeData(size: themeProvider.iconSize),
                  ),
            initialRoute: '/',
            routes: {
              '/about_us_screen': (context) => AboutUsScreen(),
              '/activation_screen': (context) => ActivationScreen(),
              '/activities_screen': (context) => ActivitiesScreen(),
              '/banner_ad_screen': (context) => BannerAds(),
              '/book_detail_screen': (context) => BookDetailScreen(book: {}),
              '/books_screen': (context) => BooksScreen(),
              '/forgot_password_screen': (context) => ForgotPasswordScreen(),
              '/guest_screen': (context) => GuestScreen(),
              '/home_screen': (context) => HomeScreen(),
              '/lessons_screen': (context) => LessonsScreen(),
              '/login_screen': (context) => LoginScreen(),
              '/pdf_view_screen': (context) => PDFViewScreen(pdfPath: ''),
              '/settings_screen': (context) => SettingsScreen(),
              '/signup_screen': (context) => SignupScreen(),
              '/': (context) => SplashScreen(),
              '/videos_detail_screen': (context) =>
                  const VideoDetailScreen(video: {}),
              '/videos_screen': (context) => const VideosScreen(),
              '/educational_enhancements_screen': (context) =>
                  const EducationalEnhancementsScreen(),
              '/study_companion_screen': (context) =>
                  const StudyCompanionScreen(),
              '/user_preferences_screen': (context) =>
                  const UserPreferencesScreen(),
              '/teacher_catalog_screen': (context) =>
                  const TeacherCatalogScreen(),
              '/mentorship_request_screen': (context) =>
                  const MentorshipRequestScreen(),
              '/academic_problem_screen': (context) =>
                  const AcademicProblemScreen(),
              '/official_exams_screen': (context) =>
                  const OfficialExamsScreen(),
              '/pedagogical_hub_screen': (context) =>
                  const PedagogicalHubScreen(),
              '/welcome_screen': (context) => const WelcomeScreen(),
            },
          );
        },
      ),
    );
  }

  MaterialColor _createMaterialColor(Color color) {
    List<int> strengths = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
    Map<int, Color> swatch = {};

    for (int strength in strengths) {
      double factor = (strength / 1000); // حساب التدرج
      swatch[strength] = Color.fromRGBO(
        ((color.r * 255.0).round() * factor).toInt().clamp(0, 255),
        ((color.g * 255.0).round() * factor).toInt().clamp(0, 255),
        ((color.b * 255.0).round() * factor).toInt().clamp(0, 255),
        1.0, // الشفافية
      );
    }

    // استخدام color لمرة واحدة من خلال قيمة اللون الأساسية
    return MaterialColor(color.toARGB32(), swatch);
  }
}
