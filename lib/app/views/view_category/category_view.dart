// category_view.dart
import 'package:egitimciler/app/views/view_category/view_model/category_event.dart';
import 'package:egitimciler/app/views/view_category/view_model/category_state.dart';
import 'package:egitimciler/app/views/view_category/view_model/category_viewmodel.dart';
import 'package:egitimciler/app/views/view_product_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:egitimciler/app/l10n/app_localizations.dart';

class CategoryView extends StatelessWidget {
  final String category;
  const CategoryView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CategoryViewModel(Supabase.instance.client)..add(LoadCategoryProducts(category)),
      child: _CategoryViewContent(category: category),
    );
  }
}

class _CategoryViewContent extends StatefulWidget {
  final String category;
  const _CategoryViewContent({required this.category});

  @override
  State<_CategoryViewContent> createState() => _CategoryViewContentState();
}

class _CategoryViewContentState extends State<_CategoryViewContent> {
  int currentIndex = 0;

  String _getImageUrl(dynamic imageField) {
    if (imageField == null) return 'https://via.placeholder.com/150';
    if (imageField is String) return imageField;
    if (imageField is List && imageField.isNotEmpty) return imageField[0];
    return 'https://via.placeholder.com/150';
  }

  BottomNavigationBar _buildBottomNavBar(AppLocalizations local) {
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

    return BlocBuilder<CategoryViewModel, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: const Center(child: CircularProgressIndicator()),
            bottomNavigationBar: _buildBottomNavBar(local),
          );
        }

        if (state is CategoryError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text(state.message)),
            bottomNavigationBar: _buildBottomNavBar(local),
          );
        }

        if (state is CategoryLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(widget.category, style: GoogleFonts.poppins()),
                centerTitle: true,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
              ),
              body: Center(child: Text(local.noProductsFound)),
              bottomNavigationBar: _buildBottomNavBar(local),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(widget.category, style: GoogleFonts.poppins()),
              centerTitle: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
            ),
            bottomNavigationBar: _buildBottomNavBar(local),
            body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final imageUrl = _getImageUrl(product['image_url']);
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailView(product: product),
                    ),
                  ),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: Image.network(
                            imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'] ?? '',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(5, (i) {
                                    final rating = (product['rating'] ?? 0.0).toDouble().round();
                                    return Icon(
                                      i < rating ? Icons.star : Icons.star_border,
                                      size: 14,
                                      color: Colors.amber,
                                    );
                                  }),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  local.instructorLabel(product['instructor'] ?? ''),
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${product['price'] ?? ''} ₺',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: const Center(child: CircularProgressIndicator()),
          bottomNavigationBar: _buildBottomNavBar(local),
        );
      },
    );
  }
}
