import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/secondary_data.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/activities_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/lessons_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/videos_screen.dart';
import 'package:i_love_philosophy/screens/home_screen.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/screens/outils/study_companion_screen.dart';
import 'package:i_love_philosophy/screens/shared/stream_subject_navigator_screen.dart';
import 'package:i_love_philosophy/screens/shared/subject_hub_screen.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';

class HomeSecondary extends StatefulWidget {
  const HomeSecondary({super.key});

  @override
  State<HomeSecondary> createState() => HomeSecondaryState();
}

class HomeSecondaryState extends State<HomeSecondary> {
  final Color _selectedColor = Colors.white30;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
//-----------------------------------------------------------------------------//
      appBar: AppBar(
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '📖 مرحلة التعليم الثانوي (BAC)',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: _selectedColor,
//-----------------------------------------------------------------------------//
        actions: [
          IconButton(
            color: Colors.black,
            icon: const Icon(Icons.home),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      "مرحبا بك",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    content: Text(
                      "أنت في صفحة التعليم الثانوي يمكنك التنقل انطلاقًا من هنا",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.black,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    actions: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ' العودة',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w900,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Icon(Icons.arrow_back_ios_outlined,
                                      size: screenHeight * 0.03,
                                      color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'الرئيسية',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w900,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Icon(Icons.home_outlined,
                                      size: screenHeight * 0.03,
                                      color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
//-----------------------------------------------------------------------------//
      drawer: CustomDrawer(),
//-----------------------------------------------------------------------------//
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
//-----------------------------------------------------------------------------//
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/splash_background2.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/teacher1.png',
                    height: screenHeight * 0.2,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'معنا التعليم عن بعد أصبح أكثر متعة وسهولة مع تواجد أفضل المدرسين وأكثرهم خبرة وكفاءة',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.black87,
                            fontSize: screenWidth * 0.045,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'طالب',
                                      style: TextStyle(
                                        fontFamily: 'Amiri',
                                        fontSize: screenWidth * 0.033,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      ' 2000',
                                      style: TextStyle(
                                        fontFamily: 'Amiri',
                                        fontSize: screenWidth * 0.033,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.01),
                                    Icon(Icons.school,
                                        size: screenHeight * 0.03,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'مدرس',
                                      style: TextStyle(
                                        fontFamily: 'Amiri',
                                        fontSize: screenWidth * 0.034,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      ' 100',
                                      style: TextStyle(
                                        fontFamily: 'Amiri',
                                        fontSize: screenWidth * 0.034,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.01),
                                    Icon(Icons.person,
                                        size: screenHeight * 0.03,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
//-----------------------------------------------------------------------------//
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'كل المواد',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(
              height: 125,
              width: double.infinity,
              child: ListView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                children: [
                  _buildStageCard(
                      'الرياضيات',
                      'assets/icons/math.png',
                      Colors.grey,
                      const StreamSubjectNavigatorScreen(
                        initialMode: 'subject',
                        initialTarget: 'الرياضيات',
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'اللغة العربية',
                      'assets/icons/arabic.png',
                      Colors.grey,
                      const StreamSubjectNavigatorScreen(
                        initialMode: 'subject',
                        initialTarget: 'اللغة العربية',
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'العلوم الطبيعية',
                      'assets/icons/science.png',
                      Colors.grey,
                      const StreamSubjectNavigatorScreen(
                        initialMode: 'subject',
                        initialTarget: 'العلوم الطبيعية',
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'العلوم الفيزيائية',
                      'assets/icons/physics.png',
                      Colors.grey,
                      const StreamSubjectNavigatorScreen(
                        initialMode: 'subject',
                        initialTarget: 'العلوم الفيزيائية',
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'اللغة الفرنسية',
                      'assets/icons/french.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'اللغة الفرنسية',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/french.png',
                        accentColor: Colors.blueAccent,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'اللغة الإنجليزية',
                      'assets/icons/english.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'اللغة الإنجليزية',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/english.png',
                        accentColor: Colors.purple,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'العلوم الاسلامية',
                      'assets/icons/islamic.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'العلوم الإسلامية',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/islamic.png',
                        accentColor: Colors.teal,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'التاريخ والجغرافيا',
                      'assets/icons/his_geo.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'التاريخ والجغرافيا',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/his_geo.png',
                        accentColor: Colors.brown,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'الفلسفة',
                      'assets/icons/philo.png',
                      Colors.grey,
                      const StreamSubjectNavigatorScreen(
                        initialMode: 'subject',
                        initialTarget: 'الفلسفة',
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'القانون',
                      'assets/icons/droit.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'القانون',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/droit.png',
                        accentColor: Colors.blueGrey,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'التسيير المحاسبي والمالي',
                      'assets/icons/gestion.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'التسيير المحاسبي والمالي',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/gestion.png',
                        accentColor: Colors.deepOrange,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'الإقتصاد والمناجمنت',
                      'assets/icons/eco.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'الإقتصاد والمناجمنت',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/eco.png',
                        accentColor: Colors.amber,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'الهندسة المدنية',
                      'assets/icons/civil.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'الهندسة المدنية',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/civil.png',
                        accentColor: Colors.brown,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'الهندسة الكهربائية',
                      'assets/icons/elect.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'الهندسة الكهربائية',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/elect.png',
                        accentColor: Colors.orange,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'الهندسة الميكانيكية',
                      'assets/icons/mecanical.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'الهندسة الميكانيكية',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/mecanical.png',
                        accentColor: Colors.blueGrey,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'هندسة الطرائق',
                      'assets/icons/chimi.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'هندسة الطرائق',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/chimi.png',
                        accentColor: Colors.cyan,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'اللغة الألمانية',
                      'assets/icons/deutsch.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'اللغة الألمانية',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/deutsch.png',
                        accentColor: Colors.deepPurple,
                      ),
                      screenWidth * 0.03),
                  _buildStageCard(
                      'اللغة الإسبانية',
                      'assets/icons/espanol.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'اللغة الإسبانية',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/espanol.png',
                        accentColor: Colors.redAccent,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'اللغة الإيطالية',
                      'assets/icons/italian.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'اللغة الإيطالية',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/italian.png',
                        accentColor: Colors.green,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'اللغة الأمازيغية',
                      'assets/icons/tamazight.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'اللغة الأمازيغية',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/tamazight.png',
                        accentColor: Colors.amber,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'التربية البدنية',
                      'assets/icons/sport.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'التربية البدنية',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/sport.png',
                        accentColor: Colors.teal,
                      ),
                      screenWidth * 0.035),
                  _buildStageCard(
                      'الفنون',
                      'assets/icons/art.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'الفنون',
                        stageName: 'التعليم الثانوي',
                        iconPath: 'assets/icons/art.png',
                        accentColor: Colors.teal,
                      ),
                      screenWidth * 0.035),
                ],
              ),
            ),
//-----------------------------------------------------------------------------//
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'كل الشعب',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            GridView.count(
              reverse: true,
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildDivisionCard(
                    'شعبة علوم تجريبية',
                    'assets/icons/science.png',
                    Colors.lightBlueAccent,
                    const StreamSubjectNavigatorScreen(
                      initialMode: 'stream',
                      initialTarget: 'شعبة علوم تجريبية',
                    )),
                _buildDivisionCard(
                    'شعبة رياضيات',
                    'assets/icons/math.png',
                    Colors.lightGreen,
                    const StreamSubjectNavigatorScreen(
                      initialMode: 'stream',
                      initialTarget: 'شعبة رياضيات',
                    )),
                _buildDivisionCard(
                    'شعبة تقني رياضي',
                    'assets/icons/civil.png',
                    Colors.brown,
                    const StreamSubjectNavigatorScreen(
                      initialMode: 'stream',
                      initialTarget: 'شعبة تقني رياضي',
                    )),
                _buildDivisionCard(
                    'شعبة تسيير واقتصاد',
                    'assets/icons/gestion.png',
                    Colors.deepOrangeAccent,
                    const StreamSubjectNavigatorScreen(
                      initialMode: 'stream',
                      initialTarget: 'شعبة تسيير واقتصاد',
                    )),
                _buildDivisionCard(
                    'شعبة آداب وفلسفة',
                    'assets/icons/philo.png',
                    Colors.indigoAccent,
                    const StreamSubjectNavigatorScreen(
                      initialMode: 'stream',
                      initialTarget: 'شعبة آداب وفلسفة',
                    )),
                _buildDivisionCard(
                    'شعبة لغات أجنبية',
                    'assets/icons/english.png',
                    Colors.purple,
                    const StreamSubjectNavigatorScreen(
                      initialMode: 'stream',
                      initialTarget: 'شعبة لغات أجنبية',
                    )),
                _buildDivisionCard(
                    'ج.م.علوم وتكنولوجيا',
                    'assets/icons/tech.png',
                    Colors.grey,
                    const StreamSubjectNavigatorScreen(
                      initialMode: 'stream',
                      initialTarget: 'ج.م.علوم وتكنولوجيا',
                    )),
                _buildDivisionCard(
                    'جذع مشترك آداب',
                    'assets/icons/arabic.png',
                    Colors.pink,
                    const StreamSubjectNavigatorScreen(
                      initialMode: 'stream',
                      initialTarget: 'جذع مشترك آداب',
                    )),
                _buildDivisionCard(
                    'شعبة الفنون',
                    'assets/icons/art.png',
                    Colors.teal,
                    const StreamSubjectNavigatorScreen(
                      initialMode: 'stream',
                      initialTarget: 'شعبة الفنون',
                    )),
              ].reversed.toList(),
            ),
//-----------------------------------------------------------------------------//
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'كل السنوات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            GridView.count(
              reverse: true,
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildYearsCard(
                    'السنة الأولى',
                    'assets/icons/y_1_300.png',
                    Colors.blue,
                    const SubjectHubScreen(
                      title: 'السنة الأولى ثانوي',
                      stageName: 'التعليم الثانوي',
                      iconPath: 'assets/icons/y_1_300.png',
                      accentColor: Colors.blue,
                    )),
                _buildYearsCard(
                    'السنة الثانية',
                    'assets/icons/y_2_300.png',
                    Colors.greenAccent,
                    const SubjectHubScreen(
                      title: 'السنة الثانية ثانوي',
                      stageName: 'التعليم الثانوي',
                      iconPath: 'assets/icons/y_2_300.png',
                      accentColor: Colors.green,
                    )),
                _buildYearsCard(
                    'السنة الثالثة',
                    'assets/icons/y_3_300.png',
                    Colors.deepOrange,
                    const SubjectHubScreen(
                      title: 'السنة الثالثة ثانوي',
                      stageName: 'التعليم الثانوي',
                      iconPath: 'assets/icons/y_3_300.png',
                      accentColor: Colors.deepOrange,
                    )),
              ].reversed.toList(),
            ),
//-----------------------------------------------------------------------------//
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'اختصارات',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            GridView.count(
              reverse: true,
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildShortcutCard('أسئلة', 'assets/icons/science.png',
                    Colors.lightBlueAccent, const ActivitiesScreen()),
                _buildShortcutCard(
                    'ملخصات',
                    'assets/icons/math.png',
                    Colors.lightGreen,
                    const StudyCompanionScreen(initialTab: 0)),
                _buildShortcutCard('مذكرات', 'assets/icons/civil.png',
                    Colors.brown, const StudyCompanionScreen(initialTab: 1)),
                _buildShortcutCard('فيديوهات', 'assets/icons/gestion.png',
                    Colors.deepOrangeAccent, const VideosScreen()),
                _buildShortcutCard(
                    'جداول',
                    'assets/icons/philo.png',
                    Colors.indigoAccent,
                    const StudyCompanionScreen(initialTab: 2)),
                _buildShortcutCard('نصائح', 'assets/icons/english.png',
                    Colors.purple, const StudyCompanionScreen(initialTab: 0)),
                _buildShortcutCard('البرنامج المقرر', 'assets/icons/tech.png',
                    Colors.grey, const LessonsScreen()),
                _buildShortcutCard('ألعاب تربوية', 'assets/icons/arabic.png',
                    Colors.pink, const ActivitiesScreen()),
                _buildShortcutCard('متفرقات', 'assets/icons/art.png',
                    Colors.teal, const StudyCompanionScreen(initialTab: 3)),
              ].reversed.toList(),
            ),
//-----------------------------------------------------------------------------//
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'خدمات أخرى',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _buildServiceCard(
              'هل تبحث عن مدرس متخصص ؟',
              'يمكنك ارسال طلب للبحث عن مدرس لوظيفة معينة غير موجودة.',
              Icons.search,
              const StudyCompanionScreen(initialTab: 0),
            ),
            _buildServiceCard(
              'هل تبحث عن متابع ؟',
              'يمكنك اختيار مدرس يتابع مع الطالب دروسه ومذكرته وتنظيم وقته.',
              Icons.supervisor_account,
              const StudyCompanionScreen(initialTab: 2),
            ),
            _buildServiceCard(
              'هل تبحث عن حل لمشكلة ؟',
              'يمكنك ارسال المشكلة التي تواجهك وسنقوم بالرد عليها مجانًا خلال 24 ساعة.',
              Icons.help,
              const StudyCompanionScreen(initialTab: 1),
            ),
          ],
        ),
      ),
//-----------------------------------------------------------------------------//
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        currentProgram: SecondaryData.programs.first,
      ),
    );
  }

//-----------------------------------------------------------------------------//
  Widget _buildStageCard(String title, String imagePath, Color color,
      Widget screen, double fontSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      color: color,
      shadowColor: Colors.black26,
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03)),
      child: InkWell(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------//
  Widget _buildShortcutCard(
      String title, String imagePath, Color color, Widget screen) {
    return Card(
      color: color,
      shadowColor: Colors.black26,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------//
  Widget _buildDivisionCard(
      String title, String imagePath, Color color, Widget screen) {
    return Card(
      color: color,
      shadowColor: Colors.black26,
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------//
  Widget _buildServiceCard(
      String title, String description, IconData icon, Widget nextScreen) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenHeight * 0.002, vertical: screenHeight * 0.002),
      child: Card(
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            leading: Icon(icon, color: Colors.blueAccent),
            title: Text(
              title,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              description,
            ),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => nextScreen),
              );
            },
          ),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------//
  Widget _buildYearsCard(
      String title, String imagePath, Color color, Widget screen) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      color: color,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenHeight * 0.02)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Image.asset(imagePath, height: screenHeight * 0.12),
          ],
        ),
      ),
    );
  }
//-----------------------------------------------------------------------------//
}
