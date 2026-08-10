import 'package:flutter/material.dart';
import '../../tasbih/presentation/tasbih_screen.dart';
import '../../qibla/presentation/qibla_screen.dart';
import '../../names/presentation/names_screen.dart';
import '../../hadith/presentation/hadith_screen.dart';
import '../../khatmah/presentation/khatmah_screen.dart';
import '../../calendar/presentation/calendar_screen.dart';
import '../../duaa/presentation/duaa_screen.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 الألوان الداكنة الثابتة للتطبيق
    final Color bgColor = const Color(0xFF0D1818);
    final Color cardColor = const Color(0xFF162224);
    final Color goldColor = const Color(0xFFD4AF37);

    final List<Map<String, dynamic>> tools = [
      {'title': 'المسبحة الإلكترونية', 'icon': Icons.pin, 'screen': const TasbihScreen()},
      {'title': 'اتجاه القبلة', 'icon': Icons.explore, 'screen': const QiblaScreen()},
      {'title': 'أسماء الله الحسنى', 'icon': Icons.auto_awesome, 'screen': const NamesScreen()},
      {'title': 'الأربعين النووية', 'icon': Icons.menu_book_rounded, 'screen': const HadithScreen()},
      {'title': 'مخطط الختمة', 'icon': Icons.insights, 'screen': const KhatmahScreen()},
      {'title': 'مكتبة الأدعية', 'icon': Icons.menu_book, 'screen': const DuaaScreen()},
    ];

    return Scaffold(
      backgroundColor: bgColor, // تغيير لون الخلفية
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => tool['screen']),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor, // تغيير لون البطاقة
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05), width: 1), // إطار خفيف جداً
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(tool['icon'], size: 40, color: goldColor), // الأيقونة باللون الذهبي
                  const SizedBox(height: 12),
                  Text(
                    tool['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Uthmanic',
                      color: Colors.white, // النص باللون الأبيض
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}