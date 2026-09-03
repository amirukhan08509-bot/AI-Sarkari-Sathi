import 'package:flutter/material.dart';


class GovernmentOfficeScreen extends StatelessWidget {
  const GovernmentOfficeScreen({super.key});

  final List<Map<String, dynamic>> offices = const [
    {
      "title": "तहसील / SDM कार्यालय",
      "description": "आय, निवास, जाति प्रमाण पत्र और अन्य राजस्व संबंधी कार्य।",
      "icon": Icons.account_balance,
      "color": Colors.blue,
    },
    {
      "title": "नगर निगम / नगर पालिका",
      "description": "शहर और स्थानीय निकाय से जुड़ी नागरिक सेवाएँ।",
      "icon": Icons.location_city,
      "color": Colors.orange,
    },
    {
      "title": "कृषि विभाग",
      "description": "किसान योजनाओं और कृषि संबंधी सहायता के लिए।",
      "icon": Icons.agriculture,
      "color": Colors.green,
    },
    {
      "title": "शिक्षा विभाग",
      "description": "छात्रवृत्ति और शिक्षा से संबंधित सरकारी सेवाएँ।",
      "icon": Icons.school,
      "color": Colors.deepPurple,
    },
    {
      "title": "महिला एवं बाल विकास विभाग",
      "description": "महिला और बच्चों से संबंधित सरकारी योजनाओं और सेवाओं के लिए।",
      "icon": Icons.family_restroom,
      "color": Colors.pink,
    },
    {
      "title": "ई-मित्र / सेवा केंद्र",
      "description": "विभिन्न सरकारी सेवाओं और ऑनलाइन आवेदन में सहायता।",
      "icon": Icons.computer,
      "color": Colors.teal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),

      appBar: AppBar(
        title: const Text(
          "सरकारी कार्यालय",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff0F9D58),
                    Color(0xff34A853),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),

              child: const Column(
                children: [
                  Icon(
                    Icons.account_balance,
                    color: Colors.white,
                    size: 50,
                  ),

                  SizedBox(height: 12),

                  Text(
                    "सरकारी कार्यालय खोजें",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "अपने काम से संबंधित सरकारी विभाग की जानकारी देखें।",
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
              "किस विभाग की जानकारी चाहिए?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: offices.length,

              itemBuilder: (context, index) {
                final office = offices[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 3,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GovernmentOfficeScreen(),
                        ),
                      );
                    },

                    child: Padding(
                      padding: const EdgeInsets.all(18),

                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor:
                            (office["color"] as Color).withOpacity(0.12),

                            child: Icon(
                              office["icon"] as IconData,
                              color: office["color"] as Color,
                              size: 30,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [
                                Text(
                                  office["title"] as String,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  office["description"] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.grey,
                          ),
                        ],
                      ),
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