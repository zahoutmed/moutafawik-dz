import 'package:flutter/material.dart';
import 'package:i_love_philosophy/screens/0_preparatory/home_preparatory.dart';
import 'package:i_love_philosophy/screens/1_primary/home_primary.dart';
import 'package:i_love_philosophy/screens/2_middle/home_middle.dart';
import 'package:i_love_philosophy/screens/3_secondary/home_secondary.dart';
import 'package:i_love_philosophy/screens/shared/pedagogical_hub_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        elevation: 16,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        child: Column(
          children: [
            // ==========================================
            // رأس القائمة الجانبية (Header)
            // ==========================================
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 20, right: 16, left: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3F1D77), Color(0xFF673AB7), Color(0xFF1E88E5)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.amberAccent, width: 2.5),
                        ),
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.school_rounded,
                            size: 34,
                            color: Color(0xFF3F1D77),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        tooltip: 'إغلاق',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'المتفوّق الجزائري',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Moutafawik DZ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'المنصة الوطنية الشاملة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11.5,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ==========================================
            // عناصر القائمة المقسمة بوضوح (Items List)
            // ==========================================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildNavItem(
                    context: context,
                    icon: Icons.home_rounded,
                    title: 'الصفحة الرئيسية للمنصة',
                    route: '/home_screen',
                    accentColor: Colors.deepPurple,
                  ),

                  _buildCategoryDivider('🏫 الأطوار التعليمية'),
                  _buildSubNavItem(
                    context: context,
                    icon: Icons.auto_stories,
                    title: 'التعليم الثانوي (BAC - كل الشعب)',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeSecondary()));
                    },
                    color: Colors.indigo,
                  ),
                  _buildSubNavItem(
                    context: context,
                    icon: Icons.menu_book,
                    title: 'التعليم المتوسط (BEM - 1 إلى 4)',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeMiddle()));
                    },
                    color: Colors.teal,
                  ),
                  _buildSubNavItem(
                    context: context,
                    icon: Icons.backpack,
                    title: 'التعليم الابتدائي (تقييم المكتسبات 1-5)',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePrimary()));
                    },
                    color: Colors.deepOrange,
                  ),
                  _buildSubNavItem(
                    context: context,
                    icon: Icons.child_care,
                    title: 'التعليم التحضيري (5 - 6 سنوات)',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePreparatory()));
                    },
                    color: Colors.purple,
                  ),

                  _buildCategoryDivider('🏆 الامتحانات الرسمية والوسائط'),
                  _buildNavItem(
                    context: context,
                    icon: Icons.verified_rounded,
                    title: 'امتحانات BAC & BEM والتقييم الرسمي',
                    route: '/official_exams_screen',
                    accentColor: Colors.amber.shade800,
                    badgeText: 'رسمي',
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.local_library_rounded,
                    title: 'المكتبة الرقمية الشاملة (100+ كتاب)',
                    route: '/books_screen',
                    accentColor: Colors.deepPurple,
                    badgeText: '100+',
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.video_library_rounded,
                    title: 'الفضاء السمعي البصري (52+ فيديو)',
                    route: '/videos_screen',
                    accentColor: Colors.red.shade700,
                    badgeText: '50+',
                  ),

                  _buildCategoryDivider('🌟 الأقسام البيداغوجية المتخصصة'),
                  _buildSubNavItem(
                    context: context,
                    icon: Icons.hub_rounded,
                    title: 'الأقسام البيداغوجية والتفوق (المركز الشامل)',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PedagogicalHubScreen()));
                    },
                    color: Colors.purple,
                  ),
                  _buildSubNavItem(
                    context: context,
                    icon: Icons.sports_esports,
                    title: 'ألعاب تربوية وتحدي النقاط',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PedagogicalHubScreen(initialTabIndex: 0)));
                    },
                    color: Colors.green,
                  ),
                  _buildSubNavItem(
                    context: context,
                    icon: Icons.assignment_outlined,
                    title: 'المنهاج والتدرجات السنوية الوزارية',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PedagogicalHubScreen(initialTabIndex: 1)));
                    },
                    color: Colors.blue,
                  ),
                  _buildSubNavItem(
                    context: context,
                    icon: Icons.lightbulb_outline,
                    title: 'نصائح استراتيجية للتفوق',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PedagogicalHubScreen(initialTabIndex: 2)));
                    },
                    color: Colors.amber.shade900,
                  ),
                  _buildSubNavItem(
                    context: context,
                    icon: Icons.calendar_month,
                    title: 'جداول المراجعة الأسبوعية',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PedagogicalHubScreen(initialTabIndex: 3)));
                    },
                    color: Colors.teal,
                  ),
                  _buildSubNavItem(
                    context: context,
                    icon: Icons.history_edu,
                    title: 'مذكرات الأساتذة والتحضير البيداغوجي',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PedagogicalHubScreen(initialTabIndex: 4)));
                    },
                    color: Colors.indigo,
                  ),
                  _buildSubNavItem(
                    context: context,
                    icon: Icons.menu_book,
                    title: 'ملخصات الدروس والقوانين المركزة',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PedagogicalHubScreen(initialTabIndex: 5)));
                    },
                    color: Colors.deepOrange,
                  ),
                  _buildSubNavItem(
                    context: context,
                    icon: Icons.quiz_outlined,
                    title: 'بنك الأسئلة المتكررة في البكالوريا والبيام',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PedagogicalHubScreen(initialTabIndex: 6)));
                    },
                    color: Colors.pink,
                  ),
                  _buildSubNavItem(
                    context: context,
                    icon: Icons.auto_awesome,
                    title: 'متفرقات ومعارف عامة',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PedagogicalHubScreen(initialTabIndex: 7)));
                    },
                    color: Colors.brown,
                  ),

                  _buildCategoryDivider('🎯 أدوات التفوق الذكية'),
                  _buildNavItem(
                    context: context,
                    icon: Icons.timer_outlined,
                    title: 'العد التنازلي وبطاقات التكرار',
                    route: '/educational_enhancements_screen',
                    accentColor: Colors.blue.shade700,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.psychology_outlined,
                    title: 'رفيق التفوق والمنهجية الدراسية',
                    route: '/study_companion_screen',
                    accentColor: Colors.green.shade700,
                  ),

                  _buildCategoryDivider('💼 الخدمات والإعلانات التربوية'),
                  _buildNavItem(
                    context: context,
                    icon: Icons.person_search_rounded,
                    title: 'هل تبحث عن مدرس متخصص؟',
                    route: '/teacher_catalog_screen',
                    accentColor: Colors.deepOrange,
                    badgeText: 'إعلاني',
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.family_restroom_rounded,
                    title: 'هل تبحث عن متابع تربوي؟',
                    route: '/mentorship_request_screen',
                    accentColor: Colors.teal.shade700,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.health_and_safety_outlined,
                    title: 'عيادة حل الصعوبات والمشاكل الدراسية',
                    route: '/academic_problem_screen',
                    accentColor: Colors.pink.shade700,
                  ),

                  _buildCategoryDivider('⚙️ الحساب والتحكم'),
                  _buildNavItem(
                    context: context,
                    icon: Icons.account_circle_outlined,
                    title: 'الملف الشخصي للطالب',
                    route: '/user_preferences_screen',
                    accentColor: Colors.blueGrey,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'الإعدادات ولوحة تحكم الإدارة',
                    route: '/settings_screen',
                    accentColor: Colors.deepPurple,
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.info_outline,
                    title: 'من نحن والمشرف التربوي',
                    route: '/about_us_screen',
                    accentColor: Colors.grey.shade700,
                  ),
                ],
              ),
            ),

            // تذييل بسيط
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              color: isDark ? Colors.black26 : Colors.grey.shade100,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'إشراف: أ. زحوط محمد',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    'الإصدار 2.0 الوطني',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDivider(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 4, right: 16, left: 16),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required Color accentColor,
    String? badgeText,
  }) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
      leading: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: accentColor.withAlpha(25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: accentColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: badgeText != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: accentColor.withAlpha(30),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            )
          : const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
      onTap: () {
        Navigator.of(context).pop();
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }

  Widget _buildSubNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
      leading: Icon(icon, color: color, size: 18),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12.5,
        ),
      ),
      trailing: const Icon(Icons.chevron_left, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
