import 'dart:convert';
import 'package:flutter/services.dart';

class LocalDataService {
  
  /// دالة عامة لقراءة أي ملف JSON من الـ Assets
  Future<List<dynamic>> loadJsonData(String path) async {
    try {
      // قراءة الملف كنص
      final String jsonString = await rootBundle.loadString(path);
      
      // تحويل النص إلى قائمة بيانات
      final data = jsonDecode(jsonString);
      return data as List<dynamic>;
    } catch (e) {
      print('حدث خطأ أثناء قراءة الملف $path: $e');
      return [];
    }
  }
}