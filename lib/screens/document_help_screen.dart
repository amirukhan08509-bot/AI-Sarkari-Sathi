import 'package:flutter/material.dart';

class DocumentHelpScreen extends StatelessWidget {
  const DocumentHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final documents = [
      {
        "title": "आधार कार्ड",
        "icon": Icons.badge,
      },
      {
        "title": "पैन कार्ड",
        "icon": Icons.credit_card,
      },
      {
        "title": "जाति प्रमाण पत्र",
        "icon": Icons.description,
      },
      {
        "title": "आय प्रमाण पत्र",
        "icon": Icons.currency_rupee,
      },
      {
        "title": "निवास प्रमाण पत्र",
        "icon": Icons.home,
      },
      {
        "title": "जन्म प्रमाण पत्र",
        "icon": Icons.calendar_month,
      },
      {
        "title": "मृत्यु प्रमाण पत्र",
        "icon": Icons.article,
      },
      {
        "title": "विवाह प्रमाण पत्र",
        "icon": Icons.favorite,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      appBar: AppBar(
        title: const Text(
          "दस्तावेज़ सहायता",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff1565C0),
                    Color(0xff42A5F5),
                  ],
                ),
              ),

              child: const Column(
                children: [
                  Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 55,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "दस्तावेज़ सहायता",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "जिस दस्तावेज़ की जानकारी चाहिए, उसे चुनें",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              "📄 दस्तावेज़ चुनें",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemCount: documents.length,

              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.15,
              ),

              itemBuilder: (context, index) {
                final document = documents[index];

                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${document["title"]} चुना गया",
                        ),
                      ),
                    );
                  },

                  child: Card(
                    elevation: 4,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(
                          document["icon"] as IconData,
                          size: 42,
                          color: Colors.blue,
                        ),

                        const SizedBox(height: 12),

                        Text(
                          document["title"] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}