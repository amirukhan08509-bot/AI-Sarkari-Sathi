import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff065F46),
            Color(0xff16A34A),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      child: Column(
        children: [

          const SizedBox(height: 10),

          Image.asset(
            "assets/images/sathi.png",
            height: 170,
          ),

          const SizedBox(height: 15),

          const Text(
            "AI सरकारी साथी",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "मैं आपकी सरकारी सेवाओं,\nयोजनाओं और दस्तावेज़ों में सहायता के लिए तैयार हूँ।",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}