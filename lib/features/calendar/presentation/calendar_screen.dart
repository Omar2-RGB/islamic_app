import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text('التقويم الهجري', style: TextStyle(fontFamily: 'Uthmanic', color: Colors.teal)),
        centerTitle: true,
        backgroundColor: Colors.teal.shade50,
        elevation: 0,
      ),
      body: Center(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_month, size: 80, color: Colors.teal),
                const SizedBox(height: 20),
                const Text(
                  '1448 هـ',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal, fontFamily: 'Uthmanic'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'الموافق لعام 2026 م',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const Divider(height: 40),
                const Text(
                  'أهم المناسبات القادمة:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('• شهر رمضان المبارك', style: TextStyle(fontSize: 15)),
                const Text('• عيد الفطر السعيد', style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}