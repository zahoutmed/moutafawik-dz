import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:i_love_philosophy/data/commercial_services_data.dart';
import 'package:i_love_philosophy/models/education_models.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';

class MentorshipRequestScreen extends StatefulWidget {
  const MentorshipRequestScreen({super.key});

  @override
  State<MentorshipRequestScreen> createState() => _MentorshipRequestScreenState();
}

class _MentorshipRequestScreenState extends State<MentorshipRequestScreen> {
  final _parentNameCtrl = TextEditingController();
  final _studentNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _wilayaCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _selectedStage = 'التعليم الثانوي';
  final String _selectedLevel = 'السنة الثالثة ثانوي (BAC)';
  bool _allSubjects = false;
  final List<String> _selectedSubjects = [];

  final List<String> _availableSubjects = [
    'الرياضيات',
    'العلوم الفيزيائية',
    'علوم الطبيعة والحياة',
    'اللغة العربية',
    'الفلسفة',
    'اللغة الإنجليزية',
    'اللغة الفرنسية',
    'التاريخ والجغرافيا',
    'العلوم الإسلامية',
    'المحاسبة والتسيير',
  ];

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  void _submitRequest() {
    if (_parentNameCtrl.text.trim().isEmpty || _phoneCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى ملء اسم الولي ورقم الهاتف على الأقل للتواصل.', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final newReq = MentorshipRequestData(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      parentName: _parentNameCtrl.text.trim(),
      studentName: _studentNameCtrl.text.trim().isEmpty ? 'التلميذ' : _studentNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      wilaya: _wilayaCtrl.text.trim(),
      stage: _selectedStage,
      gradeLevel: _selectedLevel,
      targetSubjects: _allSubjects ? ['جميع المواد المقررة'] : List.from(_selectedSubjects),
      notes: _notesCtrl.text.trim(),
      createdAt: DateTime.now(),
      status: 'قيد المراجعة واختيار المتابع',
    );

    CommercialServicesData.mentorshipRequests.insert(0, newReq);

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text('تم استلام طلبكم بنجاح', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: const Text(
            'شكراً لثقتكم بنا! ستقوم إدارة المنصة بدراسة مستوى ابنكم واختيار الأستاذ أو المتابع البيداغوجي الأنسب وفق المعايير المطلوبة، وسنتواصل معكم هاتفياً أو عبر واتساب لتأكيد البرنامج وخطة المتابعة.',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 13, height: 1.6),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(ctx);
                _parentNameCtrl.clear();
                _studentNameCtrl.clear();
                _phoneCtrl.clear();
                _notesCtrl.clear();
                setState(() {});
              },
              child: const Text('حسناً', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
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
            '👨‍🎓 خدمة المتابعة التربوية الخاصة بالأولياء',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15.5),
          ),
          backgroundColor: Colors.teal,
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
                  // بطاقة تقديم الخدمة ومزاياها
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade700, Colors.teal.shade900],
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
                            Icon(Icons.supervisor_account, color: Colors.amberAccent, size: 30),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'مرافقة ومتابعة بيداغوجية مستمرة لابنك',
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
                          'تتولى إدارة المنصة اختيار أفضل الأساتذة الأكفاء لمتابعة ابنك دورياً (في مادة واحدة أو في جميع المواد)، مع تنظيم جدول المذاكرة، تصحيح التمارين، وتقديم تقارير دورية للولي لمراقبة التطور.',
                          style: TextStyle(fontFamily: 'Amiri', fontSize: 15, color: Colors.white, height: 1.6),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.chat, size: 16, color: Colors.white),
                              label: const Text('استشارة الإدارة عبر واتساب', style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.white)),
                              backgroundColor: Colors.green.shade600,
                              onPressed: () => _launchUrl('https://wa.me/${CommercialServicesData.adminWhatsapp}?text=مرحباً، أود الاستفسار عن خدمة المتابعة التربوية لابني'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // نموذج طلب المتابعة
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
                          'استمارة حجز متابع دراسي لابنكم:',
                          style: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                        const SizedBox(height: 14),

                        _buildInput('اسم ولي الأمر:', 'الاسم واللقب', _parentNameCtrl),
                        _buildInput('اسم التلميذ / الطالب:', 'اسم الابن أو البنت', _studentNameCtrl),
                        _buildInput('رقم الهاتف للتواصل:', '05 / 06 / 07 ...', _phoneCtrl, TextInputType.phone),
                        _buildInput('الولاية والبلدية:', 'مثال: الجزائر - زرالدة', _wilayaCtrl),

                        const SizedBox(height: 8),
                        const Text('الطور التعليمي:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedStage,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            isDense: true,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'التعليم التحضيري', child: Text('التعليم التحضيري', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5))),
                            DropdownMenuItem(value: 'التعليم الابتدائي', child: Text('التعليم الابتدائي', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5))),
                            DropdownMenuItem(value: 'التعليم المتوسط', child: Text('التعليم المتوسط', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5))),
                            DropdownMenuItem(value: 'التعليم الثانوي', child: Text('التعليم الثانوي', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5))),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedStage = val);
                          },
                        ),

                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('المواد المراد متابعتها:', style: TextStyle(fontFamily: 'Cairo', fontSize: 12.5, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                Checkbox(
                                  value: _allSubjects,
                                  onChanged: (val) => setState(() => _allSubjects = val ?? false),
                                ),
                                const Text('كل المواد', style: TextStyle(fontFamily: 'Cairo', fontSize: 12)),
                              ],
                            ),
                          ],
                        ),

                        if (!_allSubjects) ...[
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: _availableSubjects.map((sub) {
                              final isSel = _selectedSubjects.contains(sub);
                              return FilterChip(
                                label: Text(sub, style: const TextStyle(fontFamily: 'Cairo', fontSize: 11)),
                                selected: isSel,
                                selectedColor: Colors.teal.shade100,
                                checkmarkColor: Colors.teal.shade800,
                                onSelected: (sel) {
                                  setState(() {
                                    if (sel) {
                                      _selectedSubjects.add(sub);
                                    } else {
                                      _selectedSubjects.remove(sub);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                        ],

                        _buildInput('ملاحظات إضافية أو نقاط الضعف التي تريد التركيز عليها:', 'اكتب أي تفاصيل بيداغوجية...', _notesCtrl, TextInputType.multiline, 3),

                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.send_rounded),
                            label: const Text('إرسال طلب المتابعة للإدارة', style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _submitRequest,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // الطلبات السابقة للمستخدم
                  if (CommercialServicesData.mentorshipRequests.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text('طلباتكم المسجلة سابقاً:', style: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    ...CommercialServicesData.mentorshipRequests.map((req) => _buildRequestCard(req)),
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

  Widget _buildRequestCard(MentorshipRequestData req) {
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
                Text(
                  'طلب متابعة: ${req.studentName}',
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    req.status,
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: Colors.amber.shade900, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'المستوى: ${req.stage} | المواد: ${req.targetSubjects.join(', ')}',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 11.5, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
