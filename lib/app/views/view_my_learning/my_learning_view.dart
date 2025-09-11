import 'package:egitimciler/app/views/view_product_detail/product_detail.dart';
import 'package:egitimciler/app/views/view_my_learning/view_model/my_learning_event.dart';
import 'package:egitimciler/app/views/view_my_learning/view_model/my_learning_state.dart';
import 'package:egitimciler/app/views/view_my_learning/view_model/my_learning_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyLearningView extends StatefulWidget {
  const MyLearningView({super.key});

  @override
  State<MyLearningView> createState() => _MyLearningViewState();
}

class _MyLearningViewState extends State<MyLearningView> {
  int currentIndex = 2; // Başlangıçta My Learning seçili

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
      create: (_) =>
          MyLearningViewModel(Supabase.instance.client)..add(LoadMyCourses()),
      child: BlocBuilder<MyLearningViewModel, MyLearningState>(
        builder: (context, state) {
          Widget bodyContent;

          if (state is MyLearningLoading) {
            bodyContent = const Center(child: CircularProgressIndicator());
          } else if (state is MyLearningError) {
            bodyContent = Center(child: Text(state.message));
          } else if (state is MyLearningLoaded) {
            final courses = state.courses;

            if (courses.isEmpty) {
              bodyContent = const Center(child: Text('You have no courses yet.'));
            } else {
              bodyContent = ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final product = courses[index];
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
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: product['image_url'] != null
                            ? Image.network(
                                product['image_url'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : const SizedBox(width: 60, height: 60),
                        title: Text(product['name'], style: GoogleFonts.poppins()),
                        subtitle: Text(
                            'Instructor: ${product['instructor'] ?? '-'}',
                            style: GoogleFonts.poppins(fontSize: 12)),
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            bodyContent = const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            backgroundColor: Colors.white, // Top ve bottom harici beyaz
            appBar: AppBar(
              title: const Text('My Learning'),
              centerTitle: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    currentIndex = 0; // Featured seçili
                  });
                  Navigator.pushNamed(context, '/home');
                },
              ),
            ),
            bottomNavigationBar: _buildBottomNavBar(),
            body: bodyContent,
          );
        },
      ),
    );
  }
}
