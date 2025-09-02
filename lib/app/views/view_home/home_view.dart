import 'package:egitimciler/app/views/view_home/view_model/home_event.dart';
import 'package:egitimciler/app/views/view_home/view_model/home_state.dart';
import 'package:egitimciler/app/views/view_home/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeViewModel()..add(LoadHomeData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
        ),
        body: BlocBuilder<HomeViewModel, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeViewModel>().add(RefreshHomeData());
                },
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.star),
                      title: Text(state.items[index]),
                    );
                  },
                ),
              );
            } else if (state is HomeError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
