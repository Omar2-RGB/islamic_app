import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;
class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text('اتجاه القبلة', style: TextStyle(fontFamily: 'Uthmanic', color: Colors.teal)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('خطأ في تشغيل الحساس: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          }

          double? direction = snapshot.data?.heading;

          if (direction == null) {
            return const Center(child: Text("جهازك لا يدعم حساس البوصلة."));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "وجه هاتفك بحسب حركة البوصلة",
                  style: TextStyle(fontSize: 18, color: Colors.grey, fontFamily: 'Uthmanic'),
                ),
                const SizedBox(height: 50),
                Transform.rotate(
                  angle: (direction * (math.pi / 180) * -1),
                  child: Image.asset(
                    'assets/images/qibla_compass.png', // تأكد من توفر صورة بوصلة أو استبدلها بأيقونة
                    width: 250,
                    height: 250,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.navigation,
                      size: 150,
                      color: Colors.teal,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "الزاوية: ${direction.toStringAsFixed(0)} درجة",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}