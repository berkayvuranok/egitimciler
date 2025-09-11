import 'package:egitimciler/app/views/view_home/view_model/home_event.dart';
import 'package:egitimciler/app/views/view_home/view_model/home_state.dart';
import 'package:egitimciler/app/views/view_home/view_model/home_view_model.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_state.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_view_model.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              HomeViewModel(Supabase.instance.client)..add(LoadHomeData()),
        ),
        BlocProvider(
          create: (_) => WishlistViewModel(Supabase.instance.client)
            ..add(LoadWishlist()),
        ),
      ],
      child: const _HomeViewContent(),
    );
  }
}

class _HomeViewContent extends StatefulWidget {
  const _HomeViewContent();

  @override
  State<_HomeViewContent> createState() => _HomeViewContentState();
}

class _HomeViewContentState extends State<_HomeViewContent> {
  int currentIndex = 0;

  final List<String> categories = [
    'All',
    'Highschool Education',
    'Middle School Education',
    'Development',
    'Design',
    'Business',
    'Music',
    'Photography',
    'Marketing'
  ];

  final List<Color> categoryColors = [
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.green,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.yellow
  ];

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Center(
        child: Image.asset(
          'assets/png/splash/splash.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/category_products',
                arguments: categories[index],
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: categoryColors[index],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isInWishlist(List<Map<String, dynamic>> wishlist, int productId) {
    return wishlist.any((p) => p['id'] == productId);
  }

  Widget _buildProductItem(
      Map<String, dynamic> product,
      List<Map<String, dynamic>> wishlist,
      ) {
    final imageUrl = product['image_url'] ?? 'https://via.placeholder.com/150';
    final inWishlist = _isInWishlist(wishlist, product['id']);
    final productName = product['name'] ?? 'No Title';
    final productPrice = product['price'] ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product_detail', arguments: product);
      },
      child: Stack(
        children: [
          Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[300],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: 140,
                height: 180,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(200),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      productName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '$productPrice ₺',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: BlocBuilder<WishlistViewModel, WishlistState>(
              builder: (context, wishlistState) {
                List<Map<String, dynamic>> wishlistProducts = [];
                if (wishlistState is WishlistLoaded) {
                  wishlistProducts = wishlistState.products;
                }
                final isFavorite = _isInWishlist(wishlistProducts, product['id']);
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      final wishlistVM = context.read<WishlistViewModel>();
                      if (isFavorite) {
                        wishlistVM.add(RemoveFromWishlist(product['id']));
                      } else {
                        wishlistVM.add(AddToWishlist(product));
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection(
      String title,
      List<Map<String, dynamic>> products,
      List<Map<String, dynamic>> wishlist,
      ) {
    if (products.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) =>
                _buildProductItem(products[index], wishlist),
          ),
        ),
      ],
    );
  }

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
            final user = Supabase.instance.client.auth.currentUser;
            if (user != null) {
              Navigator.pushNamed(context, '/profile');
            } else {
              Navigator.pushNamed(context, '/login');
            }
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
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, homeState) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder<WishlistViewModel, WishlistState>(
            builder: (context, wishlistState) {
              List<Map<String, dynamic>> wishlistProducts = [];
              if (wishlistState is WishlistLoaded) {
                wishlistProducts = wishlistState.products;
              }

              if (homeState is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (homeState is HomeError) {
                return Center(child: Text(homeState.message));
              }

              if (homeState is HomeLoaded) {
                final products = homeState.products;
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      _buildCategories(),
                      const SizedBox(height: 16),
                      if (products.isNotEmpty)
                        _buildProductSection(
                            'Recommended for you', products, wishlistProducts),
                      const SizedBox(height: 16),
                      if (products.isNotEmpty)
                        _buildProductSection(
                            'Short and sweet courses for you',
                            products,
                            wishlistProducts),
                    ],
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
          bottomNavigationBar: _buildBottomNavBar(),
        );
      },
    );
  }
}
