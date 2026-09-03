import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SchemeDetailScreen extends StatelessWidget {

  final String title;
  final String description;
  final String? eligibility;
  final String? documents;
  final String? officialWebsite;
  final String? helpline;


  const SchemeDetailScreen({
    super.key,
    required this.title,
    required this.description,
    this.eligibility,
    this.documents,
    this.officialWebsite,
    this.helpline,
  });


  Map<String, String> getDetails() {
    if (eligibility != null &&
        eligibility!.isNotEmpty &&
        documents != null &&
        documents!.isNotEmpty) {
      return {
        'eligibility': eligibility!,
        'documents': documents!,
      };
    }

    if (title.contains("किसान")) {
      return {
        "eligibility":
        "• किसान होना चाहिए\n• खेती से जुड़ी जानकारी होनी चाहिए",
        "documents":
        "• आधार कार्ड\n• बैंक खाता\n• जमीन के दस्तावेज",
      };
    }


    if (title.contains("छात्र") || title.contains("शिक्षा")) {
      return {
        "eligibility":
        "• विद्यार्थी होना चाहिए\n• पढ़ाई जारी होनी चाहिए",
        "documents":
        "• आधार कार्ड\n• मार्कशीट\n• स्कूल/कॉलेज ID",
      };
    }


    if (title.contains("महिला") || title.contains("लाडली")) {
      return {
        "eligibility":
        "• महिला लाभार्थी होना चाहिए\n• योजना की आय सीमा लागू हो सकती है",
        "documents":
        "• आधार कार्ड\n• बैंक खाता\n• निवास प्रमाण पत्र",
      };
    }


    return {
      "eligibility":
      "• पात्रता योजना के अनुसार अलग हो सकती है",
      "documents":
      "• आधार कार्ड\n• बैंक खाता\n• पहचान पत्र",
    };

  }


  @override
  Widget build(BuildContext context) {

    final details = getDetails();


    return Scaffold(

      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
      ),


      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [


            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 10),


            Text(
              description,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),


            const SizedBox(height: 25),


            Card(
              child: Padding(
                padding: const EdgeInsets.all(15),

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "✅ पात्रता",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      details["eligibility"]!,
                    ),

                  ],
                ),
              ),
            ),


            const SizedBox(height: 15),


Card(
child: Padding(
padding: const EdgeInsets.all(15),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
"📄 जरूरी दस्तावेज",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 10),
Text(details["documents"]!),
],
),
),
),

const SizedBox(height: 15),

Card(
child: Padding(
padding: const EdgeInsets.all(15),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
"🌐 Official Website",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 10),
Text(
officialWebsite ?? "उपलब्ध नहीं",
style: const TextStyle(
color: Colors.blue,
decoration: TextDecoration.underline,
),
),
const SizedBox(height: 15),
const Text(
"📞 Helpline",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 10),
Text(helpline ?? "उपलब्ध नहीं"),
],
),
),
),

const SizedBox(height: 30),

SizedBox(
width: double.infinity,
height: 55,
child: ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.green,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(15),
),
),
  onPressed: () async {
    if (officialWebsite == null || officialWebsite!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("इस योजना की Official Website उपलब्ध नहीं है"),
        ),
      );
      return;
    }

    final uri = Uri.parse(officialWebsite!);

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Website खोलने में समस्या हुई"),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Website खोलने में समस्या हुई: $e"),
          ),
        );
      }
    }
  },
  child: const Text(
    "आवेदन करें",
    style: TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
  ),
),
),

          ],
        ),
      ),
    );
  }
}