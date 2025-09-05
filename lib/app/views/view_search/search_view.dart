import 'package:egitimciler/app/views/view_search/view_model/search_event.dart';
import 'package:egitimciler/app/views/view_search/view_model/search_state.dart';
import 'package:egitimciler/app/views/view_search/view_model/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  int currentIndex = 1;
  final TextEditingController searchController = TextEditingController();

  void _handleBottomNavTap(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 4) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        Navigator.pushNamed(context, '/login');
      } else {
        Navigator.pushNamed(context, '/profile');
      }
    } else {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 32),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search Product',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  context.read<SearchViewModel>().add(SearchTextChanged(value));
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<SearchViewModel, SearchState>(
                  builder: (context, state) {
                    if (state is SearchInitial) {
                      return const Center(child: Text('Start typing to search'));
                    }
                    if (state is SearchLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is SearchError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is SearchLoaded) {
                      final results = state.results;
                      if (results.isEmpty) {
                        return const Center(child: Text('No results found.'));
                      }
                      return ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final product = results[index];
                          final imageUrl = (product['image_url'] is List &&
                                  (product['image_url'] as List).isNotEmpty)
                              ? product['image_url'][0]
                              : (product['image_url'] is String
                                  ? product['image_url']
                                  : 'https://picsum.photos/200/300?random=$index');
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/product_detail',
                                arguments: product,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(product['name'] ?? '',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 4),
                                          Text('Instructor: ${product['instructor']}',
                                              style: GoogleFonts.poppins(fontSize: 12)),
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
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black54,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.poppins(),
          unselectedLabelStyle: GoogleFonts.poppins(),
          onTap: _handleBottomNavTap,
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
        ),
      ),
    );
  }
}
