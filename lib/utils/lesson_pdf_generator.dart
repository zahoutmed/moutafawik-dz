import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// مولد وثائق PDF احترافية متعددة الصفحات للدرس باللغة العربية (RTL)
class LessonPdfGenerator {
  static Future<Uint8List> buildLessonPdf({
    required String title,
    required String section,
    required String audience,
    required String duration,
    required String summary,
    required List<String> keyPoints,
    required String fullExplanation,
    required List<Map<String, dynamic>> detailedSections,
    required List<String> examples,
    required String mindMapSummary,
    required List<String> reviewQuestions,
  }) async {
    final regularData = await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
    final boldData = await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
    final regularFont = pw.Font.ttf(regularData);
    final boldFont = pw.Font.ttf(boldData);

    final pdf = pw.Document();
    final theme = pw.ThemeData.withFont(base: regularFont, bold: boldFont);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: theme,
        margin: const pw.EdgeInsets.all(28),
        header: (ctx) => pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 8),
          margin: const pw.EdgeInsets.only(bottom: 12),
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.deepPurple, width: 1)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('منصة المتفوّق الجزائري', style: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.deepPurple)),
              pw.Expanded(
                child: pw.Text(
                  section,
                  textAlign: pw.TextAlign.left,
                  style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                ),
              ),
            ],
          ),
        ),
        footer: (ctx) => pw.Container(
          alignment: pw.Alignment.centerLeft,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'صفحة ${ctx.pageNumber} من ${ctx.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ),
        build: (ctx) => [
          // ترويسة الدرس
          pw.Container(
            padding: const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(
              color: PdfColors.deepPurple50,
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.deepPurple200),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(title, style: pw.TextStyle(font: boldFont, fontSize: 16, color: PdfColors.deepPurple900)),
                pw.SizedBox(height: 6),
                pw.Text('المستوى: $audience   •   المدة المقترحة: $duration',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.deepPurple700)),
                if (summary.isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  pw.Text(summary, style: const pw.TextStyle(fontSize: 11, lineSpacing: 3)),
                ],
              ],
            ),
          ),
          pw.SizedBox(height: 14),

          // الأهداف والنقاط الأساسية
          if (keyPoints.isNotEmpty) ...[
            pw.Text('1. الكفاءات والنقاط الجوهرية للدرس',
                style: pw.TextStyle(font: boldFont, fontSize: 13, color: PdfColors.deepPurple)),
            pw.SizedBox(height: 6),
            ...keyPoints.map(
              (kp) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Text('• $kp', style: const pw.TextStyle(fontSize: 11, lineSpacing: 3)),
              ),
            ),
            pw.SizedBox(height: 12),
          ],

          // الشرح المفصل
          if (fullExplanation.isNotEmpty) ...[
            pw.Text('2. الشرح المفصل والبناء المعرفي',
                style: pw.TextStyle(font: boldFont, fontSize: 13, color: PdfColors.deepPurple)),
            pw.SizedBox(height: 6),
            ...fullExplanation.split('\n').where((l) => l.trim().isNotEmpty).map(
                  (line) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 5),
                    child: pw.Text(
                      line.trim(),
                      style: pw.TextStyle(
                        font: line.trim().startsWith('■') ? boldFont : regularFont,
                        fontSize: line.trim().startsWith('■') ? 12 : 11,
                        color: line.trim().startsWith('■') ? PdfColors.indigo900 : PdfColors.black,
                        lineSpacing: 3.5,
                      ),
                    ),
                  ),
                ),
            pw.SizedBox(height: 12),
          ],

          // الأقسام الفرعية
          if (detailedSections.isNotEmpty) ...[
            pw.Text('3. المحاور التفصيلية',
                style: pw.TextStyle(font: boldFont, fontSize: 13, color: PdfColors.deepPurple)),
            pw.SizedBox(height: 6),
            ...detailedSections.map((sec) {
              final sTitle = (sec['title'] ?? '').toString();
              final sContent = (sec['content'] ?? '').toString();
              final bullets = (sec['bulletPoints'] is List)
                  ? List<String>.from((sec['bulletPoints'] as List).map((e) => e.toString()))
                  : <String>[];
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (sTitle.isNotEmpty)
                      pw.Text(sTitle, style: pw.TextStyle(font: boldFont, fontSize: 11.5, color: PdfColors.teal900)),
                    if (sContent.isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(sContent, style: const pw.TextStyle(fontSize: 10.5, lineSpacing: 3)),
                    ],
                    ...bullets.map((b) => pw.Text('  - $b', style: const pw.TextStyle(fontSize: 10, lineSpacing: 2.5))),
                  ],
                ),
              );
            }),
            pw.SizedBox(height: 10),
          ],

          // الأمثلة المحلولة
          if (examples.isNotEmpty) ...[
            pw.Text('4. الأمثلة المحلولة والنماذج التطبيقية',
                style: pw.TextStyle(font: boldFont, fontSize: 13, color: PdfColors.deepPurple)),
            pw.SizedBox(height: 6),
            ...examples.asMap().entries.map(
                  (e) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.amber50,
                      borderRadius: pw.BorderRadius.circular(6),
                      border: pw.Border.all(color: PdfColors.amber200),
                    ),
                    child: pw.Text('مثال ${e.key + 1}: ${e.value}',
                        style: const pw.TextStyle(fontSize: 10.5, lineSpacing: 3)),
                  ),
                ),
            pw.SizedBox(height: 10),
          ],

          // المخطط الذهني
          if (mindMapSummary.isNotEmpty) ...[
            pw.Text('5. المخطط الذهني والخلاصة',
                style: pw.TextStyle(font: boldFont, fontSize: 13, color: PdfColors.deepPurple)),
            pw.SizedBox(height: 6),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.teal50,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(mindMapSummary, style: const pw.TextStyle(fontSize: 10.5, lineSpacing: 3)),
            ),
            pw.SizedBox(height: 12),
          ],

          // التمارين والوضعيات الإدماجية
          if (reviewQuestions.isNotEmpty) ...[
            pw.Text('6. التمارين والتطبيقات والوضعية الإدماجية',
                style: pw.TextStyle(font: boldFont, fontSize: 13, color: PdfColors.deepPurple)),
            pw.SizedBox(height: 6),
            ...reviewQuestions.asMap().entries.map(
                  (q) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 6),
                    child: pw.Text('${q.key + 1}. ${q.value}',
                        style: const pw.TextStyle(fontSize: 10.5, lineSpacing: 3)),
                  ),
                ),
          ],
        ],
      ),
    );

    return pdf.save();
  }
}
