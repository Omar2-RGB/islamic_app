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
    return MaterialApp(
      title: 'سَنَا',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, // اللون الأساسي للتطبيق (أخضر مزرق)
        ),
        useMaterial3: true,
        fontFamily: 'Uthmanic', // الخط الذي سيتم تطبيقه على التطبيق بالكامل
      ),
      home: const MainScreen(),
    );
  }
}