import 'package:flutter/material.dart';

class GuestScreen extends StatelessWidget {
  final List<Map<String, Object>> limitedLessons = [
    {
      'title': 'في إدراك العالم الخارجي',
      'cards': [
        {
          'title': 'الاحساس والادراك',
          'image': 'assets/images/lesson1.jpg',
          'questions': [
            {
              'السؤال':
                  'في سياق المدرسة الحسية، كيف يفسر جون لوك مفهوم "الصفحة البيضاء" بالنسبة للتجربة الحسية؟',
              'خيارات': [
                'أ. يعتبر الصفحة البيضاء رمزاً للعقل الذي يتأثر مباشرة بالحواس دون تدخل أي عوامل أخرى.',
                'ب. يعتقد أن العقل في البداية يكون كصفحة بيضاء وأن جميع المعارف تأتي من التجربة الحسية.',
                'ج. يربط الصفحة البيضاء بالعقل الذي يتشكل ويتحول مع مرور الزمن وفقاً للتجارب الحسية والعقلية.',
                'د. يرى أن الصفحة البيضاء ترمز للمعرفة الفطرية التي لا تحتاج لتجربة حسية.'
              ],
              'الجواب':
                  'ب. يعتقد أن العقل في البداية يكون كلوح نظيف وأن جميع المعارف تأتي من التجربة الحسية.',
            },
          ],
        },
      ],
    },
    {
      'title': 'في الأخلاق بين النسبي والمطلق',
      'cards': [
        {
          'title': 'الأخلاق بين النسبي والمطلق',
          'image': 'assets/images/lesson1.jpg',
          'questions': [
            {
              'السؤال': 'وفقًا لابن سينا، كيف وصف وظيفة الذاكرة؟',
              'خيارات': [
                'عملية تربط الماضي بالمستقبل',
                'خزان يتم فيه تجميع الذكريات',
                'جهاز معقد يعتمد على الإدراك',
                'خزان الجوهر الأخير في الدماغ'
              ],
              'الجواب': 'خزان الجوهر الأخير في الدماغ',
            },
          ],
        },
      ],
    },
  ];

  GuestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'صفحة الأنشطة (زائر)',
          textAlign: TextAlign.right,
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_background2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: limitedLessons
                .map((lesson) => buildHorizontalLessonList(
                    context,
                    lesson,
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildHorizontalLessonList(BuildContext context,
      Map<String, Object> lesson, double screenWidth, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lesson['title'] as String,
            style: TextStyle(
                fontSize: screenWidth * 0.07,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.right, // محاذاة النص إلى اليمين
          ),
          SizedBox(height: screenHeight * 0.005),
          SizedBox(
            height:
                MediaQuery.of(context).size.height * 0.30, // تعيين ارتفاع مناسب
            child: ListView.builder(
              reverse: true,
              scrollDirection: Axis.horizontal,
              itemCount: (lesson['cards'] as List).length,
              itemBuilder: (context, index) {
                final card =
                    (lesson['cards'] as List)[index] as Map<String, Object>;
                return buildCard(
                    context,
                    card['title'] as String,
                    card['image'] as String,
                    card['questions'] as List<Map<String, Object>>,
                    screenWidth,
                    screenHeight);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(
      BuildContext context,
      String cardTitle,
      String imagePath,
      List<Map<String, Object>> cardQuestions,
      double screenWidth,
      double screenHeight) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blueAccent,
            content: Text('عذرًا، لا يمكنك مشاهدة المحتوى كزائر.'),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.35, // تعيين عرض مناسب للبطاقة
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imagePath,
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height * 0.20,
                    width: MediaQuery.of(context).size.width * 1.0),
              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                cardTitle,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
