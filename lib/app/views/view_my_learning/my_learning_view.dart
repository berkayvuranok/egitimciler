// my_learning_view.dart
import 'package:egitimciler/app/views/view_product_detail/product_detail.dart';
import 'package:egitimciler/app/views/view_my_learning/view_model/my_learning_event.dart';
import 'package:egitimciler/app/views/view_my_learning/view_model/my_learning_state.dart';
import 'package:egitimciler/app/views/view_my_learning/view_model/my_learning_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:egitimciler/app/l10n/app_localizations.dart';
import '../../app_provider/theme_cubit.dart'; // Dark mode cubit

class MyLearningView extends StatefulWidget {
  const MyLearningView({super.key});

  @override
  State<MyLearningView> createState() => _MyLearningViewState();
}

class _MyLearningViewState extends State<MyLearningView> {
  int currentIndex = 2; // Başlangıçta My Learning seçili

  BottomNavigationBar _buildBottomNavBar(AppLocalizations local, bool isDarkMode) {
    final user = Supabase.instance.client.auth.currentUser;
    return BottomNavigationBar(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() => currentIndex = index);
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/search');
            break;
          case 2:
            Navigator.pushNamed(context, '/my_learning');
            break;
          case 3:
            Navigator.pushNamed(context, '/wishlist');
            break;
          case 4:
            if (user != null) {
              Navigator.pushNamed(context, '/profile');
            } else {
              Navigator.pushNamed(context, '/login');
            }
            break;
        }
      },
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.star), label: local.featured),
        BottomNavigationBarItem(icon: const Icon(Icons.search), label: local.search),
        BottomNavigationBarItem(icon: const Icon(Icons.menu_book), label: local.myLearning),
        BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: local.wishlist),
        BottomNavigationBarItem(icon: const Icon(Icons.account_circle), label: local.account),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final user = Supabase.instance.client.auth.currentUser;

    // 🔹 Eğer kullanıcı giriş yapmamışsa uyarı göster (Wishlist'teki gibi)
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(local.myLearning, style: GoogleFonts.poppins(color: isDarkMode ? Colors.white : Colors.black)),
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          foregroundColor: isDarkMode ? Colors.white : Colors.black87,
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: Center(
          child: Text(
            local.wishlistError, // 🔹 Aynı local mesajı kullanıyoruz
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(local, isDarkMode),
      );
    }

    return BlocProvider(
      create: (_) => MyLearningViewModel(Supabase.instance.client)..add(LoadMyCourses()),
      child: BlocBuilder<MyLearningViewModel, MyLearningState>(
        builder: (context, state) {
          Widget bodyContent;

          if (state is MyLearningLoading) {
            bodyContent = const Center(child: CircularProgressIndicator());
          } else if (state is MyLearningError) {
            bodyContent = Center(
              child: Text(
                state.message,
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            );
          } else if (state is MyLearningLoaded) {
            final courses = state.courses;

            if (courses.isEmpty) {
              bodyContent = Center(
                child: Text(
                  local.noProductFound, // 🔹 Ürün bulunamadı mesajı
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              );
            } else {
              bodyContent = ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final product = courses[index];
                  final imageUrl = product['image_url'] ?? 'https://via.placeholder.com/150';
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailView(product: product),
                        ),
                      );
                    },
                    child: Card(
                      color: isDarkMode ? Colors.grey[900] : Colors.white,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: Image.network(
                          imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          product['name'] ?? '',
                          style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          local.instructorLabel(product['instructor'] ?? '-'),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            bodyContent = const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            appBar: AppBar(
              title: Text(local.myLearning, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
              centerTitle: true,
              backgroundColor: isDarkMode ? Colors.black : Colors.white,
              foregroundColor: isDarkMode ? Colors.white : Colors.black87,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
                onPressed: () {
                  setState(() {
                    currentIndex = 0; // Featured seçili
                  });
                  Navigator.pushNamed(context, '/home');
                },
              ),
            ),
            bottomNavigationBar: _buildBottomNavBar(local, isDarkMode),
            body: bodyContent,
          );
        },
      ),
    );
  }
}