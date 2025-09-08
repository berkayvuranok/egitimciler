import 'package:egitimciler/app/views/view_home/view_model/home_event.dart';
import 'package:egitimciler/app/views/view_home/view_model/home_state.dart';
import 'package:egitimciler/app/views/view_home/view_model/home_view_model.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_state.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_view_model.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeViewModel(Supabase.instance.client)..add(LoadHomeData()),
        ),
        BlocProvider(
          create: (_) => WishlistViewModel(Supabase.instance.client),
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
        child: Image.asset('assets/png/splash/splash.png', width: 120, height: 120),
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

  List<Map<String, dynamic>> _pickRandomProducts(List<Map<String, dynamic>> allProducts, int count) {
    if (allProducts.isEmpty) return [];
    if (allProducts.length <= count) return allProducts;

    final random = Random();
    final picked = <Map<String, dynamic>>[];
    final tempList = List<Map<String, dynamic>>.from(allProducts);

    for (int i = 0; i < count; i++) {
      if (tempList.isEmpty) break;
      int index = random.nextInt(tempList.length);
      picked.add(tempList[index]);
      tempList.removeAt(index);
    }
    return picked;
  }

  bool _isInWishlist(List<Map<String, dynamic>> wishlist, int productId) {
    return wishlist.any((p) => p['id'] == productId);
  }

  Widget _buildProductItem(Map<String, dynamic> product, int index, List<Map<String, dynamic>> wishlist) {
    final imageUrl = product['lesson_image'] ?? 'https://via.placeholder.com/150';
    final inWishlist = _isInWishlist(wishlist, product['id']);

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
              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withAlpha(50),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product['lesson_title'] ?? '',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(product['lesson_price'] ?? 0).toString()} \$',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: Icon(
                inWishlist ? Icons.favorite : Icons.favorite_border,
                color: inWishlist ? Colors.red : Colors.white,
              ),
              onPressed: () {
                final wishlistVM = context.read<WishlistViewModel>();
                if (inWishlist) {
                  wishlistVM.add(RemoveFromWishlist(product['id']));
                } else {
                  wishlistVM.add(AddToWishlist(product));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection(String title, List<Map<String, dynamic>> products, List<Map<String, dynamic>> wishlist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) => _buildProductItem(products[index], index, wishlist),
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
        return BlocBuilder<WishlistViewModel, dynamic>(
          builder: (context, wishlistState) {
            List<Map<String, dynamic>> wishlistProducts = [];
            if (wishlistState is WishlistLoaded) {
              wishlistProducts = wishlistState.products;
            }

            if (homeState is HomeLoading) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: const Center(child: CircularProgressIndicator()),
                bottomNavigationBar: _buildBottomNavBar(),
              );
            }

            if (homeState is HomeError) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: Text(homeState.message)),
                bottomNavigationBar: _buildBottomNavBar(),
              );
            }

            if (homeState is HomeLoaded) {
              final products = homeState.products;
              final recommended = _pickRandomProducts(products, 5);
              final shortCourses = _pickRandomProducts(products, 5);

              return Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      _buildCategories(),
                      const SizedBox(height: 16),
                      _buildProductSection('Recommended for you', recommended, wishlistProducts),
                      const SizedBox(height: 16),
                      _buildProductSection('Short and sweet courses for you', shortCourses, wishlistProducts),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                bottomNavigationBar: _buildBottomNavBar(),
              );
            }

            return Scaffold(
              backgroundColor: Colors.white,
              body: const Center(child: CircularProgressIndicator()),
              bottomNavigationBar: _buildBottomNavBar(),
            );
          },
        );
      },
    );
  }
}
