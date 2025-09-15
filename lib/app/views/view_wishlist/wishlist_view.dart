// wishlist_view.dart
import 'package:egitimciler/app/l10n/app_localizations.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_event.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_state.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app_provider/theme_cubit.dart'; // Dark mode cubit

class WishlistView extends StatefulWidget {
  const WishlistView({super.key});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  int currentIndex = 3;

  BottomNavigationBar _buildBottomNavBar(AppLocalizations loc, bool isDarkMode) {
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
            // Zaten Wishlist ekranındayız
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
        BottomNavigationBarItem(icon: const Icon(Icons.star), label: loc.featured),
        BottomNavigationBarItem(icon: const Icon(Icons.search), label: loc.search),
        BottomNavigationBarItem(icon: const Icon(Icons.menu_book), label: loc.myLearning),
        BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: loc.wishlist),
        BottomNavigationBarItem(icon: const Icon(Icons.account_circle), label: loc.account),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final user = Supabase.instance.client.auth.currentUser;

    // 🔹 Eğer kullanıcı giriş yapmamışsa uyarı göster
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(loc.wishlist, style: GoogleFonts.poppins(color: isDarkMode ? Colors.white : Colors.black)),
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          foregroundColor: isDarkMode ? Colors.white : Colors.black87,
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: Center(
          child: Text(
            loc.wishlistError,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(loc, isDarkMode),
      );
    }

    return BlocProvider(
      create: (_) => WishlistViewModel(Supabase.instance.client)..add(LoadWishlist()),
      child: BlocBuilder<WishlistViewModel, WishlistState>(
        builder: (context, state) {
          Widget bodyContent;

          if (state is WishlistLoading) {
            bodyContent = const Center(child: CircularProgressIndicator());
          } else if (state is WishlistError) {
            bodyContent = Center(
              child: Text(
                state.message,
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            );
          } else if (state is WishlistLoaded) {
            final products = state.products;

            if (products.isEmpty) {
              bodyContent = Center(
                child: Text(
                  loc.noProductFound,
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
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final imageUrl = product['image_url'] ?? 'https://via.placeholder.com/150';

                  return Card(
                    color: isDarkMode ? Colors.grey[900] : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                      ),
                      title: Text(
                        product['name'] ?? '',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        product['instructor'] ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<WishlistViewModel>().add(RemoveFromWishlist(product['id']));
                        },
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/product_detail', arguments: product);
                      },
                    ),
                  );
                },
              );
            }
          } else {
            bodyContent = const SizedBox.shrink();
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(loc.wishlist, style: GoogleFonts.poppins(color: isDarkMode ? Colors.white : Colors.black)),
              backgroundColor: isDarkMode ? Colors.black : Colors.white,
              foregroundColor: isDarkMode ? Colors.white : Colors.black87,
            ),
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            bottomNavigationBar: _buildBottomNavBar(loc, isDarkMode),
            body: bodyContent,
          );
        },
      ),
    );
  }
}
