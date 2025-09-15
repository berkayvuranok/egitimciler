// search_view.dart
import 'package:egitimciler/app/views/view_product_detail/product_detail.dart';
import 'package:egitimciler/app/views/view_search/view_model/search_event.dart';
import 'package:egitimciler/app/views/view_search/view_model/search_state.dart';
import 'package:egitimciler/app/views/view_search/view_model/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:egitimciler/app/l10n/app_localizations.dart';
import '../../app_provider/theme_cubit.dart'; // Dark mode cubit

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchViewModel()..add(LoadAllProducts()),
      child: const _SearchViewContent(),
    );
  }
}

class _SearchViewContent extends StatefulWidget {
  const _SearchViewContent();

  @override
  State<_SearchViewContent> createState() => _SearchViewContentState();
}

class _SearchViewContentState extends State<_SearchViewContent> {
  int currentIndex = 1;
  final TextEditingController searchController = TextEditingController();

  void _handleBottomNavTap(int index) {
    final user = Supabase.instance.client.auth.currentUser;
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, '/my_learning');
        break;
      case 3:
        Navigator.pushNamed(context, '/wishlist');
        break;
      case 4:
        if (user != null) {
          Navigator.pushNamed(context, '/profile');
        } else {
          Navigator.pushNamed(context, '/login');
        }
        break;
    }
    setState(() => currentIndex = index);
  }

  String _getImageUrl(dynamic imageField, int index) {
    if (imageField == null) return 'https://picsum.photos/200/300?random=$index';
    if (imageField is String) return imageField;
    if (imageField is List && imageField.isNotEmpty) return imageField[0];
    return 'https://picsum.photos/200/300?random=$index';
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDarkMode = themeMode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 32),
                TextField(
                  controller: searchController,
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: local.searchHint,
                    hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black45),
                    prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white : Colors.black54),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
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
                      if (state is SearchLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is SearchError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                          ),
                        );
                      }
                      if (state is SearchLoaded) {
                        final results = state.results;
                        if (results.isEmpty) {
                          return Center(
                            child: Text(
                              local.noResultsFound,
                              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final product = results[index];
                            final imageUrl = _getImageUrl(product['image_url'], index);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailView(product: product),
                                  ),
                                );
                              },
                              child: Card(
                                color: isDarkMode ? Colors.grey[900] : Colors.white,
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
                                                color: isDarkMode ? Colors.white : Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              local.instructorLabel(product['instructor'] ?? ''),
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: isDarkMode ? Colors.white70 : Colors.black54,
                                              ),
                                            ),
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
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: GoogleFonts.poppins(),
            unselectedLabelStyle: GoogleFonts.poppins(),
            onTap: _handleBottomNavTap,
            items: [
              BottomNavigationBarItem(icon: const Icon(Icons.star), label: local.featured),
              BottomNavigationBarItem(icon: const Icon(Icons.search), label: local.search),
              BottomNavigationBarItem(icon: const Icon(Icons.menu_book), label: local.myLearning),
              BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: local.wishlist),
              BottomNavigationBarItem(icon: const Icon(Icons.account_circle), label: local.account),
            ],
          ),
        );
      },
    );
  }
}
