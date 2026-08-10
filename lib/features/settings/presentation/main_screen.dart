import 'package:flutter/material.dart';
import '../../prayer_times/presentation/prayer_screen.dart';
import '../../quran/presentation/quran_screen.dart';
import '../../adhkar/presentation/adhkar_screen.dart';
import '../../tools/presentation/tools_screen.dart'; // تأكد من وجود ملف tools_screen.dart

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const PrayerScreen(),
    const QuranScreen(),
    const AdhkarScreen(),
    const ToolsScreen(), // شاشة الأدوات التي تضم باقي الميزات
  ];

  // دالة لإظهار نافذة حقوق التطبيق
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'حول التطبيق',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mosque, size: 50, color: Colors.teal),
              SizedBox(height: 15),
              Text(
                'تطبيق سَنَا الإسلامي',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'جميع الحقوق محفوظة © 2026\n\nتم التطوير والبرمجة بواسطة:\nالمهندس عمر شعلان عبدالعزيز',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('إغلاق', style: TextStyle(color: Colors.teal, fontSize: 16)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'سَنَا',
          style: TextStyle(
            fontFamily: 'Uthmanic',
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.teal,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal.shade50,
        elevation: 0,
        // إضافة أيقونة الحقوق هنا في يسار الشاشة
        leading: IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.teal),
          tooltip: 'حول التطبيق',
          onPressed: () => _showAboutDialog(context),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // ضروري جداً لظهور العناصر بوضوح
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'الصلاة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'القرآن',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'الأذكار',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'الأدوات',
          ),
        ],
      ),
    );
  }
}