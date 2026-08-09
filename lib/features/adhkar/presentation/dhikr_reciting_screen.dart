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
            builder: (context) => AlertDialog(
              title: const Text('أحسنت!'),
              content: const Text('لقد أتممت أذكار هذه الفئة بنجاح تقبل الله طاعتك.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('حسناً'),
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
      appBar: AppBar(
        title: Text(widget.category.category),
        centerTitle: true,
        backgroundColor: Colors.teal.shade50,
      ),
      backgroundColor: const Color(0xFFFAF7F2),
      // استخدام SingleChildScrollView لمنع الـ Overflow نهائياً
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'الذكر ${_currentIndex + 1} من ${widget.category.items.length}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    dhikr.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, height: 1.8, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Text(
                "العدد: $_currentCount / ${dhikr.count}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: 100,
                height: 100,
                child: FloatingActionButton.large(
                  onPressed: _increment,
                  backgroundColor: Colors.teal,
                  child: const Icon(Icons.touch_app, size: 40, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}