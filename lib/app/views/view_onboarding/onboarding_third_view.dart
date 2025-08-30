import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'view_model/onboarding_view_model.dart';
import 'view_model/onboarding_event.dart';
import 'view_model/onboarding_state.dart';

class OnboardingThirdView extends StatelessWidget {
  const OnboardingThirdView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingViewModel, OnboardingState>(
      builder: (context, state) {
        // Sayfa geçişlerini post frame callback ile tetikle
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          if (state.isCompleted) {
            Navigator.pushReplacementNamed(context, "/home");
          } else if (state.currentPage == 1) {
            Navigator.pushReplacementNamed(context, "/onboarding2");
          }
        });

        return Scaffold(
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
              // Görsel üstte
              Expanded(
                flex: 5,
                child: Image.asset(
                  'assets/png/onboarding/onboarding3.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 32),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 1.0, // Step 3 -> %100
                    backgroundColor: const Color(0xFFE0CFF9),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF4B0082)),
                    minHeight: 8,
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
                        "You're all set!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Start your learning journey today! Explore courses, track progress, and achieve your goals with Egitimciler.",
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

              // Prev ve Get Started butonları
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Prev butonu
                    ElevatedButton(
                      onPressed: () {
                        context.read<OnboardingViewModel>().add(OnboardingPrevious());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        elevation: 4,
                        shadowColor: Colors.black,
                      ),
                      child: const Text(
                        "Prev",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Get Started butonu
                    ElevatedButton(
                      onPressed: () {
                        context.read<OnboardingViewModel>().add(OnboardingComplete());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A0DAD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        elevation: 8,
                        shadowColor: Colors.black,
                      ),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
