import 'package:egitimciler/app/views/view_category/view_model/category_event.dart';
import 'package:egitimciler/app/views/view_category/view_model/category_state.dart';
import 'package:egitimciler/app/views/view_category/view_model/category_viewmodel.dart';
import 'package:egitimciler/app/views/view_product_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class CategoryView extends StatelessWidget {
  final String category;
  const CategoryView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryViewModel(Supabase.instance.client)..add(LoadCategoryProducts(category)),
      child: const _CategoryViewContent(),
    );
  }
}

class _CategoryViewContent extends StatelessWidget {
  const _CategoryViewContent();

  String _getImageUrl(dynamic imageField) {
    if (imageField == null) return 'https://via.placeholder.com/150';
    if (imageField is String) return imageField;
    if (imageField is List && imageField.isNotEmpty) return imageField[0];
    return 'https://via.placeholder.com/150';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryViewModel, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is CategoryError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        if (state is CategoryLoaded) {
          final products = state.products;
          if (products.isEmpty) {
            return const Scaffold(body: Center(child: Text('No products found.')));
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(products.first['category'] ?? '', style: GoogleFonts.poppins()),
              centerTitle: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final imageUrl = _getImageUrl(product['image_url']);
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProductDetailView(product: product)),
                  ),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                          child: Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product['name'] ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Row(children: List.generate(5, (i) {
                                  final rating = (product['rating'] ?? 0.0).toDouble().round();
                                  return Icon(i < rating ? Icons.star : Icons.star_border, size: 14, color: Colors.amber);
                                })),
                                const SizedBox(height: 4),
                                Text('Instructor: ${product['instructor']}', style: GoogleFonts.poppins(fontSize: 12)),
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
        return const SizedBox();
      },
    );
  }
}
