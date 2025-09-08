import 'package:egitimciler/app/views/view_category/category_view.dart';
import 'package:egitimciler/app/views/view_home/home_view.dart';
import 'package:egitimciler/app/views/view_home/view_model/home_event.dart';
import 'package:egitimciler/app/views/view_home/view_model/home_view_model.dart';
import 'package:egitimciler/app/views/view_login/login_view.dart';
import 'package:egitimciler/app/views/view_product_detail/product_detail.dart';
import 'package:egitimciler/app/views/view_search/search_view.dart';
import 'package:egitimciler/app/views/view_signup/signup_view.dart';
import 'package:egitimciler/app/views/view_profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../views/view_splash/splash_view.dart';
import '../views/view_onboarding/onboarding_first_view.dart';
import '../views/view_onboarding/onboarding_second_view.dart';
import '../views/view_onboarding/onboarding_third_view.dart';
import '../views/view_onboarding/view_model/onboarding_view_model.dart';
import '../views/view_wishlist/wishlist_view.dart'; // wishlist import

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
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                HomeViewModel(Supabase.instance.client)..add(LoadHomeData()),
            child: const HomeView(),
          ),
        );

      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchView());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginView());

      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignUpView());

      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileView());

      case '/category_products':
        final category = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CategoryView(category: category),
        );

      case '/product_detail':
        final product = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ProductDetailView(product: product),
        );

      case '/wishlist': // wishlist route eklendi
        return MaterialPageRoute(builder: (_) => const WishlistView());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("Route not found"),
            ),
          ),
        );
    }
  }
}
