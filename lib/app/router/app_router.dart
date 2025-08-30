import 'package:egitimciler/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../views/view_splash/splash_view.dart';
import '../views/view_onboarding/onboarding_first_view.dart';
import '../views/view_onboarding/onboarding_second_view.dart';
import '../views/view_onboarding/onboarding_third_view.dart';
//import '../views/view_home/home_view.dart'; // ana sayfa
import '../views/view_onboarding/view_model/onboarding_view_model.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const ViewSplash());

      case '/onboarding':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OnboardingViewModel(),
            child: const OnboardingFirstView(),
          ),
        );

      case '/onboarding2':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<OnboardingViewModel>(context),
            child: const OnboardingSecondView(),
          ),
        );

      case '/onboarding3':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: BlocProvider.of<OnboardingViewModel>(context),
            child: const OnboardingThirdView(),
          ),
        );

      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Route not found")),
          ),
        );
    }
  }
}
