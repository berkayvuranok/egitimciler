import 'package:flutter/material.dart';

class OnboardingViewHelper {
  /// Onboarding tamamlanınca login ekranına yönlendirme
  static void completeOnboarding(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/login");
  }

  /// Skip yapıldığında direkt login ekranına yönlendirme
  static void skipOnboarding(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/login");
  }
}
