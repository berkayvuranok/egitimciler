import 'package:egitimciler/app/router/app_router.dart';
import 'package:egitimciler/app/views/view_onboarding/view_model/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(
    // Root seviyede OnboardingViewModel provider
    BlocProvider(
      create: (_) => OnboardingViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Egitimciler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Route yönetimi AppRouter üzerinden yapılacak
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
    );
  }
}

// Ana ekran – Splash ve Onboarding sonrası yönlendirilecek
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ana Ekran')),
      body: const Center(
        child: Text('Hoşgeldiniz!'),
      ),
    );
  }
}
