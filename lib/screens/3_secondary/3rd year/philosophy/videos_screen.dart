import 'package:flutter/material.dart';
import 'package:i_love_philosophy/data/multimedia_catalog_data.dart';
import 'package:i_love_philosophy/data/secondary_data.dart';
import 'package:i_love_philosophy/models/education_models.dart';
import 'package:i_love_philosophy/screens/3_secondary/3rd year/philosophy/video_detail_screen.dart';
import 'package:i_love_philosophy/screens/outils/custom_drawer.dart';
import 'package:i_love_philosophy/widgets/app_bottom_nav_bar.dart';
import 'package:i_love_philosophy/utils/responsive_ui.dart';

class VideosScreen extends StatefulWidget {
  final SubjectProgram? program;

  const VideosScreen({super.key, this.program});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  late SubjectProgram _activeProgram;
  String _selectedStageFilter = 'الكل (52 فيديو)';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _activeProgram = widget.program ?? SecondaryData.programs.first;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUI.fontBasis(context);

    // جلب الشروحات المرئية من الكاتلوج الشامل (52+ فيديو مقسم ومفصل)
    List<MediaItemData> baseItems;
    if (_selectedStageFilter.contains('الكل')) {
      baseItems = MultimediaCatalogData.allVideos;
    } else if (_selectedStageFilter.contains('ثانوي')) {
      baseItems = MultimediaCatalogData.getVideosForStage('ثانوي');
    } else if (_selectedStageFilter.contains('متوسط')) {
      baseItems = MultimediaCatalogData.getVideosForStage('متوسط');
    } else {
      baseItems = MultimediaCatalogData.getVideosForStage('ابتدائي');
    }

    final items = baseItems.where((v) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return v.title.toLowerCase().contains(q) ||
          v.section.toLowerCase().contains(q) ||
          v.summary.toLowerCase().contains(q) ||
          v.presenter.toLowerCase().contains(q);
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(
            '🎬 الفضاء السمعي البصري (52+ فيديو)',
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
              image: AssetImage('assets/images/video_list.jpg'),
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
                      'الكل (52 فيديو)',
                      'التعليم الثانوي (25)',
                      'التعليم المتوسط (15)',
                      'الابتدائي والتحضيري (12)',
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
                          selectedColor: Colors.red.shade700,
                          checkmarkColor: Colors.white,
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
                          hintText: 'ابحث في الشروحات: بالعنوان، الأستاذ، أو المحور...',
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
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${items.length} درس مرئي',
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red.shade700),
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
                            'لا توجد شروحات مرئية متوفرة حالياً بالبحث المحدد.',
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
                                      builder: (_) => VideoDetailScreen(
                                        video: {
                                          'title': item.title,
                                          'desc': item.summary,
                                          'image': item.image,
                                          'url': (item.videoUrl?.isNotEmpty == true ? item.videoUrl : item.localVideoAsset) ?? '',
                                          'steps': item.steps,
                                          'presenter': item.presenter,
                                          'duration': item.duration,
                                          'section': item.section,
                                        },
                                      ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.asset(
                                            item.image,
                                            width: 80,
                                            height: 65,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              width: 80,
                                              height: 65,
                                              color: Colors.red.shade50,
                                              child: const Icon(Icons.video_library, size: 30, color: Colors.red),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.play_arrow, size: 20, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade50,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              item.section,
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red.shade800,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 3),
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
                                          const SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Icon(Icons.person, size: 12, color: Colors.grey.shade600),
                                              const SizedBox(width: 3),
                                              Text(
                                                item.presenter,
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 10.5,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                              const Spacer(),
                                              Icon(Icons.access_time, size: 12, color: Colors.grey.shade600),
                                              const SizedBox(width: 3),
                                              Text(
                                                item.duration,
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  fontSize: 10.5,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
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
          currentIndex: 4,
          currentProgram: _activeProgram,
        ),
      ),
    );
  }
}
