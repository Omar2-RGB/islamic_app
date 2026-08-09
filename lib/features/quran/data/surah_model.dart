class SurahModel {
  final int id; // رقم السورة
  final String name; // اسم السورة (مثل: الفاتحة)
  final String englishName; // الاسم بالإنجليزية (اختياري)
  final String type; // مكية أو مدنية
  final int ayahsCount; // عدد الآيات

  SurahModel({
    required this.id,
    required this.name,
    required this.englishName,
    required this.type,
    required this.ayahsCount,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['number'] ?? json['id'] ?? 1,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      type: json['revelationType'] ?? json['type'] ?? 'Meccan',
      ayahsCount: json['numberOfAyahs'] ?? json['total_verses'] ?? 0,
    );
  }
}