import 'package:egitimciler/app/l10n/app_localizations.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_event.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_state.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class WishlistView extends StatefulWidget {
  const WishlistView({super.key});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  int currentIndex = 3;

  BottomNavigationBar _buildBottomNavBar(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black54,
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
            final user = Supabase.instance.client.auth.currentUser;
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
    final user = Supabase.instance.client.auth.currentUser;

    // 🔹 Eğer kullanıcı giriş yapmamışsa uyarı göster
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(loc.wishlist, style: GoogleFonts.poppins()),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            loc.wishlistError, // L10N eklenmeli
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(context),
      );
    }

    return BlocProvider(
      create: (_) => WishlistViewModel(Supabase.instance.client)..add(LoadWishlist()),
      child: BlocBuilder<WishlistViewModel, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return Scaffold(
              appBar: AppBar(
                title: Text(loc.wishlist, style: GoogleFonts.poppins()),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
              ),
              backgroundColor: Colors.white,
              body: const Center(child: CircularProgressIndicator()),
              bottomNavigationBar: _buildBottomNavBar(context),
            );
          }

          if (state is WishlistError) {
            return Scaffold(
              appBar: AppBar(
                title: Text(loc.wishlist, style: GoogleFonts.poppins()),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
              ),
              backgroundColor: Colors.white,
              body: Center(child: Text(state.message)),
              bottomNavigationBar: _buildBottomNavBar(context),
            );
          }

          if (state is WishlistLoaded) {
            final products = state.products;

            return Scaffold(
              appBar: AppBar(
                title: Text(loc.wishlist, style: GoogleFonts.poppins()),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
              ),
              backgroundColor: Colors.white,
              bottomNavigationBar: _buildBottomNavBar(context),
              body: products.isEmpty
                  ? Center(
                      child: Text(
                        loc.noProductFound,
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final imageUrl = product['image_url'] ?? 'https://via.placeholder.com/150';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                            ),
                            title: Text(
                              product['name'] ?? '',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              product['instructor'] ?? '',
                              style: GoogleFonts.poppins(fontSize: 14),
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
                    ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
