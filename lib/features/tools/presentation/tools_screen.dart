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
    final List<Map<String, dynamic>> tools = [
      {'title': 'المسبحة الإلكترونية', 'icon': Icons.pin, 'screen': const TasbihScreen()},
      {'title': 'اتجاه القبلة', 'icon': Icons.explore, 'screen': const QiblaScreen()},
      {'title': 'أسماء الله الحسنى', 'icon': Icons.auto_awesome, 'screen': const NamesScreen()},
      {'title': 'الأربعين النووية', 'icon': Icons.menu_book_rounded, 'screen': const HadithScreen()},
      {'title': 'مخطط الختمة', 'icon': Icons.insights, 'screen': const KhatmahScreen()},
      {'title': 'التقويم الهجري', 'icon': Icons.calendar_month, 'screen': const CalendarScreen()},
      {'title': 'مكتبة الأدعية', 'icon': Icons.menu_book, 'screen': const DuaaScreen()},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.teal.shade100, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(tool['icon'], size: 40, color: Colors.teal),
                  const SizedBox(height: 12),
                  Text(
                    tool['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Uthmanic',
                      color: Colors.teal,
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