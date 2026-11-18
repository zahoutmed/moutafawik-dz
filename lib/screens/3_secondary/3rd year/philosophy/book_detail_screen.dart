import 'package:flutter/material.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/pdf_view_screen.dart';
import 'package:i_love_philosophy/screens/outils/study_progress_service.dart';
import 'package:i_love_philosophy/utils/lesson_pdf_generator.dart';
import 'package:i_love_philosophy/utils/security_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:i_love_philosophy/utils/responsive_ui.dart';

class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic> book;

  const BookDetailScreen({required this.book, super.key});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final StudyProgressService _progressService = StudyProgressService();

  Future<void> _launchSafeURL(BuildContext context, String url) async {
    if (!SecurityUtils.isSafeExternalUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرابط غير صالح أو غير آمن.')),
      );
      return;
    }
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تعذر فتح الرابط الخارجي.')),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح الرابط الخارجي.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUI.fontBasis(context);
    final title = (widget.book['title'] ?? 'تفاصيل المرجع').toString();
    final author = (widget.book['author'] ?? '').toString();
    final desc = (widget.book['desc'] ?? '').toString();
    final fullContent = (widget.book['fullContent'] ?? '').toString();
    final pdfPath = (widget.book['pdfPath'] ?? '').toString().trim();
    final url = (widget.book['url'] ?? '').toString().trim();
    final image =
        (widget.book['image'] ?? 'assets/images/book_cover.png').toString();

    final isFav = _progressService.isBookmarked(title);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: screenWidth * 0.042,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(isFav ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () {
                _progressService.toggleBookmark(title);
                setState(() {});
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/books-library.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(235),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      image,
                      height: 110,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.menu_book_rounded,
                        size: 80,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  elevation: 5,
                  color: Colors.white.withAlpha(245),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (author.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'المصدر / الإعداد: $author',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        if (desc.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            desc,
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 17,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                        if (fullContent.isNotEmpty) ...[
                          const Divider(height: 22),
                          const Text(
                            'المحتوى المعرفي الكامل (مخزن داخلياً):',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            fullContent,
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 18,
                              height: 1.7,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (pdfPath.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PDFViewScreen(pdfPath: pdfPath, title: title),
                        ),
                      );
                      return;
                    }
                    final bytes = await LessonPdfGenerator.buildLessonPdf(
                      title: title,
                      section: 'المكتبة الوطنية الشاملة',
                      audience: author.isNotEmpty ? author : 'جميع الأطوار',
                      duration: 'مرجع PDF',
                      summary: desc,
                      keyPoints: const [],
                      fullExplanation: fullContent,
                      detailedSections: const [],
                      examples: const [],
                      mindMapSummary: '',
                      reviewQuestions: const [],
                    );
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PDFViewScreen(pdfBytes: bytes, title: title),
                      ),
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  label: Text(
                    pdfPath.isNotEmpty ? 'قراءة الكتاب بصيغة PDF داخل التطبيق' : 'فتح المرجع بصيغة PDF متعددة الصفحات',
                    style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                if (url.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () => _launchSafeURL(context, url),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text(
                      'فتح المرجع / التحميل من المصدر الرسمي',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
