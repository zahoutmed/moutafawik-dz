import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:i_love_philosophy/data/commercial_services_data.dart';
import 'package:i_love_philosophy/models/education_models.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';

class TeacherCatalogScreen extends StatefulWidget {
  const TeacherCatalogScreen({super.key});

  @override
  State<TeacherCatalogScreen> createState() => _TeacherCatalogScreenState();
}

class _TeacherCatalogScreenState extends State<TeacherCatalogScreen> {
  String _selectedSubject = 'الكل';
  bool _onlyVolunteers = false;
  String _searchQuery = '';

  Future<void> _launchUrlHelper(String urlStr) async {
    try {
      final uri = Uri.parse(urlStr);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final teachers = CommercialServicesData.sampleTeachers;
    final subjects = ['الكل', ...teachers.map((t) => t.subject).toSet()];

    final filtered = teachers.where((t) {
      final matchesSub = _selectedSubject == 'الكل' || t.subject == _selectedSubject;
      final matchesVol = !_onlyVolunteers || t.isVolunteer;
      final matchesSearch = _searchQuery.isEmpty ||
          t.name.contains(_searchQuery) ||
          t.subject.contains(_searchQuery) ||
          t.wilaya.contains(_searchQuery);
      return matchesSub && matchesVol && matchesSearch;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '👨‍🏫 دليل الأساتذة المتخصصين والإعلانات',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.campaign_outlined),
              tooltip: 'حجز مساحة إعلانية',
              onPressed: () => _showBookingDialog(context),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_background2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // رأس الفلترة وشريط الإعلان
                Container(
                  color: Colors.white.withAlpha(245),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Column(
                    children: [
                      // زر إعلاني بارز للأساتذة لحجز مساحة
                      InkWell(
                        onTap: () => _showBookingDialog(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.indigo, Colors.deepPurple],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.workspace_premium, color: Colors.amberAccent, size: 26),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'هل أنت أستاذ أو مركز تدريب؟',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'احجز مساحتك الإشهارية وانضم لأكبر منصة تعليمية',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 11,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // حقل البحث
                      TextField(
                        onChanged: (val) => setState(() => _searchQuery = val.trim()),
                        decoration: InputDecoration(
                          hintText: 'ابحث باسم الأستاذ، المادة، أو الولاية...',
                          hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12.5),
                          prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.indigo.shade200),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // فلاتر المادة والتطوع
                      Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: subjects.map((sub) {
                                  final isSel = _selectedSubject == sub;
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: ChoiceChip(
                                      label: Text(
                                        sub,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 11.5,
                                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                          color: isSel ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                      selected: isSel,
                                      selectedColor: Colors.indigo,
                                      backgroundColor: Colors.grey.shade200,
                                      onSelected: (_) => setState(() => _selectedSubject = sub),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          FilterChip(
                            label: const Text('أعمال تطوعية', style: TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                            selected: _onlyVolunteers,
                            selectedColor: Colors.green.shade100,
                            checkmarkColor: Colors.green.shade800,
                            onSelected: (val) => setState(() => _onlyVolunteers = val),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // بطاقات الأساتذة
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(220),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'لا توجد نتائج مطابقة لبحثك في الكاتلوج.',
                              style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            return _buildTeacherCard(context, filtered[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildTeacherCard(BuildContext context, TeacherProfileData teacher) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Colors.white.withAlpha(250),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.indigo.shade50,
                  backgroundImage: AssetImage(teacher.avatar),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              teacher.name,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (teacher.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, color: Colors.blueAccent, size: 18),
                          ],
                        ],
                      ),
                      Text(
                        teacher.title,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: Colors.indigo.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              teacher.wilaya,
                              style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.grey.shade600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                          const SizedBox(width: 2),
                          Text(
                            '${teacher.rating}',
                            style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (teacher.isVolunteer) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.volunteer_activism, size: 14, color: Colors.green),
                    SizedBox(width: 6),
                    Text(
                      'يقدم مبادرات وتوجيهات تطوعية مجانية',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 10),
            Text(
              teacher.bio,
              style: const TextStyle(fontFamily: 'Amiri', fontSize: 14, color: Colors.black87, height: 1.5),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الخدمات والعروض المتاحة:',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    teacher.offers,
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, color: Colors.black87, height: 1.4),
                  ),
                ],
              ),
            ),
            const Divider(height: 22),
            // أزرار التواصل المباشر
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.phone, size: 16, color: Colors.white),
                  label: const Text('اتصال مباشر', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.white)),
                  backgroundColor: Colors.green.shade700,
                  onPressed: () => _launchUrlHelper('tel:${teacher.phone}'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.chat, size: 16, color: Colors.white),
                  label: const Text('واتساب', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.white)),
                  backgroundColor: const Color(0xFF25D366),
                  onPressed: () => _launchUrlHelper('https://wa.me/${teacher.whatsapp}'),
                ),
                if (teacher.telegram.isNotEmpty)
                  ActionChip(
                    avatar: const Icon(Icons.send, size: 16, color: Colors.white),
                    label: const Text('تيليغرام', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.white)),
                    backgroundColor: const Color(0xFF0088CC),
                    onPressed: () => _launchUrlHelper('https://t.me/${teacher.telegram}'),
                  ),
                if (teacher.email.isNotEmpty)
                  ActionChip(
                    avatar: const Icon(Icons.email, size: 16, color: Colors.white),
                    label: const Text('بريد', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.white)),
                    backgroundColor: Colors.blueGrey,
                    onPressed: () => _launchUrlHelper('mailto:${teacher.email}'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final wilayaCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 20,
            right: 20,
            top: 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.campaign, color: Colors.indigo, size: 28),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'حجز مساحة إشهارية كأستاذ معلن',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'انضم إلى نخبة الأساتذة في التطبيق لعرض دروسك، ملخصاتك، أو خدماتك التعليمية والتطوعية.',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),
                _buildField('الاسم واللقب:', 'أ. فلان الفلاني', nameCtrl),
                _buildField('المادة والطور:', 'مثل: الفلسفة - 3 ثانوي', subjectCtrl),
                _buildField('رقم الهاتف / الواتساب:', '05 / 06 / 07 ...', phoneCtrl, TextInputType.phone),
                _buildField('الولاية / مكان النشاط:', 'مثال: الجزائر العاصمة، سطيف...', wilayaCtrl),
                _buildField('تفاصيل العرض والمساحة المطلوبة:', 'دروس حضورية، دورات أونلاين، أعمال تطوعية...', notesCtrl, TextInputType.multiline, 3),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'تم إرسال طلبكم بنجاح! سيتواصل معكم فريق الإدارة خلال ساعات لتأكيد ونشر مساحتكم الإعلانية.',
                            style: TextStyle(fontFamily: 'Cairo'),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text('إرسال طلب الحجز للإدارة', style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton.icon(
                    icon: const Icon(Icons.chat, color: Colors.green),
                    label: const Text('تواصل فوري مع الإدارة عبر واتساب', style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: Colors.green)),
                    onPressed: () => _launchUrlHelper('https://wa.me/${CommercialServicesData.adminWhatsapp}?text=مرحباً، أود حجز مساحة إشهارية كأستاذ في التطبيق التعليمي'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController ctrl, [TextInputType type = TextInputType.text, int maxLines = 1]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            keyboardType: type,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
        ],
      ),
    );
  }
}
