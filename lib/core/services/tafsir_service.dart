import 'package:flutter/services.dart' show rootBundle;

class TafsirService {
  static Future<String> getAyahTafsir(int suraId, int ayahId) async {
    try {
      String fileContent = await rootBundle.loadString('assets/json/tafsir.txt');
      List<String> lines = fileContent.split('\n');

      for (String line in lines) {
        if (line.trim().isEmpty) continue;

        List<String> parts = line.split('|');

        if (parts.length >= 3) {
          int currentSura = int.tryParse(parts[0].trim()) ?? 0;
          int currentAyah = int.tryParse(parts[1].trim()) ?? 0;

          if (currentSura == suraId && currentAyah == ayahId) {
            return parts[2].trim();
          }
        }
      }

      return "التفسير غير متوفر لهذه الآية حالياً.";
    } catch (e) {
      return "حدث خطأ أثناء تحميل التفسير.";
    }
  }
}