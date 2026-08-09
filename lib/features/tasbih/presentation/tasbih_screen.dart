import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  String _selectedDhikr = "سُبْحَانَ اللَّهِ";
final List<String> _dhikrList = [
    "سُبْحَانَ اللَّهِ",
    "الْحَمْدُ لِلَّهِ",
    "لَا إِلَهَ إِلَّا اللَّهُ",
    "اللَّهُ أَكْبَرُ",
    "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
    "سُبْحَانَ اللَّهِ الْعَظِيمِ",
    "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ",
    "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
    // أضفنا هنا صيغ الصلاة على النبي:
    "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ",
    "صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ",
    "لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ",
    "رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ"
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
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text('المسبحة الإلكترونية', style: TextStyle(fontFamily: 'Uthmanic', color: Colors.teal)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.teal),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: DropdownButton<String>(
                value: _selectedDhikr,
                isExpanded: true,
                underline: const SizedBox(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal, fontFamily: 'Uthmanic'),
                items: _dhikrList.map((String dhikr) {
                  return DropdownMenuItem<String>(
                    value: dhikr,
                    child: Text(dhikr, textAlign: TextAlign.center),
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
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Uthmanic', color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // عداد التسبيح الكبير
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 40),

            // زر العد الكبير وزر إعادة التعيين
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _resetCounter,
                  backgroundColor: Colors.red.shade100,
                  child: const Icon(Icons.refresh, color: Colors.red, size: 30),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 130,
                  height: 130,
                  child: FloatingActionButton.large(
                    onPressed: _incrementCounter,
                    backgroundColor: Colors.teal,
                    child: const Icon(Icons.touch_app, size: 60, color: Colors.white),
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