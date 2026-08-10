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

  // الألوان الداكنة الثابتة للتطبيق
  final Color bgColor = const Color(0xFF0D1818);
  final Color cardColor = const Color(0xFF162224);
  final Color goldColor = const Color(0xFFD4AF37);

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
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('الأربعين النووية', style: TextStyle(fontFamily: 'Uthmanic', color: goldColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: goldColor))
          : _hadiths.isEmpty
              ? const Center(child: Text('لا توجد أحاديث مضافة حالياً', style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _hadiths.length,
                  itemBuilder: (context, index) {
                    final h = _hadiths[index];
                    return Card(
                      color: cardColor,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.white.withOpacity(0.05)), // إطار خفيف 
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الحديث رقم ${index + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: goldColor,
                                fontFamily: 'Uthmanic',
                              ),
                            ),
                            Divider(color: goldColor.withOpacity(0.3), thickness: 1),
                            const SizedBox(height: 8),
                            // نص الحديث
                            Text(
                              h['hadith'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.8,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 15),
                            // الشرح والفوائد
                            if (h['description'] != null && h['description'].toString().isNotEmpty) ...[
                              Text(
                                'الشرح والفوائد:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: goldColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                h['description'],
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.7,
                                  color: Colors.grey.shade400,
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