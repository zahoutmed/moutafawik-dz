import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/library_catalog_data.dart';
import 'package:i_love_philosophy/data/secondary_data.dart';
import 'package:i_love_philosophy/models/education_models.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/book_detail_screen.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';
import 'package:i_love_philosophy/utils/responsive_ui.dart';

class BooksScreen extends StatefulWidget {
  final SubjectProgram? program;

  const BooksScreen({super.key, this.program});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  late SubjectProgram _activeProgram;
  String _selectedStageFilter = 'الكل (100+)';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _activeProgram = widget.program ?? SecondaryData.programs.first;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUI.fontBasis(context);

    // جلب الكتب من المكتبة الشاملة (100+ كتاب رسمي وحولية)
    List<LibraryItemData> baseItems;
    if (_selectedStageFilter.contains('الكل')) {
      baseItems = LibraryCatalogData.allBooks;
    } else if (_selectedStageFilter.contains('ثانوي')) {
      baseItems = LibraryCatalogData.getBooksForStage('ثانوي');
    } else if (_selectedStageFilter.contains('متوسط')) {
      baseItems = LibraryCatalogData.getBooksForStage('متوسط');
    } else {
      baseItems = LibraryCatalogData.getBooksForStage('ابتدائي');
    }

    final items = baseItems.where((b) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return b.title.toLowerCase().contains(q) ||
          b.section.toLowerCase().contains(q) ||
          b.summary.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q) ||
          b.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(
            '📚 المكتبة الوطنية الشاملة (100+ كتاب)',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: screenWidth * 0.040,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        drawer: const CustomDrawer(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/books-library.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // شرائح تصفية الأطوار
              Container(
                color: Colors.white.withAlpha(240),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'الكل (100+)',
                      'التعليم الثانوي (50)',
                      'التعليم المتوسط (30)',
                      'الابتدائي والتحضيري (20)',
                    ].map((st) {
                      final isSel = _selectedStageFilter == st;
                      return Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: FilterChip(
                          label: Text(
                            st,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11.5,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                              color: isSel ? Colors.white : Colors.black87,
                            ),
                          ),
                          selected: isSel,
                          selectedColor: const Color(0xFF3F1D77),
                          checkmarkColor: Colors.amberAccent,
                          backgroundColor: Colors.grey.shade200,
                          onSelected: (val) {
                            if (val) setState(() => _selectedStageFilter = st);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // شريط البحث
              Container(
                color: Colors.white.withAlpha(235),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val.trim()),
                        decoration: InputDecoration(
                          hintText: 'ابحث في 100+ كتاب: بالاسم، المادة، أو المؤلف...',
                          hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
                          prefixIcon: const Icon(Icons.search, size: 20),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${items.length} مرجع',
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'لا توجد مراجع متوفرة حالياً بالبحث المحدد.',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(14),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.only(bottom: 12),
                            color: Colors.white.withAlpha(242),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BookDetailScreen(
                                      book: {
                                        'title': item.title,
                                        'author': item.author,
                                        'desc': item.summary,
                                        'fullContent': item.fullContent,
                                        'image': item.image,
                                        'pdfPath': item.pdfPath ?? '',
                                        'url': item.url ?? '',
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        item.image,
                                        width: 65,
                                        height: 85,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 65,
                                          height: 85,
                                          color: Colors.deepPurple.shade50,
                                          child: const Icon(Icons.book, size: 36, color: Colors.deepPurple),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple.shade50,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              item.section,
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepPurple.shade800,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item.title,
                                            style: const TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'المؤلف: ${item.author}',
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 11,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item.summary,
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 10.5,
                                              color: Colors.grey.shade600,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 3,
          currentProgram: _activeProgram,
        ),
      ),
    );
  }
}
