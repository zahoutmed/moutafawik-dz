import 'package:flutter/material.dart';
import 'package:i_love_philosophy/utils/security_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class VideoDetailScreen extends StatefulWidget {
  final Map<String, dynamic> video;

  const VideoDetailScreen({required this.video, super.key});

  @override
  VideoDetailScreenState createState() => VideoDetailScreenState();
}

class VideoDetailScreenState extends State<VideoDetailScreen> {
  VideoPlayerController? _videoController;
  bool isAsset = false;

  @override
  void initState() {
    super.initState();
    final String url = (widget.video['url'] ?? widget.video['videoUrl'] ?? '').toString().trim();
    isAsset = url.startsWith('assets/videos/');
    final isDirectMp4 = url.toLowerCase().endsWith('.mp4');
    if (isAsset) {
      _videoController = VideoPlayerController.asset(url)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
          }
        });
    } else if (isDirectMp4 && (url.startsWith('https://') || url.startsWith('http://'))) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
          }
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _launchSafeURL(String url) async {
    if (!SecurityUtils.isSafeExternalUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('الرابط غير صالح أو غير متوفر.')),
        );
      }
      return;
    }
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تعذر فتح الفيديو الخارجي.')),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح الفيديو الخارجي.')),
        );
      }
    }
  }

  Future<void> _showVideoDialog(BuildContext context) async {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return;
    }
    return showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            insetPadding: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          _videoController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            if (_videoController!.value.isPlaying) {
                              _videoController!.pause();
                            } else {
                              _videoController!.play();
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 30),
                        onPressed: () {
                          _videoController!.pause();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final title = (widget.video['title'] ?? 'تفاصيل الشرح المرئي').toString();
    final author = (widget.video['author'] ?? '').toString();
    final desc = (widget.video['desc'] ?? '').toString();
    final duration = (widget.video['duration'] ?? '').toString();
    final image =
        (widget.video['image'] ?? 'assets/images/video_list.jpg').toString();
    final List<dynamic> stepsRaw =
        widget.video['steps'] is List ? widget.video['steps'] : [];
    final steps = stepsRaw.map((e) => e.toString()).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background1.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      image,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.ondemand_video_rounded,
                        size: 90,
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
                        const SizedBox(height: 6),
                        if (author.isNotEmpty || duration.isNotEmpty)
                          Text(
                            '${author.isNotEmpty ? 'إعداد: $author' : ''}${duration.isNotEmpty ? ' • $duration' : ''}',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (desc.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            desc,
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 17,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                        if (steps.isNotEmpty) ...[
                          const Divider(height: 22),
                          const Text(
                            'خطوات الشرح والتطبيق المنهجي:',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...List.generate(steps.length, (i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 13,
                                    backgroundColor: Colors.deepPurple,
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      steps[i],
                                      style: const TextStyle(
                                        fontFamily: 'Amiri',
                                        fontSize: 17,
                                        height: 1.5,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                ),
                if (isAsset || _videoController != null || (widget.video['url'] ?? widget.video['videoUrl'] ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      final activeUrl = (widget.video['url'] ?? widget.video['videoUrl'] ?? '').toString().trim();
                      if (_videoController != null && _videoController!.value.isInitialized) {
                        _showVideoDialog(context);
                      } else if (activeUrl.isNotEmpty) {
                        _launchSafeURL(activeUrl);
                      }
                    },
                    icon: const Icon(Icons.play_circle_fill),
                    label: Text(
                      (_videoController != null && _videoController!.value.isInitialized)
                          ? 'تشغيل الفيديو داخل التطبيق'
                          : 'مشاهدة الفيديو التعليمي',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
