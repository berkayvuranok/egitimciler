import 'package:egitimciler/app/router/app_router.dart';
import 'package:egitimciler/app/views/view_onboarding/view_model/onboarding_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Supabase initialization
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
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
            ? Text(
                'Hoşgeldiniz, ${user.email}!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            : const Text(
                'Hoşgeldiniz!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
