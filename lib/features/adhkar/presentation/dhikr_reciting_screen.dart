import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/adhkar_model.dart';

class DhikrRecitingScreen extends StatefulWidget {
  final DhikrCategory category;
  const DhikrRecitingScreen({super.key, required this.category});

  @override
  State<DhikrRecitingScreen> createState() => _DhikrRecitingScreenState();
}

class _DhikrRecitingScreenState extends State<DhikrRecitingScreen> {
  int _currentIndex = 0;
  int _currentCount = 0;

  // الألوان الداكنة الثابتة للتطبيق
  final Color bgColor = const Color(0xFF0D1818);
  final Color cardColor = const Color(0xFF162224);
  final Color goldColor = const Color(0xFFD4AF37);

  void _increment() {
    HapticFeedback.lightImpact();
    setState(() {
      _currentCount++;
      if (_currentCount >= widget.category.items[_currentIndex].count) {
        if (_currentIndex < widget.category.items.length - 1) {
          _currentIndex++;
          _currentCount = 0;
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: cardColor, // لون خلفية النافذة
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: goldColor.withOpacity(0.5)), // إطار ذهبي
              ),
              title: Text('أحسنت!', style: TextStyle(color: goldColor, fontWeight: FontWeight.bold)),
              content: const Text(
                'لقد أتممت أذكار هذه الفئة بنجاح، تقبل الله طاعتك.',
                style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('حسناً', style: TextStyle(color: goldColor, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dhikr = widget.category.items[_currentIndex];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          widget.category.category,
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
      // استخدام SingleChildScrollView لمنع الـ Overflow نهائياً
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'الذكر ${_currentIndex + 1} من ${widget.category.items.length}',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 20),
              
              Card(
                color: cardColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    dhikr.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22, 
                      height: 1.8, 
                      color: Colors.white, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Text(
                "العدد: $_currentCount / ${dhikr.count}",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: goldColor),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: 120,
                height: 120,
                child: FloatingActionButton.large(
                  onPressed: _increment,
                  backgroundColor: goldColor,
                  elevation: 0,
                  child: Icon(Icons.touch_app, size: 50, color: bgColor), // الأيقونة بلون الخلفية
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}