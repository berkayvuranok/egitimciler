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

  BottomNavigationBar _buildBottomNavBar() {
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
            if (user != null) Navigator.pushNamed(context, '/profile');
            else Navigator.pushNamed(context, '/login');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Featured'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'My Learning'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'WishList'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WishlistViewModel(Supabase.instance.client)..add(LoadWishlist()),
      child: BlocBuilder<WishlistViewModel, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Wishlist", style: GoogleFonts.poppins()),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
              ),
              backgroundColor: Colors.white,
              body: const Center(child: CircularProgressIndicator()),
              bottomNavigationBar: _buildBottomNavBar(),
            );
          }

          if (state is WishlistError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Wishlist", style: GoogleFonts.poppins()),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
              ),
              backgroundColor: Colors.white,
              body: Center(child: Text(state.message)),
              bottomNavigationBar: _buildBottomNavBar(),
            );
          }

          if (state is WishlistLoaded) {
            final products = state.products;

            return Scaffold(
              appBar: AppBar(
                title: Text("Wishlist", style: GoogleFonts.poppins()),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
              ),
              backgroundColor: Colors.white,
              bottomNavigationBar: _buildBottomNavBar(),
              body: ListView.builder(
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
                      title: Text(product['name'] ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                      subtitle: Text(product['instructor'] ?? '', style: GoogleFonts.poppins(fontSize: 14)),
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
