import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  String _selectedDhikr = "سُبْحَانَ اللَّهِ";

  // الألوان الداكنة الثابتة للتطبيق
  final Color bgColor = const Color(0xFF0D1818);
  final Color cardColor = const Color(0xFF162224);
  final Color goldColor = const Color(0xFFD4AF37);

  // قائمة مكبرة وشاملة للأذكار والتسبيحات
  final List<String> _dhikrList = [
    "سُبْحَانَ اللَّهِ",
    "الْحَمْدُ لِلَّهِ",
    "لَا إِلَهَ إِلَّا اللَّهُ",
    "اللَّهُ أَكْبَرُ",
    "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
    "سُبْحَانَ اللَّهِ الْعَظِيمِ",
    "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ",
    "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ",
    "أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيَّ الْقَيُّومَ وَأَتُوبُ إِلَيْهِ",
    "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
    "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ",
    "صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ",
    "لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ",
    "حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ",
    "رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ",
    "اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي",
    "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ",
    "رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ نَبِيًّا"
  ];

  void _incrementCounter() {
    HapticFeedback.mediumImpact(); // اهتزاز خفيف عند الضغط
    setState(() {
      _counter++;
    });
  }

  void _resetCounter() {
    HapticFeedback.heavyImpact();
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('المسبحة الإلكترونية', style: TextStyle(fontFamily: 'Uthmanic', color: goldColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // اختيار الذكر
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: goldColor.withOpacity(0.5)),
              ),
              child: DropdownButton<String>(
                value: _selectedDhikr,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: cardColor, // لون خلفية القائمة المنسدلة
                icon: Icon(Icons.keyboard_arrow_down, color: goldColor),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Uthmanic'),
                items: _dhikrList.map((String dhikr) {
                  return DropdownMenuItem<String>(
                    value: dhikr,
                    child: Text(
                      dhikr, 
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2, // للسماح بعرض الأذكار الطويلة
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDhikr = newValue!;
                    _counter = 0; // إعادة العداد عند تغيير الذكر
                  });
                },
              ),
            ),
            const SizedBox(height: 40),

            // عرض الذكر الحالي بخط جميل
            Text(
              _selectedDhikr,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Uthmanic', color: goldColor, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // عداد التسبيح الكبير
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 50),

            // زر العد الكبير وزر إعادة التعيين
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'reset_button', // لتجنب مشاكل الأنيميشن (Hero Tag)
                  onPressed: _resetCounter,
                  backgroundColor: cardColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.red.withOpacity(0.5)),
                  ),
                  child: const Icon(Icons.refresh, color: Colors.redAccent, size: 28),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 140,
                  height: 140,
                  child: FloatingActionButton.large(
                    heroTag: 'increment_button', // لتجنب مشاكل الأنيميشن (Hero Tag)
                    onPressed: _incrementCounter,
                    backgroundColor: goldColor,
                    child: Icon(Icons.touch_app, size: 60, color: bgColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}