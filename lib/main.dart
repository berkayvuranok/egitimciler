import 'package:flutter/material.dart';
import 'package:egitimciler/app/views/view_splash/splash_view.dart';


void main() {
  runApp(const MyApp());
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
      // Splash ekranını ilk rota olarak ayarlıyoruz
      routes: {
        '/': (context) => const ViewSplash(),
        '/home': (context) => const HomeScreen(),
      },
      initialRoute: '/',
    );
  }
}

// Ana ekran – splash sonrası yönlendirilecek
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
