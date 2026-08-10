import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart'; // حزمة تحديد الموقع
import 'dart:math' as math;

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  // الألوان الداكنة الثابتة
  final Color bgColor = const Color(0xFF0D1818);
  final Color goldColor = const Color(0xFFD4AF37);

  double? _qiblaDirection;
  bool _isFetchingLocation = true;
  String _locationError = '';

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _calculateQibla();
    }
  }

  // دالة لحساب زاوية القبلة من موقعك الحالي إلى مكة المكرمة
  Future<void> _calculateQibla() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'يرجى تفعيل خدمة الـ GPS في هاتفك.';
          _isFetchingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'تم رفض صلاحية الوصول للموقع.';
            _isFetchingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'صلاحية الموقع مرفوضة نهائياً من الإعدادات.';
          _isFetchingLocation = false;
        });
        return;
      }

      // جلب الإحداثيات الحالية بدقة عالية
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // إحداثيات مكة المكرمة (الكعبة المشرفة)
      const double meccaLat = 21.422487;
      const double meccaLon = 39.826206;

      // حساب زاوية القبلة باستخدام المعادلات الرياضية الجغرافية
      double lat1 = position.latitude * math.pi / 180.0;
      double lon1 = position.longitude * math.pi / 180.0;
      double lat2 = meccaLat * math.pi / 180.0;
      double lon2 = meccaLon * math.pi / 180.0;

      double dLon = lon2 - lon1;

      double y = math.sin(dLon);
      double x = math.cos(lat1) * math.tan(lat2) - math.sin(lat1) * math.cos(dLon);

      double qiblaAngle = math.atan2(y, x) * 180.0 / math.pi;
      qiblaAngle = (qiblaAngle + 360.0) % 360.0;

      setState(() {
        _qiblaDirection = qiblaAngle;
        _isFetchingLocation = false;
      });
    } catch (e) {
      setState(() {
        _locationError = 'حدث خطأ أثناء تحديد الموقع.';
        _isFetchingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('اتجاه القبلة',
            style: TextStyle(fontFamily: 'Uthmanic', color: goldColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: kIsWeb
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.explore_off, size: 80, color: Colors.grey.shade600),
                  const SizedBox(height: 20),
                  Text(
                    'حساس البوصلة لا يعمل على متصفح الويب.\nيرجى التجربة على هاتف حقيقي.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: goldColor, fontSize: 18),
                  ),
                ],
              ),
            )
          : _isFetchingLocation
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: goldColor),
                      const SizedBox(height: 20),
                      Text("جاري تحديد موقعك لحساب القبلة بدقة...", style: TextStyle(color: goldColor)),
                    ],
                  ),
                )
              : _locationError.isNotEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_off, size: 80, color: Colors.red),
                            const SizedBox(height: 20),
                            Text(
                              _locationError,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isFetchingLocation = true;
                                  _locationError = '';
                                });
                                _calculateQibla();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: goldColor),
                              child: const Text('إعادة المحاولة', style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : StreamBuilder<CompassEvent>(
                      stream: FlutterCompass.events,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('خطأ في تشغيل الحساس: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.red)));
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(color: goldColor));
                        }

                        double? direction = snapshot.data?.heading;

                        if (direction == null) {
                          return const Center(
                            child: Text("جهازك لا يدعم حساس البوصلة.",
                                style: TextStyle(color: Colors.white, fontSize: 18)),
                          );
                        }

                        // المعادلة الدقيقة لتوجيه الإبرة نحو مكة
                        // القبلة الدقيقة ناقص زاوية اتجاه الهاتف الحالي
                        double pointerAngle = (_qiblaDirection! - direction) * (math.pi / 180);

                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "وجه هاتفك حتى تتطابق الإبرة",
                                style: TextStyle(fontSize: 18, color: Colors.grey.shade400, fontFamily: 'Uthmanic'),
                              ),
                              const SizedBox(height: 50),
                              Transform.rotate(
                                angle: pointerAngle,
                                child: Image.asset(
                                  'assets/images/qibla_compass.png',
                                  width: 280,
                                  height: 280,
                                  errorBuilder: (context, error, stackTrace) => Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(Icons.explore_outlined, size: 200, color: Colors.grey.shade800),
                                      Icon(Icons.navigation, size: 100, color: goldColor),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Text(
                                "زاوية القبلة: ${_qiblaDirection!.toStringAsFixed(1)}°",
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: goldColor),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}