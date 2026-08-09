import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan/adhan.dart';
import '../../../core/services/location_service.dart';

// FutureProvider لأنه يتعامل مع عملية غير متزامنة (جلب الموقع)
final prayerTimesProvider = FutureProvider((ref) async {
  // 1. جلب الموقع
  final position = await LocationService.getCurrentLocation();
  
  if (position == null) return null;

  // 2. تحديد الإحداثيات
  final coordinates = Coordinates(position.latitude, position.longitude);
  
  // 3. تحديد طريقة الحساب (اخترنا أم القرى كمثال، يمكنك تغييرها لاحقاً)
  final params = CalculationMethod.umm_al_qura.getParameters();
  params.madhab = Madhab.shafi; // المذهب الشافعي/الحنبلي/المالكي لحساب العصر
  
  // 4. حساب الأوقات وإرجاعها
  return PrayerTimes.today(coordinates, params);
});