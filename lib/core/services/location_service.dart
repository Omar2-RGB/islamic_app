import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. التحقق من تشغيل خدمة الموقع في الجهاز
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // 2. التحقق من الصلاحيات
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null; // تم رفض الصلاحية
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null; // تم رفض الصلاحية بشكل دائم
    }

    // 3. جلب الإحداثيات الدقيقة
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}