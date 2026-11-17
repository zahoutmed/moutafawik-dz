import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewScreen extends StatefulWidget {
  final String pdfPath;
  final Uint8List? pdfBytes;
  final String title;

  const PDFViewScreen({
    super.key,
    this.pdfPath = '',
    this.pdfBytes,
    this.title = 'عارض الوثائق والكتب PDF',
  });

  @override
  State<PDFViewScreen> createState() => _PDFViewScreenState();
}

class _PDFViewScreenState extends State<PDFViewScreen> {
  final PdfViewerController _controller = PdfViewerController();
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final path = widget.pdfPath.trim();
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');
    final isAsset = path.isNotEmpty && !isNetwork && path.endsWith('.pdf');
    final hasMemory = widget.pdfBytes != null && widget.pdfBytes!.isNotEmpty;

    Widget body;
    if (hasMemory) {
      body = SfPdfViewer.memory(
        widget.pdfBytes!,
        controller: _controller,
        onDocumentLoaded: (details) {
          if (mounted) {
            setState(() => _totalPages = details.document.pages.count);
          }
        },
        onPageChanged: (details) {
          if (mounted) {
            setState(() => _currentPage = details.newPageNumber);
          }
        },
      );
    } else if (isNetwork) {
      body = SfPdfViewer.network(
        path,
        controller: _controller,
        onDocumentLoaded: (details) {
          if (mounted) {
            setState(() => _totalPages = details.document.pages.count);
          }
        },
        onPageChanged: (details) {
          if (mounted) {
            setState(() => _currentPage = details.newPageNumber);
          }
        },
        onDocumentLoadFailed: (details) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تعذر تحميل ملف PDF من الشبكة: ${details.description}')),
            );
          }
        },
      );
    } else if (isAsset) {
      body = SfPdfViewer.asset(
        path,
        controller: _controller,
        onDocumentLoaded: (details) {
          if (mounted) {
            setState(() => _totalPages = details.document.pages.count);
          }
        },
        onPageChanged: (details) {
          if (mounted) {
            setState(() => _currentPage = details.newPageNumber);
          }
        },
        onDocumentLoadFailed: (details) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تعذر تحميل الملف: ${details.description}')),
            );
          }
        },
      );
    } else {
      body = const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'ملف PDF غير متوفر حالياً. يمكنك مطالعة الشرح المفصل والتمارين من شاشة الدرس.',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Cairo', fontSize: 16, color: Colors.black87),
          ),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: const Color(0xFF3F1D77),
          foregroundColor: Colors.white,
          actions: [
            if (_totalPages > 0)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$_currentPage / $_totalPages',
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.zoom_in),
              tooltip: 'تكبير',
              onPressed: () => _controller.zoomLevel = (_controller.zoomLevel + 0.25).clamp(1.0, 3.0),
            ),
            IconButton(
              icon: const Icon(Icons.zoom_out),
              tooltip: 'تصغير',
              onPressed: () => _controller.zoomLevel = (_controller.zoomLevel - 0.25).clamp(1.0, 3.0),
            ),
          ],
        ),
        body: body,
        bottomNavigationBar: _totalPages > 1
            ? Container(
                color: const Color(0xFF2E1254),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _currentPage > 1 ? () => _controller.previousPage() : null,
                      icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.white),
                      label: const Text('الصفحة السابقة', style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
                    ),
                    TextButton.icon(
                      onPressed: _currentPage < _totalPages ? () => _controller.nextPage() : null,
                      icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.amberAccent),
                      label: const Text('الصفحة التالية', style: TextStyle(fontFamily: 'Cairo', color: Colors.amberAccent)),
                    ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
