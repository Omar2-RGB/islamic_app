import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../data/adhkar_model.dart'; 
import 'dhikr_reciting_screen.dart'; 

class AdhkarScreen extends StatefulWidget {
  const AdhkarScreen({super.key});

  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> {
  List<dynamic> _categories = [];
  bool _isLoading = true; // متغير لمعرفة حالة التحميل

  // الألوان الداكنة الثابتة للتطبيق
  final Color bgColor = const Color(0xFF0D1818);
  final Color cardColor = const Color(0xFF162224);
  final Color goldColor = const Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();
    _loadAdhkar();
  }

  Future<void> _loadAdhkar() async {
    try {
      final String response = await rootBundle.loadString('assets/json/adhkar.json');
      final Map<String, dynamic> data = json.decode(response);
      
      setState(() {
        _categories = DhikrCategory.fromMapJson(data);
        _isLoading = false; // تم التحميل بنجاح
      });
    } catch (e) {
      debugPrint("خطأ في تحميل الأذكار: $e");
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
        title: Text(
          "الأذكار",
          style: TextStyle(fontFamily: 'Uthmanic', color: goldColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: goldColor))
          : _categories.isEmpty
              ? const Center(child: Text("لا توجد أذكار متاحة", style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return Card(
                      color: cardColor,
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.white.withOpacity(0.05)), // إطار خفيف 
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        title: Text(
                          cat.category, 
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
                        ),
                        // نستخدم سهم يشير لليسار لأن التطبيق باللغة العربية (من اليمين لليسار)
                        trailing: Icon(Icons.arrow_back_ios, color: goldColor, size: 20),
                        onTap: () => Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => DhikrRecitingScreen(category: cat))
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}