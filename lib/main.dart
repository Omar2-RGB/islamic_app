import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/settings/presentation/main_screen.dart';
import 'core/services/notification_service.dart';

void main() async {
  // التأكد من تهيئة فلاتر قبل تشغيل أي شيء
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة قاعدة البيانات المحلية Hive
  await Hive.initFlutter();
  // لاحقاً سنقوم بفتح الـ Boxes هنا
  await Hive.openBox('khatmahBox');
  await NotificationService.init();
  
  runApp(
    // تغليف التطبيق بـ ProviderScope لكي يعمل Riverpod
    const ProviderScope(
      child: IslamicApp(),
    ),
  );
}

class IslamicApp extends StatelessWidget {
  const IslamicApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 تم إضافة كلمة return هنا لحل المشكلة
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق سُنّة',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0D1818), // لون الخلفية لكل الشاشات
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1818), // لون الـ AppBar في كل الشاشات
          elevation: 0, // إزالة الظل
          iconTheme: IconThemeData(color: Colors.white), // لون أيقونات العودة
          titleTextStyle: TextStyle(
            color: Color(0xFFD4AF37), // لون العنوان الذهبي
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // لون النص الافتراضي ليكون أبيض بدلاً من الأسود
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: const MainScreen(),
    );
  }
}