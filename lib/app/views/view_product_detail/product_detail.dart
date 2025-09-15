import 'package:egitimciler/app/views/view_product_detail/view_model/product_event.dart';
import 'package:egitimciler/app/views/view_product_detail/view_model/product_state.dart';
import 'package:egitimciler/app/views/view_product_detail/view_model/product_view_model.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_view_model.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_event.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_state.dart';
import 'package:egitimciler/app/views/view_my_learning/my_learning_view.dart';
import 'package:egitimciler/app/app_provider/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:egitimciler/app/l10n/app_localizations.dart';

class ProductDetailView extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProductViewModel(Supabase.instance.client)..add(LoadProductDetail(product)),
        ),
        BlocProvider(
          create: (context) =>
              WishlistViewModel(Supabase.instance.client)..add(LoadWishlist()),
        ),
      ],
      child: _ProductDetailContent(product: product),
    );
  }
}

class _ProductDetailContent extends StatefulWidget {
  final Map<String, dynamic> product;
  const _ProductDetailContent({required this.product});

  @override
  State<_ProductDetailContent> createState() => _ProductDetailContentState();
}

class _ProductDetailContentState extends State<_ProductDetailContent> {
  final TextEditingController commentController = TextEditingController();
  int currentIndex = 0;

  String _getImageUrl(dynamic imageField) {
    if (imageField == null) return 'https://via.placeholder.com/150';
    if (imageField is String) return imageField;
    if (imageField is List && imageField.isNotEmpty) return imageField[0];
    return 'https://via.placeholder.com/150';
  }

  bool _isInWishlist(List<Map<String, dynamic>> wishlist, int productId) {
    return wishlist.any((p) => p['id'] == productId);
  }

  /// ✅ Başarılı işlemler için yeşil tikli snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade600,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _addToMyLearning(Map<String, dynamic> product) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    try {
      await Supabase.instance.client.from('user_courses').upsert(
        {
          'user_id': user.id,
          'course_id': product['id'],
          'created_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id,course_id',
      );

      _showSuccessSnackBar('Course added to My Learning! ✅');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyLearningView()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  BottomNavigationBar _buildBottomNavBar(bool isDark, Color bgColor, AppLocalizations local) {
    return BottomNavigationBar(
      backgroundColor: bgColor,
      selectedItemColor: Colors.blue,
      unselectedItemColor: isDark ? Colors.grey.shade400 : Colors.black54,
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
    
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final bool isDark = themeMode == ThemeMode.dark;
        final bgColor = isDark ? Colors.black : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black;
        final subTextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

        return BlocBuilder<ProductViewModel, ProductState>(
          builder: (context, state) {
            return BlocBuilder<WishlistViewModel, dynamic>(
              builder: (context, wishlistState) {
                List<Map<String, dynamic>> wishlistProducts = [];
                if (wishlistState is WishlistLoaded) {
                  wishlistProducts = wishlistState.products;
                }

                if (state is ProductLoading) {
                  return Scaffold(
                    backgroundColor: bgColor,
                    body: const Center(child: CircularProgressIndicator()),
                    bottomNavigationBar: _buildBottomNavBar(isDark, bgColor, local),
                  );
                }

                if (state is ProductError) {
                  return Scaffold(
                    backgroundColor: bgColor,
                    body: Center(
                      child: Text(
                        state.message,
                        style: GoogleFonts.poppins(color: textColor),
                      ),
                    ),
                    bottomNavigationBar: _buildBottomNavBar(isDark, bgColor, local),
                  );
                }

                if (state is ProductLoaded) {
                  final product = state.product;
                  final imageUrl = _getImageUrl(product['image_url']);
                  final List<String> comments = state.comments.map<String>((c) => c.toString()).toList();
                  final rating = state.rating;
                  final inWishlist = _isInWishlist(wishlistProducts, product['id']);

                  return Scaffold(
                    backgroundColor: bgColor,
                    appBar: AppBar(
                      title: Text(
                        product['name'] ?? '',
                        style: GoogleFonts.poppins(color: textColor),
                      ),
                      centerTitle: true,
                      backgroundColor: bgColor,
                      foregroundColor: textColor,
                      actions: [
                        IconButton(
                          icon: Icon(
                            inWishlist ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            final wishlistVM = context.read<WishlistViewModel>();
                            final user = Supabase.instance.client.auth.currentUser;
                            if (user == null) {
                              Navigator.pushNamed(context, '/login');
                              return;
                            }
                            if (inWishlist) {
                              wishlistVM.add(RemoveFromWishlist(product['id']));
                            } else {
                              wishlistVM.add(AddToWishlist(product));
                            }
                          },
                        ),
                      ],
                    ),
                    bottomNavigationBar: _buildBottomNavBar(isDark, bgColor, local),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Product Details
                          Text(
                            product['name'] ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            '${local.instructorLabel(product['instructor'] ?? 'Unknown')}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: subTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            '${local.duration}: ${product['duration'] ?? 'N/A'}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: subTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Rating
                          Row(
                            children: [
                              Text(
                                '${local.rating}: ',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                '${rating.toStringAsFixed(1)} ★',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Price
                          Text(
                            '${product['price'] ?? '0'} ₺',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Add to My Learning Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _addToMyLearning(product),
                              icon: const Icon(Icons.add, size: 24),
                              label: Text(
                                local.addToMyLearning,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Comments Section
                          Text(
                            local.comments,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Comments List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            itemBuilder: (context, index) => Card(
                              color: isDark ? Colors.grey[900] : Colors.grey[50],
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(
                                  comments[index],
                                  style: GoogleFonts.poppins(color: textColor),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: subTextColor,
                                  ),
                                  onPressed: () => _showCommentOptions(
                                    context,
                                    index,
                                    state,
                                    comments,
                                    local,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Add Comment
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: commentController,
                                  style: GoogleFonts.poppins(color: textColor),
                                  decoration: InputDecoration(
                                    hintText: local.AddComment,
                                    hintStyle: GoogleFonts.poppins(color: subTextColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: isDark ? Colors.grey[900] : Colors.grey[100],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(Icons.send, color: Colors.blue),
                                onPressed: () {
                                  if (commentController.text.isNotEmpty) {
                                    context.read<ProductViewModel>().add(
                                          AddComment(commentController.text),
                                        );
                                    commentController.clear();
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Update Rating
                          Text(
                            local.updateRating,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(5, (index) {
                              return IconButton(
                                icon: Icon(
                                  index < rating.round() ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 30,
                                ),
                                onPressed: () => context.read<ProductViewModel>().add(
                                      UpdateRating(index + 1.0),
                                    ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Scaffold(
                  backgroundColor: bgColor,
                  body: const Center(child: CircularProgressIndicator()),
                  bottomNavigationBar: _buildBottomNavBar(isDark, bgColor, local),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showCommentOptions(
    BuildContext context,
    int index,
    ProductLoaded state,
    List<String> comments,
    AppLocalizations local,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: Text(local.edit),
              onTap: () {
                Navigator.pop(context);
                final editController = TextEditingController(text: comments[index]);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(local.edit),
                    content: TextField(controller: editController),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(local.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<ProductViewModel>().add(
                                EditComment(index, editController.text),
                              );
                          Navigator.pop(context);
                        },
                        child: Text(local.saveProfile),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(local.delete),
              onTap: () {
                context.read<ProductViewModel>().add(DeleteComment(index));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}