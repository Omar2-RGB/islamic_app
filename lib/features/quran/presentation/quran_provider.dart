import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. نموذج الآية (Ayah Model) لتمثيل البيانات الموجودة في ملفك
class Ayah {
  final int chapter;
  final int verse;
  final String text;

  Ayah({required this.chapter, required this.verse, required this.text});

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      chapter: json['chapter'] ?? 0,
      verse: json['verse'] ?? 0,
      text: json['text'] ?? '',
    );
  }
}

// 2. مزود يجلب آيات سورة معينة (نستخدم .family لكي نمرر له رقم السورة)
final surahVersesProvider = FutureProvider.family<List<Ayah>, int>((ref, surahId) async {
  // قراءة الملف مباشرة
  final String jsonString = await rootBundle.loadString('assets/json/quran.json');
  
  // تحويل النص إلى Map ليتوافق مع هيكل ملفك
  final Map<String, dynamic> data = jsonDecode(jsonString);
  
  // استخراج قائمة الآيات للسورة المطلوبة باستخدام رقمها (مثل "1" للفاتحة)
  final List<dynamic> versesJson = data[surahId.toString()] ?? [];
  
  // تحويل البيانات إلى قائمة من كائنات Ayah
  return versesJson.map((json) => Ayah.fromJson(json)).toList();
});