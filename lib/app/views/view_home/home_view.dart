import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> allProducts = [];
  bool isLoading = true;

  final List<String> categories = [
    'All',
    'Highschool Education',
    'Middle School Education',
    'Development',
    'Design',
    'Business',
    'Music',
    'Photography',
    'Marketing',
  ];

  final List<Color> categoryColors = [
    Colors.blue.shade300,
    Colors.orange.shade300,
    Colors.purple.shade300,
    Colors.green.shade300,
    Colors.red.shade300,
    Colors.teal.shade300,
    Colors.pink.shade300,
    Colors.indigo.shade300,
    Colors.yellow.shade300,
  ];

  final List<String> placeholderImages = [
    'https://picsum.photos/200/300?random=1',
    'https://picsum.photos/200/300?random=2',
    'https://picsum.photos/200/300?random=3',
    'https://picsum.photos/200/300?random=4',
    'https://picsum.photos/200/300?random=5',
  ];

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  Future<void> fetchAllProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await supabase
          .from('products')
          .select()
          .order('created_at', ascending: false);
      if (response != null) {
        setState(() {
          allProducts = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
          final category = categories[index];
          final color = categoryColors[index % categoryColors.length];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryProductsPage(category: category),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  category,
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

  List<Map<String, dynamic>> _pickRandomProducts(int count) {
    if (allProducts.isEmpty) {
      return List.generate(count, (index) => {
            'id': index,
            'name': 'Sample Product ${index + 1}',
            'description': 'This is a sample description.',
            'duration': '${30 + index * 5} mins',
            'instructor': 'Instructor ${index + 1}',
            'image_url': placeholderImages[index % placeholderImages.length],
            'rating': Random().nextDouble() * 5,
            'comments': <Map<String, dynamic>>[],
          });
    }

    if (allProducts.length <= count) return allProducts;
    final random = Random();
    final picked = <Map<String, dynamic>>[];
    final tempList = List<Map<String, dynamic>>.from(allProducts);
    for (int i = 0; i < count; i++) {
      int index = random.nextInt(tempList.length);
      picked.add(tempList[index]);
      tempList.removeAt(index);
    }
    return picked;
  }

  Widget _buildProductSection(String title) {
    if (isLoading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final products = _pickRandomProducts(5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final imageUrl = (product['image_url'] is List &&
                      (product['image_url'] as List).isNotEmpty)
                  ? product['image_url'][0]
                  : (product['image_url'] is String
                      ? product['image_url']
                      : placeholderImages[index % placeholderImages.length]);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        product: product,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
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
                          product['name'] ?? '',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(product['rating'] ?? 0.0).toStringAsFixed(1)} ★',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildCategories(),
            const SizedBox(height: 16),
            _buildProductSection('Recommended for you'),
            const SizedBox(height: 16),
            _buildProductSection('Short and sweet courses for you'),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(currentIndex, (index) {
        setState(() {
          currentIndex = index;
        });
      }),
    );
  }
}

/// Category Products Page
class CategoryProductsPage extends StatelessWidget {
  final String category;
  const CategoryProductsPage({super.key, required this.category});

  Future<List<Map<String, dynamic>>> fetchCategoryProducts() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('products')
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);
      if (response != null) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  String _getImageUrl(dynamic imageField) {
    if (imageField == null) return 'https://via.placeholder.com/150';
    if (imageField is String) return imageField;
    if (imageField is List && imageField.isNotEmpty) return imageField[0];
    return 'https://via.placeholder.com/150';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(category, style: GoogleFonts.poppins()),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchCategoryProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final imageUrl = _getImageUrl(product['image_url']);
              final rating = (product['rating'] ?? 0.0).toDouble().round();

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12)),
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
                              Text(product['name'] ?? '',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => Icon(
                                    i < rating ? Icons.star : Icons.star_border,
                                    size: 14,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Instructor: ${product['instructor']}',
                                  style:
                                      GoogleFonts.poppins(fontSize: 12)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Product Detail Page
class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isFavorite = false;
  int currentIndex = 0;
  double currentRating = 0.0;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentRating = (widget.product['rating'] ?? 0.0).toDouble();
  }

  Future<void> updateRating(double rating) async {
    setState(() {
      currentRating = rating;
      widget.product['rating'] = rating;
    });
    try {
      await Supabase.instance.client
          .from('products')
          .update({'rating': rating})
          .eq('id', widget.product['id']);
    } catch (e) {}
  }

  void showCommentOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  final TextEditingController editController =
                      TextEditingController(
                          text: widget.product['comments'][index]['text']);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Edit Comment'),
                      content: TextField(
                        controller: editController,
                        decoration: const InputDecoration(
                            hintText: 'Enter comment'),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel')),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              widget.product['comments'][index]['text'] =
                                  editController.text;
                            });
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
                  setState(() {
                    widget.product['comments'].removeAt(index);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _getImageUrl(dynamic imageField, [int index = 0]) {
    if (imageField == null) return 'https://via.placeholder.com/150';
    if (imageField is String) return imageField;
    if (imageField is List && imageField.isNotEmpty) return imageField[0];
    return 'https://via.placeholder.com/150';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _getImageUrl(widget.product['image_url']);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.product['name'] ?? '', style: GoogleFonts.poppins()),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black87,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text('Instructor: ${widget.product['instructor']}',
                        style: GoogleFonts.poppins(fontSize: 16)),
                  ),
                  Expanded(
                    child: Text('Duration: ${widget.product['duration']}',
                        style: GoogleFonts.poppins(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Average Rating: ${(widget.product['rating'] ?? 0.0).toStringAsFixed(1)} ★',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Description:',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(widget.product['description'] ?? '',
                  style: GoogleFonts.poppins(fontSize: 14)),
              const SizedBox(height: 16),
              Text('Rating:',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < currentRating.round()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () async {
                      await updateRating(index + 1.0);
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),
              Text('Comments:',
                  style:
                      GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.product['comments']?.length ?? 0,
                itemBuilder: (context, index) {
                  final comment = widget.product['comments'][index];
                  return ListTile(
                    leading: const Icon(Icons.comment),
                    title: Text(comment['text'] ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => showCommentOptions(index),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        setState(() {
                          widget.product['comments']
                              .add({'text': commentController.text});
                          commentController.clear();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    child: const Icon(Icons.send),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text('Instructor Info:',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Colors.blue.shade50,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(widget.product['instructor'][0],
                        style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(widget.product['instructor'],
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Average Rating: ${(widget.product['rating'] ?? 0.0).toStringAsFixed(1)} ★'),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Purchase successful!')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Buy Now', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(currentIndex, (index) {}),
    );
  }
}

/// BottomNavBar
BottomNavigationBar buildBottomNavBar(
    int currentIndex, Function(int) onTap) {
  return BottomNavigationBar(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.black54,
    currentIndex: currentIndex,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: GoogleFonts.poppins(),
    unselectedLabelStyle: GoogleFonts.poppins(),
    onTap: (index) => onTap(index),
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.star),
        label: 'Featured',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.menu_book),
        label: 'My Learning',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'WishList',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Account',
      ),
    ],
  );
}
