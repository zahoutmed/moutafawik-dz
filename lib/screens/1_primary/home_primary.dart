import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/primary_data.dart';
import 'package:i_love_philosophy/screens/home_screen.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/screens/outils/study_companion_screen.dart';
import 'package:i_love_philosophy/screens/shared/subject_hub_screen.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';

class HomePrimary extends StatefulWidget {
  const HomePrimary({super.key});

  @override
  State<HomePrimary> createState() => HomePrimaryState();
}

class HomePrimaryState extends State<HomePrimary> {
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
            '📖 مرحلة التعليم الابتدائي (تقييم المكتسبات)',
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
                      'السنة الأولى',
                      'assets/icons/y_1_300.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'السنة الأولى ابتدائي',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/y_1_300.png',
                        accentColor: Colors.blue,
                      )),
                  _buildCard(
                      context,
                      'السنة الثانية',
                      'assets/icons/y_2_300.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'السنة الثانية ابتدائي',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/y_2_300.png',
                        accentColor: Colors.green,
                      )),
                  _buildCard(
                      context,
                      'السنة الثالثة',
                      'assets/icons/y_3_300.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'السنة الثالثة ابتدائي',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/y_3_300.png',
                        accentColor: Colors.deepOrange,
                      )),
                  _buildCard(
                      context,
                      'السنة الرابعة',
                      'assets/icons/y_4_300.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'السنة الرابعة ابتدائي',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/y_4_300.png',
                        accentColor: Colors.purple,
                      )),
                  _buildCard(
                      context,
                      'السنة الخامسة',
                      'assets/icons/y_5_300.png',
                      Colors.grey,
                      const SubjectHubScreen(
                        title: 'السنة الخامسة ابتدائي',
                        stageName: 'التعليم الابتدائي',
                        iconPath: 'assets/icons/y_5_300.png',
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
                  crossAxisCount: 4,
                  crossAxisSpacing: 0, // المسافة الأفقية بين البطاقات
                  mainAxisSpacing: 0, // المسافة الرأسية بين البطاقات
                  children: [
                    _buildCard(
                        context,
                        'الرياضيات',
                        'assets/icons/math.png',
                        Colors.grey,
                        const SubjectHubScreen(
                          title: 'الرياضيات',
                          stageName: 'التعليم الابتدائي',
                          iconPath: 'assets/icons/math.png',
                          accentColor: Colors.green,
                        )),
                    _buildCard(
                        context,
                        'اللغة العربية',
                        'assets/icons/arabic.png',
                        Colors.grey,
                        const SubjectHubScreen(
                          title: 'اللغة العربية',
                          stageName: 'التعليم الابتدائي',
                          iconPath: 'assets/icons/arabic.png',
                          accentColor: Colors.pink,
                        )),
                    _buildCard(
                        context,
                        'التربية الاسلامية',
                        'assets/icons/islamic.png',
                        Colors.grey,
                        const SubjectHubScreen(
                          title: 'التربية الإسلامية',
                          stageName: 'التعليم الابتدائي',
                          iconPath: 'assets/icons/islamic.png',
                          accentColor: Colors.teal,
                        )),
                    _buildCard(
                        context,
                        'التربية العلمية',
                        'assets/icons/science.png',
                        Colors.grey,
                        const SubjectHubScreen(
                          title: 'التربية العلمية',
                          stageName: 'التعليم الابتدائي',
                          iconPath: 'assets/icons/science.png',
                          accentColor: Colors.lightBlue,
                        )),
                    _buildCard(
                        context,
                        'التربية المدنية',
                        'assets/icons/civic.png',
                        Colors.grey,
                        const SubjectHubScreen(
                          title: 'التربية المدنية',
                          stageName: 'التعليم الابتدائي',
                          iconPath: 'assets/icons/civic.png',
                          accentColor: Colors.orange,
                        )),
                    _buildCard(
                        context,
                        'التاريخ والجغرافيا',
                        'assets/icons/his_geo.png',
                        Colors.grey,
                        const SubjectHubScreen(
                          title: 'التاريخ والجغرافيا',
                          stageName: 'التعليم الابتدائي',
                          iconPath: 'assets/icons/his_geo.png',
                          accentColor: Colors.brown,
                        )),
                    _buildCard(
                        context,
                        'اللغة الفرنسية',
                        'assets/icons/french.png',
                        Colors.grey,
                        const SubjectHubScreen(
                          title: 'اللغة الفرنسية',
                          stageName: 'التعليم الابتدائي',
                          iconPath: 'assets/icons/french.png',
                          accentColor: Colors.blueAccent,
                        )),
                    _buildCard(
                        context,
                        'اللغة الإنجليزية',
                        'assets/icons/english.png',
                        Colors.grey,
                        const SubjectHubScreen(
                          title: 'اللغة الإنجليزية',
                          stageName: 'التعليم الابتدائي',
                          iconPath: 'assets/icons/english.png',
                          accentColor: Colors.purple,
                        )),
                    _buildCard(
                        context,
                        'التربية الفنية',
                        'assets/icons/art.png',
                        Colors.grey,
                        const SubjectHubScreen(
                          title: 'التربية الفنية',
                          stageName: 'التعليم الابتدائي',
                          iconPath: 'assets/icons/art.png',
                          accentColor: Colors.teal,
                        )),
                    _buildCard(
                        context,
                        'التربية الموسيقية',
                        'assets/icons/music.png',
                        Colors.grey,
                        const SubjectHubScreen(
                          title: 'التربية الموسيقية',
                          stageName: 'التعليم الابتدائي',
                          iconPath: 'assets/icons/music.png',
                          accentColor: Colors.indigo,
                        )),
                    _buildCard(
                        context,
                        'اللغة الأمازيغية',
                        'assets/icons/tamazight.png',
                        Colors.grey,
                        const SubjectHubScreen(
                          title: 'اللغة الأمازيغية',
                          stageName: 'التعليم الابتدائي',
                          iconPath: 'assets/icons/tamazight.png',
                          accentColor: Colors.amber,
                        )),
                    _buildCard(
                        context,
                        'التربية البدنية',
                        'assets/icons/sport.png',
                        Colors.grey,
                        const SubjectHubScreen(
                          title: 'التربية البدنية',
                          stageName: 'التعليم الابتدائي',
                          iconPath: 'assets/icons/sport.png',
                          accentColor: Colors.green,
                        )),
                  ],
                ),
              ),
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
        currentProgram: PrimaryData.programs.first,
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
          ),
        ));
  }
/*----------------------------------------------------------------------------*/
}
