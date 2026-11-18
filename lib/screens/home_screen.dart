import 'package:flutter/material.dart';
import 'package:i_love_philosophy/screens/3_secondary/home_secondary.dart';
import 'package:i_love_philosophy/screens/0_preparatory/home_preparatory.dart';
import 'package:i_love_philosophy/screens/1_primary/home_primary.dart';
import 'package:i_love_philosophy/screens/2_middle/home_middle.dart';
import 'package:i_love_philosophy/screens/educational_enhancements_screen.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/screens/services/academic_problem_screen.dart';
import 'package:i_love_philosophy/screens/services/mentorship_request_screen.dart';
import 'package:i_love_philosophy/screens/services/teacher_catalog_screen.dart';
import 'package:i_love_philosophy/screens/shared/official_exams_screen.dart';
import 'package:i_love_philosophy/screens/shared/pedagogical_hub_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/books_screen.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/videos_screen.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';
import 'package:i_love_philosophy/utils/responsive_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final Color _selectedColor = Colors.white30;

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUI.fontBasis(context);
    final screenHeight = ResponsiveUI.heightBasis(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '📖 صفحــة 🖋️ البدايـــــة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'المتفوّق الجزائري',
                  style: TextStyle(
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
                    actions: [
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "نعم",
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w900,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
/*----------------------------------------------------------------------------*/
      drawer: CustomDrawer(),
/*----------------------------------------------------------------------------*/
      body:
/*----------------------------------------------------------------------------*/
          SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
/*----------------------------------------------------------------------------*/
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
                    offset: Offset(3, 3), // changes position of shadow
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
                      crossAxisAlignment:
                          CrossAxisAlignment.end, // محاذاة النص إلى اليمين
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
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'طالب 2000+',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.school, size: 16, color: Colors.indigo),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const TeacherCatalogScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'مدرس 100+',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.person, size: 16, color: Colors.deepOrange),
                                    ],
                                  ),
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
/*----------------------------------------------------------------------------*/
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
              child: Text(
                'المراحل التعليمية',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            GridView(
              reverse: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 265,
                mainAxisExtent: 195,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStageCard(
                    'التعليم التحضيري',
                    'assets/images/student1.png',
                    Colors.blueGrey,
                    const HomePreparatory()),
                _buildStageCard(
                    'التعليم الابتدائي',
                    'assets/images/student2.png',
                    Colors.redAccent,
                    const HomePrimary()),
                _buildStageCard(
                    'التعليم المتوسط',
                    'assets/images/student3.png',
                    Colors.greenAccent,
                    const HomeMiddle()),
                _buildStageCard(
                    'التعليم الثانوي',
                    'assets/images/student4.png',
                    Colors.yellowAccent,
                    const HomeSecondary()),
              ],
            ),
/*----------------------------------------------------------------------------*/
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: Text(
                'خدمات التميز والفرص التعليمية',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            _buildServiceCard(
              'الأقسام البيداغوجية والتفوق (ألعاب، مناهج، مذكرات)',
              '8 أقسام حصرية: ألعاب تربوية، تدرجات وزارية، نصائح، مذكرات لأساتذة، ملخصات، وبنك أسئلة.',
              Icons.hub_rounded,
              Colors.purple,
              const PedagogicalHubScreen(),
            ),
            _buildServiceCard(
              'المكتبة الرقمية الشاملة (100+ كتاب ومقرر)',
              'كتب وزارية رسمية، مذكرات، وحوليات تمارين محلولة لجميع الأطوار التعليمية.',
              Icons.local_library_rounded,
              Colors.deepPurple,
              const BooksScreen(),
            ),
            _buildServiceCard(
              'الفضاء السمعي البصري (52+ فيديو ومحاضرة)',
              'شروحات مرئية تفاعلية مقسمة حسب المحاور والخطوات التعليمية لجميع المواد.',
              Icons.video_library_rounded,
              Colors.red.shade700,
              const VideosScreen(),
            ),
            _buildServiceCard(
              'بنك الامتحانات الرسمية والحلول (BAC & BEM)',
              'مواضيع شهادتي البكالوريا والتعليم المتوسط مع الحل النموذجي وسلم التنقيط الوزاري.',
              Icons.workspace_premium_rounded,
              Colors.deepPurple,
              const OfficialExamsScreen(),
            ),
            _buildServiceCard(
              'العد التنازلي وبطاقات التكرار للامتحانات',
              'تابع الوقت المتبقي للامتحانات بدقة وتدرب بالبطاقات التفاعلية السريعة والشرح.',
              Icons.timer_rounded,
              Colors.teal,
              const EducationalEnhancementsScreen(initialTab: 0),
            ),
            _buildServiceCard(
              'هل تبحث عن مدرس متخصص ؟ (دليل الإشهار)',
              'تصفح كاتلوج الأساتذة المعتمدين وتواصل معهم مباشرة، أو احجز مساحتك الإشهارية.',
              Icons.person_search_rounded,
              Colors.indigo,
              const TeacherCatalogScreen(),
            ),
            _buildServiceCard(
              'هل تبحث عن متابع تربوي لابنك ؟',
              'خدمة خاصة بالأولياء لاختيار أستاذ ومتابع دراسي يرافق الطالب في مادة أو كل المواد.',
              Icons.supervisor_account_rounded,
              Colors.teal,
              const MentorshipRequestScreen(),
            ),
            _buildServiceCard(
              'هل لديك صعوبة أو مشكلة دراسية ؟ (العيادة)',
              'قسم استشاري لاستقبال صعوبات الفهم وقلق الامتحانات وتقديم حلول علاجية مخصصة.',
              Icons.psychology_rounded,
              Colors.deepOrange,
              const AcademicProblemScreen(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
/*----------------------------------------------------------------------------*/
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
/*----------------------------------------------------------------------------*/
    );
  }

/*----------------------------------------------------------------------------*/
  Widget _buildStageCard(
      String title, String imagePath, Color color, Widget screen) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.black12,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*----------------------------------------------------------------------------*/
  Widget _buildServiceCard(
      String title, String description, IconData icon, Color color, Widget nextScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withAlpha(25),
              child: Icon(icon, color: color, size: 24),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              description,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11.5,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
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
/*----------------------------------------------------------------------------*/
}
