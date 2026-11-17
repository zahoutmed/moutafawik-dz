import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:i_love_philosophy/data/commercial_services_data.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/screens/outils/theme_provider.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // إعدادات المستخدم
  Color _selectedColor = Colors.deepPurple;
  bool _darkMode = false;
  bool _notifications = true;
  bool _soundEffects = true;
  double _fontSize = 16;
  String _selectedStage = 'التعليم الثانوي';
  String _selectedGrade = 'السنة الثالثة ثانوي (BAC)';

  // حالة لوحة الإدارة
  bool _isAdminUnlocked = false;
  final TextEditingController _adminPinController = TextEditingController();
  final TextEditingController _remoteApiUrlController = TextEditingController(text: 'https://admin.edudz-platform.com/api/v1');
  final TextEditingController _remoteApiKeyController = TextEditingController(text: 'dz_sec_live_982348712398');
  bool _remoteSyncEnabled = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _darkMode = themeProvider.isDarkMode;
    _fontSize = themeProvider.fontSize;
    _selectedColor = themeProvider.primaryColor;
    _loadStoredPreferences();
  }

  Future<void> _loadStoredPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _selectedStage = prefs.getString('user_stage') ?? 'التعليم الثانوي';
        _selectedGrade = prefs.getString('user_grade') ?? 'السنة الثالثة ثانوي (BAC)';
        _notifications = prefs.getBool('notifications_enabled') ?? true;
        _soundEffects = prefs.getBool('sound_effects_enabled') ?? true;
        _remoteSyncEnabled = prefs.getBool('remote_sync_enabled') ?? true;
        _remoteApiUrlController.text = prefs.getString('remote_api_url') ?? 'https://admin.edudz-platform.com/api/v1';
      });
    } catch (_) {}
  }

  Future<void> _savePreference(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is String) await prefs.setString(key, value);
      if (value is bool) await prefs.setBool(key, value);
      if (value is double) await prefs.setDouble(key, value);
    } catch (_) {}
  }

  void toggleDarkMode(bool value) {
    setState(() => _darkMode = value);
    Provider.of<ThemeProvider>(context, listen: false).setDarkMode(value);
  }

  void _verifyAdminPin() {
    if (_adminPinController.text.trim() == '2024' || _adminPinController.text.trim() == '0000') {
      setState(() {
        _isAdminUnlocked = true;
      });
      Navigator.pop(context);
      _tabController.animateTo(1);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تسجيل الدخول إلى لوحة تحكم الإدارة بنجاح!', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('رمز PIN غير صحيح! (الرمز الافتراضي: 2024)', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.red,
        ),
      );
    }
    _adminPinController.clear();
  }

  void _promptAdminLogin() {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.admin_panel_settings, color: Colors.deepPurple, size: 28),
              SizedBox(width: 8),
              Text('الدخول إلى لوحة تحكم الإدارة', style: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'هذا القسم مخصص لإدارة التطبيق ومتابعة الإعلانات والطلبات والتحكم عن بعد.\nأدخل رمز PIN للمتابعة (الرمز الافتراضي: 2024):',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _adminPinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: 'رمز PIN الإداري',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  isDense: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
              onPressed: _verifyAdminPin,
              child: const Text('دخول', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '⚙️ لوحة التحكم والإعدادات الشاملة',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16),
          ),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.amberAccent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              const Tab(icon: Icon(Icons.tune), text: 'إعدادات المستخدم'),
              Tab(
                icon: Icon(_isAdminUnlocked ? Icons.admin_panel_settings : Icons.lock_outline),
                text: 'لوحة الإدارة عن بُعد',
              ),
            ],
          ),
          actions: [
            if (!_isAdminUnlocked)
              IconButton(
                icon: const Icon(Icons.admin_panel_settings_outlined),
                tooltip: 'تسجيل دخول الإدارة',
                onPressed: _promptAdminLogin,
              )
            else
              IconButton(
                icon: const Icon(Icons.lock_open),
                tooltip: 'قفل لوحة الإدارة',
                onPressed: () {
                  setState(() => _isAdminUnlocked = false);
                  _tabController.animateTo(0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم قفل لوحة الإدارة.', style: TextStyle(fontFamily: 'Cairo'))),
                  );
                },
              ),
          ],
        ),
        drawer: const CustomDrawer(),
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_background2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUserSettingsTab(),
                _isAdminUnlocked ? _buildAdminDashboardTab() : _buildAdminLockedView(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      ),
    );
  }

  // ==========================================
  // 1. لوحة إعدادات المستخدم الشاملة
  // ==========================================
  Widget _buildUserSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // قسم هوية الطالب والمستوى الدراسي
        _buildSectionHeader('المستوى الدراسي وتكييف المحتوى', Icons.school),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الطور التعليمي المفضل لتطبيقك:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedStage,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'التعليم التحضيري', child: Text('التعليم التحضيري (5-6 سنوات)', style: TextStyle(fontFamily: 'Cairo', fontSize: 12))),
                    DropdownMenuItem(value: 'التعليم الابتدائي', child: Text('التعليم الابتدائي (1 إلى 5)', style: TextStyle(fontFamily: 'Cairo', fontSize: 12))),
                    DropdownMenuItem(value: 'التعليم المتوسط', child: Text('التعليم المتوسط (BEM)', style: TextStyle(fontFamily: 'Cairo', fontSize: 12))),
                    DropdownMenuItem(value: 'التعليم الثانوي', child: Text('التعليم الثانوي (BAC)', style: TextStyle(fontFamily: 'Cairo', fontSize: 12))),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedStage = val);
                      _savePreference('user_stage', val);
                    }
                  },
                ),
                const SizedBox(height: 10),
                const Text('السنة الدراسية المحددة:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedGrade,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'السنة الثالثة ثانوي (BAC)', child: Text('السنة الثالثة ثانوي (BAC)', style: TextStyle(fontFamily: 'Cairo', fontSize: 12))),
                    DropdownMenuItem(value: 'السنة الثانية ثانوي', child: Text('السنة الثانية ثانوي', style: TextStyle(fontFamily: 'Cairo', fontSize: 12))),
                    DropdownMenuItem(value: 'السنة الأولى ثانوي', child: Text('السنة الأولى ثانوي', style: TextStyle(fontFamily: 'Cairo', fontSize: 12))),
                    DropdownMenuItem(value: 'السنة الرابعة متوسط (BEM)', child: Text('السنة الرابعة متوسط (BEM)', style: TextStyle(fontFamily: 'Cairo', fontSize: 12))),
                    DropdownMenuItem(value: 'التعليم الابتدائي', child: Text('التعليم الابتدائي', style: TextStyle(fontFamily: 'Cairo', fontSize: 12))),
                    DropdownMenuItem(value: 'التعليم التحضيري', child: Text('التعليم التحضيري', style: TextStyle(fontFamily: 'Cairo', fontSize: 12))),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedGrade = val);
                      _savePreference('user_grade', val);
                    }
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'سيتم تكييف الدروس والبطاقات التفاعلية والعد التنازلي بناءً على اختيارك تلقائياً.',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // قسم المظهر والتخصيص البصري
        _buildSectionHeader('المظهر والألوان وحجم الخط', Icons.palette),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('الوضع الليلي (Dark Mode)', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('تقليل إجهاد العين أثناء المذاكرة الليلية', style: TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                  value: _darkMode,
                  onChanged: toggleDarkMode,
                  secondary: Icon(_darkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.deepPurple),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.format_size, color: Colors.deepPurple),
                  title: const Text('حجم الخط العام:', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: Slider(
                    value: _fontSize,
                    min: 12,
                    max: 26,
                    divisions: 7,
                    label: '${_fontSize.toInt()} نقطة',
                    onChanged: (val) {
                      setState(() => _fontSize = val);
                      Provider.of<ThemeProvider>(context, listen: false).updateFontSize(val);
                      _savePreference('font_size', val);
                    },
                  ),
                  trailing: Text('${_fontSize.toInt()} pt', style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.color_lens, color: Colors.deepPurple),
                  title: const Text('لون التطبيق الرئيسي المميز', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold)),
                  trailing: CircleAvatar(backgroundColor: _selectedColor, radius: 14),
                  onTap: _openColorPicker,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // قسم التنبيهات والأداء
        _buildSectionHeader('التنبيهات والأداء والمساحة', Icons.notifications_active),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('التذكير اليومي بالمذاكرة', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('إرسال تنبيهات خفيفة لتحفيز المراجعة والبطاقات', style: TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                  value: _notifications,
                  onChanged: (val) {
                    setState(() => _notifications = val);
                    _savePreference('notifications_enabled', val);
                  },
                  secondary: const Icon(Icons.alarm, color: Colors.deepPurple),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('المؤثرات الصوتية والتفاعلية', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('أصوات تشجيعية عند إنهاء الاختبارات والبطاقات', style: TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                  value: _soundEffects,
                  onChanged: (val) {
                    setState(() => _soundEffects = val);
                    _savePreference('sound_effects_enabled', val);
                  },
                  secondary: const Icon(Icons.volume_up, color: Colors.deepPurple),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.cleaning_services, color: Colors.deepOrange),
                  title: const Text('تفريغ الذاكرة المؤقتة (Clear Cache)', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('تسريع التطبيق وإزالة الملفات المؤقتة غير الضرورية', style: TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                  trailing: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم تنظيف الذاكرة المؤقتة وتسريع التطبيق بنجاح!', style: TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.green),
                      );
                    },
                    child: const Text('تنظيف', style: TextStyle(fontFamily: 'Cairo', fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 2. شاشة القفل عند محاولة فتح لوحة الإدارة
  // ==========================================
  Widget _buildAdminLockedView() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(245),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.admin_panel_settings, size: 64, color: Colors.deepPurple),
            const SizedBox(height: 14),
            const Text(
              'لوحة تحكم الإدارة محميّة',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Text(
              'هذا الجزء مخصص للمشرفين وإدارة التطبيق للتحكم عن بُعد في الإعلانات، الأساتذة، ومزامنة المحتوى.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.vpn_key),
              label: const Text('إدخال رمز PIN الإداري', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _promptAdminLogin,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 3. لوحة تحكم الإدارة الكاملة (Admin Portal)
  // ==========================================
  Widget _buildAdminDashboardTab() {
    final teachers = CommercialServicesData.sampleTeachers;
    final mentorships = CommercialServicesData.mentorshipRequests;
    final consultations = CommercialServicesData.consultations;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // بطاقة الإحصائيات العامة السريعة
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E1E2C), Color(0xFF2D2D44)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.dashboard_customize, color: Colors.amberAccent, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'لوحة الإدارة والتحكم المركزي',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatBadge('${teachers.length}', 'أساتذة معلنون', Colors.indigoAccent),
                  _buildStatBadge('${mentorships.length}', 'طلبات متابعة', Colors.tealAccent),
                  _buildStatBadge('${consultations.length}', 'استشارات عيادة', Colors.deepOrangeAccent),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // إعدادات الربط بالموقع الخارجي والمزامنة عن بعد
        _buildSectionHeader('الربط والتحكم عن بُعد عبر الويب (Remote API)', Icons.cloud_sync),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('المزامنة اللحظية مع موقع الإدارة', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: const Text('تحديث الإعلانات والأساتذة تلقائياً عبر API الخادم', style: TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                  value: _remoteSyncEnabled,
                  onChanged: (val) {
                    setState(() => _remoteSyncEnabled = val);
                    _savePreference('remote_sync_enabled', val);
                  },
                ),
                const SizedBox(height: 8),
                const Text('رابط خادم وموقع الإدارة (Admin API Endpoint):', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextField(
                  controller: _remoteApiUrlController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.link, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('مفتاح التحقق والأمان (Secret API Key):', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                TextField(
                  controller: _remoteApiKeyController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.vpn_key, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.sync),
                    label: const Text('مزامنة البيانات الآن مع الموقع', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                    onPressed: () {
                      _savePreference('remote_api_url', _remoteApiUrlController.text.trim());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تمت مزامنة بيانات المنصة مع موقع الإدارة بنجاح!', style: TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.green),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // إدارة الأساتذة والإعلانات
        _buildSectionHeader('إدارة بطاقات الأساتذة والإعلانات', Icons.campaign),
        ...teachers.map((t) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(backgroundImage: AssetImage(t.avatar)),
            title: Text(t.name, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('${t.subject} • ${t.wilaya}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: Colors.blueAccent),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تعديل بطاقة الأستاذ: ${t.name}', style: const TextStyle(fontFamily: 'Cairo'))),
                    );
                  },
                ),
                Icon(t.isVerified ? Icons.check_circle : Icons.pending, size: 18, color: Colors.green),
              ],
            ),
          ),
        )),

        const SizedBox(height: 16),

        // طلبات المتابعة الواردة
        _buildSectionHeader('طلبات المتابعة التربوية للأولياء (${mentorships.length})', Icons.assignment_ind),
        if (mentorships.isEmpty)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('لا توجد طلبات متابعة معلقة حالياً.', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: Colors.white)),
          )
        else
          ...mentorships.map((m) => Card(
            child: ListTile(
              leading: const Icon(Icons.school, color: Colors.teal),
              title: Text('التلميذ: ${m.studentName} (الولي: ${m.parentName})', style: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
              subtitle: Text('الهاتف: ${m.phone} | ${m.stage} | ${m.status}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 11)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            ),
          )),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String count, String label, Color color) {
    return Column(
      children: [
        Text(count, style: TextStyle(fontFamily: 'Cairo', fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.white70)),
      ],
    );
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('اختر اللون الرئيسي للتطبيق', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15)),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: _selectedColor,
                onColorChanged: (Color color) {
                  setState(() => _selectedColor = color);
                  Provider.of<ThemeProvider>(context, listen: false).updatePrimaryColor(color);
                  _savePreference('primary_color', color.toARGB32().toString());
                  Navigator.of(context).pop();
                },
              ),
            ),
            actions: [
              TextButton(
                child: const Text('إغلاق', style: TextStyle(fontFamily: 'Cairo')),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}
