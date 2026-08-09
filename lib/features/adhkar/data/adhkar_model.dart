class DhikrCategory {
  final String category;
  final List<DhikrItem> items;

  DhikrCategory({required this.category, required this.items});

  // دالة لتحويل ملف حصن المسلم (Map) إلى قائمة فئات
  static List<DhikrCategory> fromMapJson(Map<String, dynamic> jsonMap) {
    List<DhikrCategory> categories = [];
    
    jsonMap.forEach((key, value) {
      if (value is Map && value.containsKey('text')) {
        var textList = value['text'] as List;
        List<DhikrItem> items = textList.map((t) => DhikrItem(
          text: t.toString(),
          count: 1, // الافتراضي تكرار الذكر مرة واحدة، ويمكنك قراءته أو تعديله
        )).toList();
        
        // نتأكد أن الفئة تحتوي على نصوص وليست فارغة
        if (items.isNotEmpty) {
          categories.add(DhikrCategory(category: key, items: items));
        }
      }
    });
    
    return categories;
  }
}

class DhikrItem {
  final String text;
  final int count;

  DhikrItem({required this.text, required this.count});
}