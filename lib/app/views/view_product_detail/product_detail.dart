import 'package:egitimciler/app/views/view_product_detail/view_model/product_event.dart';
import 'package:egitimciler/app/views/view_product_detail/view_model/product_state.dart';
import 'package:egitimciler/app/views/view_product_detail/view_model/product_view_model.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_view_model.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_event.dart';
import 'package:egitimciler/app/views/view_wishlist/view_model/wishlist_state.dart';
import 'package:egitimciler/app/views/view_my_learning/my_learning_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

 Future<void> _addToMyLearning(Map<String, dynamic> product) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) {
    Navigator.pushNamed(context, '/login');
    return;
  }

  try {
    // onConflict parametresi tek string olarak verildi
    await Supabase.instance.client.from('user_courses').upsert(
      {
        'user_id': user.id,
        'course_id': product['id'],
        'created_at': DateTime.now().toIso8601String(),
      },
      onConflict: 'user_id,course_id', // << burası düzeltildi
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Course added to My Learning!')),
    );

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
                backgroundColor: Colors.white,
                body: const Center(child: CircularProgressIndicator()),
                bottomNavigationBar: _buildBottomNavBar(),
              );
            }

            if (state is ProductError) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: Text(state.message)),
                bottomNavigationBar: _buildBottomNavBar(),
              );
            }

            if (state is ProductLoaded) {
              final product = state.product;
              final imageUrl = _getImageUrl(product['image_url']);
              final List<String> comments =
                  state.comments.map<String>((c) => c.toString()).toList();
              final rating = state.rating;
              final inWishlist = _isInWishlist(wishlistProducts, product['id']);

              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text(product['name'] ?? '',
                      style: GoogleFonts.poppins()),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  actions: [
                    IconButton(
                      icon: Icon(inWishlist
                          ? Icons.favorite
                          : Icons.favorite_border,
                          color: Colors.red),
                      onPressed: () {
                        final wishlistVM =
                            context.read<WishlistViewModel>();
                        final user =
                            Supabase.instance.client.auth.currentUser;
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
                bottomNavigationBar: _buildBottomNavBar(),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              image: NetworkImage(imageUrl), fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Instructor: ${product['instructor']}',
                          style: GoogleFonts.poppins(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Duration: ${product['duration']}',
                          style: GoogleFonts.poppins(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Rating: ${rating.toStringAsFixed(1)} ★',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _addToMyLearning(product),
                          icon: const Icon(Icons.add),
                          label: const Text('Add to My Learning'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: GoogleFonts.poppins(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Comments:',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(comments[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () =>
                                _showCommentOptions(context, index, state, comments),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              decoration: const InputDecoration(
                                  hintText: 'Add a comment'),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              if (commentController.text.isNotEmpty) {
                                context
                                    .read<ProductViewModel>()
                                    .add(AddComment(commentController.text));
                                commentController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text('Update Rating:',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold)),
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                                index < rating.round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber),
                            onPressed: () =>
                                context.read<ProductViewModel>().add(UpdateRating(index + 1.0)),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
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

  void _showCommentOptions(BuildContext context, int index, ProductLoaded state,
      List<String> comments) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                final editController = TextEditingController(text: comments[index]);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Edit Comment'),
                    content: TextField(controller: editController),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          context
                              .read<ProductViewModel>()
                              .add(EditComment(index, editController.text));
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
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
