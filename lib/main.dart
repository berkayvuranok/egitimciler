import 'package:egitimciler/app/router/app_router.dart';
import 'package:egitimciler/app/views/view_onboarding/view_model/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase initialization
  await Supabase.initialize(
    url: 'https://teswqsyevuehswncsceo.supabase.co', // Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRlc3dxc3lldnVlaHN3bmNzY2VvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4MTg2NDMsImV4cCI6MjA3MjM5NDY0M30.IZ9sB3XPOOiqgRudr7woxvxC6TAk1zPZRgckE-Of4z4', // Supabase anon key
  );

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
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Ana Ekran')),
      body: Center(
        child: user != null
            ? Text('Hoşgeldiniz, ${user.email}!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            : const Text('Hoşgeldiniz!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
