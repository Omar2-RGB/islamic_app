import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../data/adhkar_model.dart'; // تعديل مسار الاستيراد هنا
import 'dhikr_reciting_screen.dart'; // سننشئها في الخطوة القادمة

class AdhkarScreen extends StatefulWidget {
  const AdhkarScreen({super.key});

  @override
  State createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State {
  List _categories = [];

  @override
  void initState() {
    super.initState();
    _loadAdhkar();
  }
Future<void> _loadAdhkar() async {
    try {
      final String response = await rootBundle.loadString('assets/json/adhkar.json');
      // بما أن الملف يبدأ بـ { فهو Map وليس List
      final Map<String, dynamic> data = json.decode(response);
      
      setState(() {
        _categories = DhikrCategory.fromMapJson(data);
      });
    } catch (e) {
      print("خطأ في تحميل الأذكار: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الأذكار"), centerTitle: true),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(cat.category, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DhikrRecitingScreen(category: cat))),
            ),
          );
        },
      ),
    );
  }
}