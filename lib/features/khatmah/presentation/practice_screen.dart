import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 💡 تصحيح مسار استيراد ملف الـ provider بناءً على هيكلة المجلدات لديك
import '../../quran/presentation/quran_provider.dart'; 

class PracticeScreen extends ConsumerWidget {
  final Map<String, dynamic> surahInfo;
  
  const PracticeScreen({super.key, required this.surahInfo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color bgColor = const Color(0xFF0D1818);
    final Color goldColor = const Color(0xFFD4AF37);
    
    final surahId = surahInfo['id'] as int;
    final versesAsync = ref.watch(surahVersesProvider(surahId));

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "تسميع: ${surahInfo['name']}",
          style: TextStyle(fontFamily: 'Uthmanic', color: goldColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: versesAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: goldColor)),
        error: (err, _) => Center(child: Text('خطأ: $err', style: const TextStyle(color: Colors.red))),
        data: (verses) => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: verses.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: AyahQuizCard(ayahText: verses[index].text),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// ويدجت إخفاء وإظهار الآيات للاختبار
// ---------------------------------------------------------
class AyahQuizCard extends StatefulWidget {
  final String ayahText;
  const AyahQuizCard({super.key, required this.ayahText});

  @override
  State<AyahQuizCard> createState() => _AyahQuizCardState();
}

class _AyahQuizCardState extends State<AyahQuizCard> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    final cardColor = const Color(0xFF162224);
    final goldColor = const Color(0xFFD4AF37);

    return GestureDetector(
      onTap: () {
        setState(() {
          _isHidden = !_isHidden;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: goldColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              _isHidden ? "اضغط هنا لاختبار حفظ الآية (انقر لإظهارها)" : widget.ayahText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Uthmanic',
                color: _isHidden ? Colors.grey.shade500 : Colors.white,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isHidden ? Icons.visibility_off : Icons.visibility,
                  color: goldColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _isHidden ? "الآية مخفية" : "الآية ظاهرة",
                  style: TextStyle(color: goldColor, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}