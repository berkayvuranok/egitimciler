import 'package:egitimciler/app/views/view_home/home_view.dart';
import 'package:egitimciler/app/views/view_profile/view_model/profile_event.dart';
import 'package:egitimciler/app/views/view_profile/view_model/profile_state.dart';
import 'package:egitimciler/app/views/view_profile/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  // Örnek üniversite ve lise listeleri
  static const List<String> universities = [
    'Boğaziçi University',
    'Middle East Technical University',
    'Istanbul University',
    'Hacettepe University',
    'Ankara University',
    'Ege University',
    'İzmir Institute of Technology',
    'Bilkent University',
    'Koç University',
    'Sabancı University',
    'Yıldız Technical University',
    'Çukurova University',
    'Gazi University',
    'Marmara University',
    'Dokuz Eylül University',
    'Atatürk University',
    'Selçuk University',
    'Karadeniz Technical University',
    'Sakarya University',
    'Pamukkale University',
    'Gaziantep University',
    'Erciyes University',
    'Ondokuz Mayıs University',
    'Kocaeli University',
    'Akdeniz University',
    'Uludağ University',
    'Çanakkale Onsekiz Mart University',
    'Dicle University',
    'Fırat University',
    'Mersin University',
    'Süleyman Demirel University',
    'Trakya University',
    'Yalova University',
    'Aksaray University',
    'Bartın University',
    'Bayburt University',
    'Bitlis Eren University',
    'Bingöl University',
    // diğer üniversiteler...
  ];

  static const List<String> highSchools = [
    'Kadıköy Anadolu Lisesi',
    'Galatasaray Lisesi',
    'İstanbul Lisesi',
    'Robert Kolej',
    'Kabataş Erkek Lisesi',
    'Çapa Fen Lisesi',  
    'Beşiktaş Anadolu Lisesi',
    'Saint Joseph Fransız Lisesi',
    'Cağaloğlu Anadolu Lisesi',
    'Atatürk Fen Lisesi',
    'Samsun Anadolu Lisesi',
    'Ankara Fen Lisesi',
    'İzmir Fen Lisesi',
    'Konya Fen Lisesi',
    'Bursa Anadolu Lisesi',
    'Adana Fen Lisesi',
    'Trabzon Fen Lisesi',
    'Eskişehir Anadolu Lisesi',
    'Diyarbakır Anadolu Lisesi',
    'Gaziantep Fen Lisesi',
    'Kayseri Anadolu Lisesi',
    'Malatya Fen Lisesi',

    // diğer liseler...
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;

    return BlocProvider(
      create: (_) => ProfileViewModel()
        ..add(LoadProfile(userId: currentUser?.id, email: currentUser?.email)),
      child: BlocConsumer<ProfileViewModel, ProfileState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text("Profile saved successfully", style: TextStyle(color: Colors.white)),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.errorMessage!, style: const TextStyle(color: Colors.white))),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<ProfileViewModel>();

          InputDecoration modernInput({String? hint}) {
            return InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade400, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade500, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            );
          }

          List<String> getSchoolOptions() {
            switch (state.educationLevel) {
              case 'University':
                return universities;
              case 'High School':
                return highSchools;
              default:
                return [];
            }
          }

          Future<void> handleLogout(BuildContext context) async {
            await Supabase.instance.client.auth.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeView()),
              (route) => false,
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                "Profile",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: "Logout",
                  onPressed: () => handleLogout(context),
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full name
                  Text("Full Name", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: ValueKey('fullName_${state.fullName}'),
                    initialValue: state.fullName.isNotEmpty
                        ? state.fullName
                        : currentUser!.userMetadata?['full_name'] ?? '',
                    readOnly: true,
                    decoration: modernInput(),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  Text("Email", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: ValueKey('email_${state.email}'),
                    initialValue: state.email.isNotEmpty ? state.email : currentUser?.email ?? '',
                    readOnly: true,
                    decoration: modernInput(),
                  ),
                  const SizedBox(height: 24),

                  // Role
                  Text("Role", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: state.role.isNotEmpty ? state.role : null,
                    items: const ["Teacher", "Student"]
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            ))
                        .toList(),
                    onChanged: (value) => bloc.add(ProfileFieldChanged(role: value)),
                    decoration: modernInput(),
                    dropdownColor: Colors.white,
                  ),
                  const SizedBox(height: 16),

                  // Gender
                  Text("Gender", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: state.gender.isNotEmpty ? state.gender : null,
                    items: const ["Male", "Female"]
                        .map((g) => DropdownMenuItem(
                              value: g,
                              child: Text(g),
                            ))
                        .toList(),
                    onChanged: (value) => bloc.add(ProfileFieldChanged(gender: value)),
                    decoration: modernInput(),
                    dropdownColor: Colors.white,
                  ),
                  const SizedBox(height: 16),

                  // Education Level
                  Text("Education Level", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: state.educationLevel.isNotEmpty ? state.educationLevel : null,
                    items: const ["Middle School","High School","University","Master","PhD"]
                        .map((edu) => DropdownMenuItem(
                              value: edu,
                              child: Text(edu),
                            ))
                        .toList(),
                    onChanged: (value) => bloc.add(ProfileFieldChanged(educationLevel: value)),
                    decoration: modernInput(),
                    dropdownColor: Colors.white,
                  ),
                  const SizedBox(height: 16),

                  // School (Autocomplete)
                  Text("School", style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Autocomplete<String>(
                    initialValue: TextEditingValue(text: state.school),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return getSchoolOptions();
                      }
                      return getSchoolOptions()
                          .where((option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (value) => bloc.add(ProfileFieldChanged(school: value)),
                    fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                      controller.text = state.school;
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        onEditingComplete: onEditingComplete,
                        onChanged: (val) => bloc.add(ProfileFieldChanged(school: val)),
                        decoration: modernInput(hint: "Enter your school"),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.isSaving ? null : () => bloc.add(const SaveProfile()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: state.isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                            )
                          : Text("Save Profile", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: buildBottomNavBar(4, (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeView()),
                  );
                  break;
                case 1:
                  // Search page
                  break;
                case 2:
                  // My Learning page
                  break;
                case 3:
                  // WishList page
                  break;
                case 4:
                  // Already in Account/Profile
                  break;
              }
            }),
          );
        },
      ),
    );
  }

  BottomNavigationBar buildBottomNavBar(int currentIndex, Function(int) onTap) {
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
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Featured'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'My Learning'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'WishList'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
      ],
    );
  }
}
