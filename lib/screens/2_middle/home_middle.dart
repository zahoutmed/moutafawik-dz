import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/middle_data.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/activities_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/books_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/lessons_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/videos_screen.dart';
import 'package:i_love_philosophy/screens/educational_enhancements_screen.dart';
import 'package:i_love_philosophy/screens/home_screen.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/screens/outils/study_companion_screen.dart';
import 'package:i_love_philosophy/screens/shared/subject_hub_screen.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';

class HomeMiddle extends StatefulWidget {
  const HomeMiddle({super.key});

  @override
  State<HomeMiddle> createState() => HomeMiddleState();
}

class HomeMiddleState extends State<HomeMiddle> {
  final Color _selectedColor = Colors.white30;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '📖 مرحلة التعليم المتوسط (BEM)',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: _selectedColor,
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
                      "أنت في صفحة البداية يمكنك التنقل انطلاقًا من هنا",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.black,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
/*---------------------------------------------------------------------------*/
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
                                  SizedBox(
                                      width: screenWidth *
                                          0.01), // مسافة بين الأيقونة والنص
                                  Icon(Icons.arrow_back_ios_outlined,
                                      size: screenHeight * 0.03,
                                      color: Colors.black), // الأيقونة
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              width: screenWidth * 0.01), // مسافة بين الأزرار
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

                                  SizedBox(
                                      width: screenWidth *
                                          0.01), // مسافة بين الأيقونة والنص
                                  Icon(Icons.home_outlined,
                                      size: screenHeight * 0.03,
                                      color: Colors.black), // الأيقونة
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
/*----------------------------------------------------------------------------*/
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_background2.jpg'),
            fit: BoxFit.cover,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
/*----------------------------------------------------------------------------*/
            Column(children: [
              Text(
                'كل المواد',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ]),
/*----------------------------------------------------------------------------*/
            Expanded(
              child: GridView.count(
                reverse: true,
                scrollDirection: Axis.horizontal,
                crossAxisCount: 1,
                padding: EdgeInsets.all(screenHeight * 0.019),
                children: [
                  _buildCard(
                      context,
                      'رياضيات',
                      'assets/icons/math.png',
                      Colors.transparent,
                      const SubjectHubScreen(
                        title: 'الرياضيات',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/math.png',
                        accentColor: Colors.green,
                      )),
                  _buildCard(
                      context,
                      'علوم طبيعية',
                      'assets/icons/science.png',
                      Colors.indigo,
                      const SubjectHubScreen(
                        title: 'العلوم الطبيعية',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/science.png',
                        accentColor: Colors.indigo,
                      )),
                  _buildCard(
                      context,
                      'فيزياء',
                      'assets/icons/physics.png',
                      Colors.amber,
                      const SubjectHubScreen(
                        title: 'الفيزياء',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/physics.png',
                        accentColor: Colors.amber,
                      )),
                  _buildCard(
                      context,
                      'انجليزي',
                      'assets/icons/english.png',
                      Colors.orange,
                      const SubjectHubScreen(
                        title: 'اللغة الإنجليزية',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/english.png',
                        accentColor: Colors.orange,
                      )),
                  _buildCard(
                      context,
                      'عربية',
                      'assets/icons/arabic.png',
                      Colors.purple,
                      const SubjectHubScreen(
                        title: 'اللغة العربية',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/arabic.png',
                        accentColor: Colors.purple,
                      )),
                  _buildCard(
                      context,
                      'فرنسية',
                      'assets/icons/french.png',
                      Colors.teal,
                      const SubjectHubScreen(
                        title: 'اللغة الفرنسية',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/french.png',
                        accentColor: Colors.teal,
                      )),
                  _buildCard(
                      context,
                      'تربية إسلامية',
                      'assets/icons/islamic.png',
                      Colors.purple,
                      const SubjectHubScreen(
                        title: 'التربية الإسلامية',
                        stageName: 'التعليم المتوسط',
                        iconPath: 'assets/icons/islamic.png',
                        accentColor: Colors.teal,
                      )),
                ],
              ),
            ),
/*----------------------------------------------------------------------------*/
            Column(
              children: [
                Text('اختصارات',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ))
              ],
            ),
/*----------------------------------------------------------------------------*/
            Expanded(
              child: Directionality(
                  textDirection:
                      TextDirection.rtl, // تحديد الاتجاه من اليمين إلى اليسار
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    crossAxisSpacing: 0, // المسافة الأفقية بين البطاقات
                    mainAxisSpacing: 0, // المسافة الرأسية بين البطاقات
                    children: [
                      _buildCard(
                          context,
                          'أسئلة',
                          'assets/images/book_cover.png',
                          Colors.teal,
                          ActivitiesScreen(program: MiddleData.programs.first)),
                      _buildCard(
                          context,
                          'ملخصات',
                          'assets/images/book_cover.png',
                          Colors.indigo,
                          LessonsScreen(program: MiddleData.programs.first)),
                      _buildCard(
                          context,
                          'مذكرات',
                          'assets/images/book_cover.png',
                          Colors.amber,
                          BooksScreen(program: MiddleData.programs.first)),
                      _buildCard(
                          context,
                          'فيديوهات',
                          'assets/images/book_cover.png',
                          Colors.pink,
                          VideosScreen(program: MiddleData.programs.first)),
                      _buildCard(
                          context,
                          'جداول',
                          'assets/images/book_cover.png',
                          Colors.brown,
                          const EducationalEnhancementsScreen()),
                      _buildCard(
                          context,
                          'نصائح',
                          'assets/images/book_cover.png',
                          Colors.cyan,
                          const EducationalEnhancementsScreen()),
                      _buildCard(context, 'كتب', 'assets/images/book_cover.png',
                          Colors.deepOrange, BooksScreen(program: MiddleData.programs.first)),
                      _buildCard(
                          context,
                          'الدروس',
                          'assets/images/book_cover.png',
                          Colors.black26,
                          LessonsScreen(program: MiddleData.programs.first)),
                    ],
                  )),
            ),
/*----------------------------------------------------------------------------*/
            Column(children: [
              Text(
                'ادوات مساعدة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ]),
/*----------------------------------------------------------------------------*/
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: [
                  _buildCard(context, 'رسم', 'assets/images/book_cover.png',
                      Colors.blueGrey, const StudyCompanionScreen(initialTab: 0)),
                  _buildCard(context, 'محادثات', 'assets/images/book_cover.png',
                      Colors.redAccent, const StudyCompanionScreen(initialTab: 1)),
                  _buildCard(
                      context,
                      'المتابعة',
                      'assets/images/book_cover.png',
                      Colors.greenAccent,
                      const StudyCompanionScreen(initialTab: 2)),
                ],
              ),
            ),
/*----------------------------------------------------------------------------*/
          ],
        ),
      ),
/*----------------------------------------------------------------------------*/
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        currentProgram: MiddleData.programs.first,
      ),
/*----------------------------------------------------------------------------*/
    );
  }

/*----------------------------------------------------------------------------*/
  Widget _buildCard(BuildContext context, String title, String imagePath,
      Color color, Widget screen) {
    return Card(
      color: color,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
          borderRadius: BorderRadius.circular(14),
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
                  Expanded(
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
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
          )),
    );
  }
/*----------------------------------------------------------------------------*/
}
