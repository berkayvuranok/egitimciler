import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'view_model/onboarding_view_model.dart';
import 'view_model/onboarding_event.dart';
import 'view_model/onboarding_state.dart';

class OnboardingFirstView extends StatelessWidget {
  const OnboardingFirstView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingViewModel, OnboardingState>(
      listener: (context, state) {
        if (state.isCompleted) {
          Navigator.pushReplacementNamed(context, "/home");
        } else if (state.currentPage == 1) {
          Navigator.pushReplacementNamed(context, "/onboarding2");
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(""),
          actions: [
            TextButton(
              onPressed: () {
                context.read<OnboardingViewModel>().add(OnboardingSkip());
              },
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Column(
          children: [
            // Görsel en tepede
            Expanded(
              flex: 5,
              child: Image.asset(
                'assets/png/onboarding/onboarding1.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Progress bar daha kalın ve kısaltıldı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: 0.33, // Step 1 -> %33
                  backgroundColor: const Color(0xFFE0CFF9), // açık mor
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF4B0082)), // koyu mor
                  minHeight: 8, // kalınlaştırıldı
                ),
              ),
            ),

            // Başlık ve açıklama
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Welcome to Egitimciler!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Get ready to explore! With Egitimciler, enhance your skills, discover courses tailored to your interests, and start learning right away.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Next butonu sağ altta modern ve şık
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<OnboardingViewModel>().add(OnboardingNext());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A0DAD), // soğuk mor
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    elevation: 8,
                    shadowColor: Colors.black, // siyah gölge
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
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
