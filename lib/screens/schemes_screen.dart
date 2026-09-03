import 'package:flutter/material.dart';
import 'scheme_result_screen.dart';

class SchemesScreen extends StatefulWidget {
  const SchemesScreen({super.key});

  @override
  State<SchemesScreen> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends State<SchemesScreen> {
  String? selectedState;
  String selectedCategory = "";

  final List<String> states = [
    "राजस्थान",
    "उत्तर प्रदेश",
    "मध्य प्रदेश",
    "गुजरात",
    "महाराष्ट्र",
  ];

  final List<Map<String, dynamic>> categories = [
    {"title": "किसान", "icon": Icons.agriculture},
    {"title": "महिला", "icon": Icons.woman},
    {"title": "छात्र", "icon": Icons.school},
    {"title": "वरिष्ठ नागरिक", "icon": Icons.elderly},
    {"title": "रोजगार", "icon": Icons.work},
    {"title": "आवास", "icon": Icons.home},
    {"title": "स्वास्थ्य", "icon": Icons.local_hospital},
    {"title": "व्यवसाय", "icon": Icons.business_center},
    {"title": "दिव्यांग", "icon": Icons.accessible},
    {"title": "SC/ST/OBC", "icon": Icons.groups},
    {"title": "अन्य", "icon": Icons.account_balance},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FB),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text(
          "सरकारी योजनाएँ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xff0F9D58), Color(0xff34A853)],
                ),
              ),

              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.account_balance,
                      color: Colors.green,
                      size: 35,
                    ),
                  ),

                  SizedBox(height: 18),

                  Text(
                    "सरकारी साथी",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "अपने लिए सही सरकारी योजना खोजें",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              "📍 अपना राज्य चुनें",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: selectedState,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              hint: const Text("राज्य चुनें"),

              items: states.map((state) {
                return DropdownMenuItem(value: state, child: Text(state));
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedState = value;
                });
              },
            ),

            const SizedBox(height: 30),

            const Text(
              "🎯 योजना किसके लिए चाहिए?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 18),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final item = categories[index];

                final bool isSelected = selectedCategory == item["title"];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = item["title"];
                    });
                  },

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),

                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.white,

                      borderRadius: BorderRadius.circular(18),

                      border: Border.all(
                        color: isSelected ? Colors.green : Colors.grey.shade300,
                        width: 2,
                      ),

                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade200, blurRadius: 8),
                      ],
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(
                          item["icon"],
                          size: 42,
                          color: isSelected ? Colors.white : Colors.green,
                        ),

                        const SizedBox(height: 12),

                        Text(
                          item["title"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                icon: const Icon(Icons.search),

                label: const Text(
                  "मेरी योजनाएँ खोजें",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                onPressed: () {
                  if (selectedState == null || selectedCategory.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("कृपया राज्य और श्रेणी चुनें"),
                      ),
                    );

                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SchemeResultScreen(
                        state: selectedState!,
                        category: selectedCategory,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
