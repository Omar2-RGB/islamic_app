import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
import 'quran_provider.dart';
import 'package:islamic_app/core/services/tafsir_service.dart';

class SurahReadingScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> surahInfo;
  const SurahReadingScreen({super.key, required this.surahInfo});

  @override
  ConsumerState<SurahReadingScreen> createState() => _SurahReadingScreenState();
}

class _SurahReadingScreenState extends ConsumerState<SurahReadingScreen> {
  double _fontSize = 26.0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() => _isPlaying = false);
      } else {
        String surahNumber = widget.surahInfo['id'].toString().padLeft(3, '0');
        String url = "https://server8.mp3quran.net/afs/$surahNumber.mp3";
        await _audioPlayer.play(UrlSource(url));
        setState(() => _isPlaying = true);
      }
    } catch (e) {
      print("خطأ في تشغيل الصوت: $e");
    }
  }

  String _toArabicNumber(int number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String numStr = number.toString();
    for (int i = 0; i < english.length; i++) {
      numStr = numStr.replaceAll(english[i], arabic[i]);
    }
    return numStr;
  }

  void _showTafsirBottomSheet(BuildContext context, int suraId, dynamic ayah) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(color: Colors.teal),
      ),
    );

    String tafsirText = await TafsirService.getAyahTafsir(suraId, ayah.verse);

    if (mounted) {
      Navigator.pop(context); // إغلاق دائرة التحميل
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFFF9F4E8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "تفسير الآية (${_toArabicNumber(ayah.verse)}) - سورة ${widget.surahInfo['name']}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  ayah.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Uthmanic',
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
                const Divider(height: 25, thickness: 1),
                SingleChildScrollView(
                  child: Text(
                    tafsirText,
                    textAlign: TextAlign.justify,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إغلاق', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final surahId = widget.surahInfo['id'] as int;
    final versesAsync = ref.watch(surahVersesProvider(surahId));

    return Scaffold(
      backgroundColor: const Color(0xFFF9F4E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.teal),
          onPressed: () {
            _audioPlayer.stop();
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.surahInfo['name'],
          style: const TextStyle(fontFamily: 'Uthmanic', fontSize: 28, color: Colors.teal),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle : Icons.play_circle,
              color: Colors.teal,
              size: 30,
            ),
            onPressed: _togglePlayPause,
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.teal),
            onPressed: () => setState(() => _fontSize -= 2.0),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
            onPressed: () => setState(() => _fontSize += 2.0),
          ),
        ],
      ),
      body: versesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.teal)),
        error: (err, _) => Center(child: Text('خطأ: $err')),
        data: (verses) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (surahId != 1 && surahId != 9)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Text(
                    "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ",
                    style: TextStyle(fontFamily: 'Uthmanic', fontSize: 28, color: Colors.black87),
                  ),
                ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text.rich(
                  TextSpan(
                    children: verses.map((ayah) {
                      return TextSpan(
                        text: "${ayah.text} \uFD3F${_toArabicNumber(ayah.verse)}\uFD3E ",
                        style: TextStyle(
                          fontFamily: 'Uthmanic',
                          fontSize: _fontSize,
                          height: 2.8,
                          color: Colors.black87,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _showTafsirBottomSheet(context, surahId, ayah);
                          },
                      );
                    }).toList(),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}