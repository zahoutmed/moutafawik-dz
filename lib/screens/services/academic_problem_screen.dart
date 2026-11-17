import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:i_love_philosophy/data/commercial_services_data.dart';
import 'package:i_love_philosophy/models/education_models.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';

class AcademicProblemScreen extends StatefulWidget {
  const AcademicProblemScreen({super.key});

  @override
  State<AcademicProblemScreen> createState() => _AcademicProblemScreenState();
}

class _AcademicProblemScreenState extends State<AcademicProblemScreen> {
  String _requesterType = 'طالب';
  final _nameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _wilayaCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  String _selectedCategory = 'صعوبة استيعاب مادة معينة وتدني العلامات';
  String _urgencyTier = 'استشارة مستعجلة وخاصة (خلال 24 ساعة - خدمة ممتازة)';

  final List<String> _categories = [
    'صعوبة استيعاب مادة معينة وتدني العلامات',
    'منهجية حل المواضيع وصياغة المقالات (فلسفة، علوم، أدب)',
    'قلق ورهاب الامتحانات وضياع الوقت وتشتت الانتباه',
    'استشارة خاصة بولي الأمر (التعامل مع عناد الأبناء وضعف دافعيتهم)',
    'استشارة خاصة بالأساتذة (طرائق تدريس معاصرة وإدارة القسم)',
  ];

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  void _submitConsultation() {
    if (_nameCtrl.text.trim().isEmpty || _contactCtrl.text.trim().isEmpty || _descriptionCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى ملء الاسم، وسيلة الاتصال، وشرح المشكلة بدقة.', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final newConsultation = AcademicConsultationData(
      id: 'cons_${DateTime.now().millisecondsSinceEpoch}',
      requesterType: _requesterType,
      name: _nameCtrl.text.trim(),
      contact: _contactCtrl.text.trim(),
      wilaya: _wilayaCtrl.text.trim(),
      category: _selectedCategory,
      urgency: _urgencyTier,
      description: _descriptionCtrl.text.trim(),
      createdAt: DateTime.now(),
      status: 'قيد دراسة الأخصائي',
    );

    CommercialServicesData.consultations.insert(0, newConsultation);

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.health_and_safety, color: Colors.deepOrange, size: 28),
              SizedBox(width: 8),
              Text('تم تسجيل الاستشارة بنجاح', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: const Text(
            'تم إرسال مشكلتك إلى فريق الخبراء والمستشارين التربويين بالمنصة. سيقوم الأخصائي المعني بدراسة الحالة والتواصل معك هاتفياً أو عبر واتساب بالحل والبرنامج المخصص.',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.6),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(ctx);
                _nameCtrl.clear();
                _contactCtrl.clear();
                _descriptionCtrl.clear();
                setState(() {});
              },
              child: const Text('تم', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
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
            '💡 العيادة التربوية وحل الصعوبات والمشاكل',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15.5),
          ),
          backgroundColor: Colors.deepOrange.shade700,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_background2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // بطاقة تقديم الخدمة التخصصية
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.deepOrange.shade800, Colors.deepOrange.shade900],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.psychology, color: Colors.amberAccent, size: 30),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'حلول علمية وبيداغوجية للصعوبات الدراسية',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'قسم استشاري متخصص يستقبل صعوبات التلاميذ، انشغالات الأولياء، واستشارات الأساتذة. نوفر تشخيصاً دقيقاً لكل حالة مع خطة علاجية مخصصة بإشراف نخبة من المفتشين والأخصائيين النفسيين والتربويين.',
                          style: TextStyle(fontFamily: 'Amiri', fontSize: 15, color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.chat, size: 16, color: Colors.white),
                              label: const Text('تواصل فوري مع المستشار', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.white)),
                              backgroundColor: Colors.green.shade600,
                              onPressed: () => _launchUrl('https://wa.me/${CommercialServicesData.adminWhatsapp}?text=مرحباً، أود استشارة أخصائي المنصة لحل صعوبة دراسية'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // استمارة استقبال المشكلة
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(245),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'طرح المشكلة أو طلب الاستشارة:',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                        ),
                        const SizedBox(height: 12),

                        // من يطلب الاستشارة؟
                        const Text('صفة صاحب الطلب:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _buildRoleChip('طالب'),
                            const SizedBox(width: 8),
                            _buildRoleChip('ولي أمر'),
                            const SizedBox(width: 8),
                            _buildRoleChip('أستاذ / مربي'),
                          ],
                        ),

                        const SizedBox(height: 14),
                        _buildInput('الاسم واللقب:', 'اسم صاحب الطلب', _nameCtrl),
                        _buildInput('رقم الهاتف / وسيلة الاتصال:', '05 / 06 / 07 أو بريد إلكتروني', _contactCtrl, TextInputType.phone),
                        _buildInput('الولاية:', 'الولاية محل الإقامة', _wilayaCtrl),

                        const SizedBox(height: 10),
                        const Text('نوع الصعوبة أو المشكلة:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: _selectedCategory,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            isDense: true,
                          ),
                          items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11.5), overflow: TextOverflow.ellipsis))).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCategory = val);
                          },
                        ),

                        const SizedBox(height: 14),
                        const Text('سرعة الاستجابة والمستوى:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: _urgencyTier,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            isDense: true,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'استشارة مستعجلة وخاصة (خلال 24 ساعة - خدمة ممتازة)', child: Text('استشارة مستعجلة وخاصة (خلال 24 ساعة - خدمة ممتازة)', style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: Colors.deepOrange, fontWeight: FontWeight.bold))),
                            DropdownMenuItem(value: 'استشارة عادية مجانية (خلال 48 - 72 ساعة)', child: Text('استشارة عادية مجانية (خلال 48 - 72 ساعة)', style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5))),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _urgencyTier = val);
                          },
                        ),

                        const SizedBox(height: 14),
                        _buildInput('شرح المشكلة أو الصعوبة بالتفصيل:', 'اشرح طبيعة المشكلة، متى بدأت، والنتائج الحالية...', _descriptionCtrl, TextInputType.multiline, 4),

                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.send),
                            label: const Text('إرسال الاستشارة لفريق الخبراء', style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange.shade700,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _submitConsultation,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // الاستشارات السابقة
                  if (CommercialServicesData.consultations.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text('استشاراتك المرسلة:', style: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    ...CommercialServicesData.consultations.map((c) => _buildConsultationCard(c)),
                  ],
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    final isSel = _requesterType == role;
    return Expanded(
      child: ChoiceChip(
        label: Center(
          child: Text(
            role,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
              color: isSel ? Colors.white : Colors.black87,
            ),
          ),
        ),
        selected: isSel,
        selectedColor: Colors.deepOrange.shade700,
        backgroundColor: Colors.grey.shade200,
        onSelected: (_) => setState(() => _requesterType = role),
      ),
    );
  }

  Widget _buildInput(String label, String hint, TextEditingController ctrl, [TextInputType type = TextInputType.text, int lines = 1]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: ctrl,
            keyboardType: type,
            maxLines: lines,
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

  Widget _buildConsultationCard(AcademicConsultationData c) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    c.category,
                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    c.status,
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.blue.shade900, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'الطلب مقدم من: ${c.requesterType} (${c.name}) | ${c.urgency}',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
