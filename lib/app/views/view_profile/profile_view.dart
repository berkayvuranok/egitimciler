import 'package:egitimciler/app/views/view_profile/view_model/profile_event.dart';
import 'package:egitimciler/app/views/view_profile/view_model/profile_state.dart';
import 'package:egitimciler/app/views/view_profile/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileViewModel(supabase: Supabase.instance.client)
        ..add(LoadUserProfile()),
      child: BlocBuilder<ProfileViewModel, ProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.errorMessage != null) {
            return Scaffold(
              body: Center(child: Text(state.errorMessage!)),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text("Profile"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    context.read<ProfileViewModel>().add(LogoutRequested());
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email: ${state.email ?? ''}",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text("Username: ${state.username ?? ''}",
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
