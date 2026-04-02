import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WatchInterview extends StatefulWidget {
  @override
  WatchInterviewState createState() => WatchInterviewState();
}

class WatchInterviewState extends State<WatchInterview> {

  final List<Map<String, String>> videos = [
    {
      "title": "Tell Me About Yourself - Best Sample Answer",
      "videoId": "dQw4w9WgXcQ",
    },
    {
      "title": "Top 10 Technical Interview Questions",
      "videoId": "8hly31xKli0",
    },
    {
      "title": "Behavioral Interview Tips",
      "videoId": "HG68Ymazo18",
    },
    {
      "title": "Crack Any Job Interview",
      "videoId": "1mHjMNZZvFo",
    },
    {
      "title": "Body Language in Interviews",
      "videoId": "ZZZ7k8cMA-4",
    },
  ];

  YoutubePlayerController? _controller;
  String? _currentVideoId;

  void _playVideo(String videoId) {
    // Dispose previous controller if exists
    _controller?.dispose();

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    setState(() {
      _currentVideoId = videoId;
    });
  }

  Widget _videoCard(Map<String, String> video) {
    final bool isPlaying = _currentVideoId == video["videoId"];

    return GestureDetector(
      onTap: () {
        if (!isPlaying) {
          _playVideo(video["videoId"]!);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF111318),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Thumbnail OR Player (Same Container)
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
              child: isPlaying && _controller != null
                  ? YoutubePlayer(
                controller: _controller!,
                showVideoProgressIndicator: true,
              )
                  : Stack(
                children: [
                  Image.network(
                    "https://img.youtube.com/vi/${video["videoId"]}/0.jpg",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.6),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                video["title"]!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D10),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Back Button
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1A1D24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Watch & Learn",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Tap any video to start practicing like a pro.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    return _videoCard(videos[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
