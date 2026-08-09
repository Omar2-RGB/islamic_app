import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DuaaScreen extends StatefulWidget {
  const DuaaScreen({super.key});

  @override
  State<DuaaScreen> createState() => _DuaaScreenState();
}

class _DuaaScreenState extends State<DuaaScreen> {
  // قائمة الأدعية مع التصنيفات
  final List<Map<String, String>> _duaas = [
    {
      "category": "أدعية قرآنية",
      "title": "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً",
      "text": "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ"
    },
    {
      "category": "أدعية قرآنية",
      "title": "رَبِّ اشْرَحْ لِي صَدْرِي",
      "text": "رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي وَاحْلُلْ عُقْدَةً مِّن لِّسَانِي يَفْقَهُوا قَوْلِي"
    },
    {
      "category": "أدعية نبوية",
      "title": "دعاء الكرب والهم",
      "text": "لَا إِلَهَ إِلَّا اللَّه العَظِيمُ الحَلِيمُ، لَا إِلَهَ إِلَّا اللَّه رَبُّ العَرْشِ العَظِيمُ، لَا إِلَهَ إِلَّا اللَّه رَبُّ السَّمَاوَاتِ وَرَبُّ الأَرْضِ وَرَبُّ العَرْشِ الكَرِيمُ."
    },
    {
      "category": "أدعية نبوية",
      "title": "دعاء قضاء الدين",
      "text": "اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ."
    },
    {
      "category": "الشفاء والعافية",
      "title": "دعاء المريض",
      "text": "أَذْهِبِ البَاسَ رَبَّ النَّاسِ، اشْفِ وَأَنْتَ الشَّافِي، لَا شِفَاءَ إِلَّا شِفَاؤُكَ، شِفَاءً لَا يُغَادِرُ سَقَمًا."
    },
    {
      "category": "الرزق والبركة",
      "title": "طلب الرزق الواسع",
      "text": "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا."
    }
  ];

  String _selectedCategory = "الكل";

  @override
  Widget build(BuildContext context) {
    // تصفية الأدعية بناءً على التصنيف المختار
    final filteredDuaas = _selectedCategory == "الكل"
        ? _duaas
        : _duaas.where((d) => d['category'] == _selectedCategory).toList();

    final categories = ["الكل", "أدعية قرآنية", "أدعية نبوية", "الشفاء والعافية", "الرزق والبركة"];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        title: const Text('مكتبة الأدعية', style: TextStyle(fontFamily: 'Uthmanic', color: Colors.teal)),
        centerTitle: true,
        backgroundColor: Colors.teal.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // شريط تصفية التصنيفات (Categories Chips)
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                bool isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: Colors.teal,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.teal.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Colors.teal.shade50,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          
          // قائمة عرض الأدعية
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredDuaas.length,
              itemBuilder: (context, index) {
                final duaa = filteredDuaas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              duaa['title']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                fontFamily: 'Uthmanic',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 20, color: Colors.grey),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: duaa['text']!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم نسخ الدعاء إلى الحافظة'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              tooltip: 'نسخ الدعاء',
                            ),
                          ],
                        ),
                        const Divider(color: Colors.tealAccent),
                        const SizedBox(height: 8),
                        Text(
                          duaa['text']!,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.8,
                            color: Colors.black87,
                            fontFamily: 'Uthmanic',
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}