import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart' as intl;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // الألوان الداكنة الثابتة للتطبيق
  final Color bgColor = const Color(0xFF0D1818);
  final Color cardColor = const Color(0xFF162224);
  final Color goldColor = const Color(0xFFD4AF37);

  late HijriCalendar todayHijri;
  late DateTime todayGregorian;

  // قائمة بأهم المناسبات الإسلامية السنوية
  final List<Map<String, String>> islamicEvents = [
    {"name": "رأس السنة الهجرية", "date": "1 محرم"},
    {"name": "يوم عاشوراء", "date": "10 محرم"},
    {"name": "المولد النبوي الشريف", "date": "12 ربيع الأول"},
    {"name": "الإسراء والمعراج", "date": "27 رجب"},
    {"name": "النصف من شعبان", "date": "15 شعبان"},
    {"name": "بداية شهر رمضان", "date": "1 رمضان"},
    {"name": "عيد الفطر السعيد", "date": "1 شوال"},
    {"name": "يوم عرفة", "date": "9 ذو الحجة"},
    {"name": "عيد الأضحى المبارك", "date": "10 ذو الحجة"},
  ];

  @override
  void initState() {
    super.initState();
    // إعداد اللغة العربية للتقويم الهجري
    HijriCalendar.setLocal('ar');
    todayHijri = HijriCalendar.now();
    todayGregorian = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    // تنسيق التاريخ الميلادي باللغة العربية
    String formattedGregorian = intl.DateFormat('dd MMMM yyyy', 'ar').format(todayGregorian);
    
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('التقويم الهجري', style: TextStyle(fontFamily: 'Uthmanic', color: goldColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💡 بطاقة اليوم الحقيقي (ديناميكية)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: goldColor.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(color: goldColor.withOpacity(0.05), blurRadius: 15, spreadRadius: 2),
                ]
              ),
              child: Column(
                children: [
                  Text(
                    todayHijri.dayWeName, // اسم اليوم (مثال: الإثنين)
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${todayHijri.hDay} ${todayHijri.longMonthName} ${todayHijri.hYear} هـ',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: goldColor, fontFamily: 'Uthmanic'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'الموافق: $formattedGregorian م',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            
            Text(
              'أهم المناسبات الإسلامية:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: goldColor),
            ),
            const SizedBox(height: 15),
            
            // 💡 قائمة المناسبات
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: islamicEvents.length,
                itemBuilder: (context, index) {
                  final event = islamicEvents[index];
                  return Card(
                    color: cardColor,
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: goldColor.withOpacity(0.5))
                        ),
                        child: Icon(Icons.event, color: goldColor, size: 22),
                      ),
                      title: Text(
                        event['name']!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      trailing: Text(
                        event['date']!,
                        style: TextStyle(fontSize: 16, color: goldColor, fontFamily: 'Uthmanic', fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}