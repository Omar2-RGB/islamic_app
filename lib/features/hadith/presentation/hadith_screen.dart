import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class HadithScreen extends StatefulWidget {
  const HadithScreen({super.key});

  @override
  State<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends State<HadithScreen> {
  List<dynamic> _hadiths = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHadiths();
  }

  Future<void> _loadHadiths() async {
    try {
      final String response = await rootBundle.loadString('assets/json/hadith.json');
      final data = json.decode(response);
      setState(() {
        _hadiths = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("خطأ في تحميل الأحاديث: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text('الأربعين النووية', style: TextStyle(fontFamily: 'Uthmanic', color: Colors.teal)),
        centerTitle: true,
        backgroundColor: Colors.teal.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : _hadiths.isEmpty
              ? const Center(child: Text('لا توجد أحاديث مضافة حالياً'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _hadiths.length,
                  itemBuilder: (context, index) {
                    final h = _hadiths[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الحديث رقم ${index + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                fontFamily: 'Uthmanic',
                              ),
                            ),
                            const Divider(color: Colors.teal, thickness: 1),
                            const SizedBox(height: 8),
                            // نص الحديث
                            Text(
                              h['hadith'] ?? '',
                              style: const TextStyle(
                                fontSize: 17,
                                height: 1.8,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 15),
                            // الشرح والفوائد
                            if (h['description'] != null && h['description'].toString().isNotEmpty) ...[
                              const Text(
                                'الشرح والفوائد:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                h['description'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.7,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}