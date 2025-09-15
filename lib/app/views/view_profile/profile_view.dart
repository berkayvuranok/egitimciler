import 'package:egitimciler/app/views/view_home/home_view.dart';
import 'package:egitimciler/app/views/view_profile/view_model/profile_event.dart';
import 'package:egitimciler/app/views/view_profile/view_model/profile_state.dart';
import 'package:egitimciler/app/views/view_profile/view_model/profile_view_model.dart';
import 'package:egitimciler/app/views/view_search/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:egitimciler/app/l10n/app_localizations.dart';
import '../../app_provider/theme_cubit.dart'; // Dark mode cubit

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;
    final l10n = AppLocalizations.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocProvider(
      create: (_) => ProfileViewModel()
        ..add(LoadProfile(userId: currentUser?.id, email: currentUser?.email)),
      child: BlocConsumer<ProfileViewModel, ProfileState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.profileSavedSuccessfully,
                      style: const TextStyle(color: Colors.white),
                    ),
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
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<ProfileViewModel>();
          final l10n = AppLocalizations.of(context);
          final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

          // Controller'ları state'ten başlat
          final TextEditingController lessonTitleController =
              TextEditingController(text: state.lessonTitle);
          final TextEditingController lessonDescriptionController =
              TextEditingController(text: state.lessonDescription);
          final TextEditingController lessonPriceController =
              TextEditingController(text: state.lessonPrice);
          final TextEditingController lessonDurationController =
              TextEditingController(text: state.lessonDuration);

          InputDecoration modernInput({String? hint}) {
            return InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDarkMode ? Colors.blue.shade600 : Colors.blue.shade400, 
                  width: 1.5
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDarkMode ? Colors.blue.shade500 : Colors.blue.shade300, 
                  width: 1.5
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDarkMode ? Colors.blue.shade400 : Colors.blue.shade500, 
                  width: 2
                ),
              ),
              filled: true,
              fillColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
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

          Future<void> pickLessonImage(BuildContext context) async {
            final picker = ImagePicker();
            final XFile? pickedFile =
                await picker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              bloc.add(ProfileFieldChanged(lessonImage: pickedFile));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.lessonImageSelected(pickedFile.name)),
                  backgroundColor: Colors.blue,
                ),
              );
            }
          }

          void handleSaveProfile() {
            if (state.role == "Teacher") {
              bloc.add(ProfileFieldChanged(
                lessonTitle: lessonTitleController.text,
                lessonDescription: lessonDescriptionController.text,
                lessonPrice: lessonPriceController.text,
                lessonDuration: lessonDurationController.text,
              ));
            }

            bloc.add(SaveProfile(
              lessonTitle: lessonTitleController.text,
              lessonDescription: lessonDescriptionController.text,
              lessonPrice: lessonPriceController.text,
              lessonDuration: lessonDurationController.text,
              lessonImage: state.lessonImage,
            ));
          }

          return Scaffold(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            appBar: AppBar(
              title: Text(
                l10n.profile,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              backgroundColor: isDarkMode ? Colors.black : Colors.white,
              foregroundColor: isDarkMode ? Colors.white : Colors.black87,
              elevation: 0,
              iconTheme: IconThemeData(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  tooltip: l10n.logout,
                  onPressed: () => handleLogout(context),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full name
                  Text(
                    l10n.fullName,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: ValueKey('fullName_${state.fullName}'),
                    initialValue: state.fullName.isNotEmpty
                        ? state.fullName
                        : currentUser!.userMetadata?['full_name'] ?? '',
                    readOnly: true,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: modernInput(),
                  ),
                  const SizedBox(height: 16),

                  // Email
                  Text(
                    l10n.email,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: ValueKey('email_${state.email}'),
                    initialValue: state.email.isNotEmpty
                        ? state.email
                        : currentUser?.email ?? '',
                    readOnly: true,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: modernInput(),
                  ),
                  const SizedBox(height: 24),

                  // Role
                  Text(
                    l10n.role,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: state.role.isNotEmpty ? state.role : null,
                    items: const ["Teacher", "Student"]
                        .map(
                          (role) => DropdownMenuItem(
                            value: role, 
                            child: Text(
                              role == "Teacher" ? l10n.teacher : l10n.student,
                              style: TextStyle(
                                color: Colors.black, // Dropdown item text color
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        bloc.add(ProfileFieldChanged(role: value)),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: modernInput(),
                    dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Teacher-only section: Private Lesson
                  if (state.role == "Teacher") ...[
                    Text(
                      l10n.openPrivateLesson,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, 
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Lesson Image
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () => pickLessonImage(context),
                        icon: Icon(
                          Icons.photo,
                          color: isDarkMode ? Colors.black : Colors.white,
                        ),
                        label: Text(
                          l10n.selectLessonImage,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, 
                            fontSize: 16,
                            color: isDarkMode ? Colors.black : Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? Colors.blue.shade200 : Colors.blue,
                          foregroundColor: isDarkMode ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Lesson Title
                    TextFormField(
                      controller: lessonTitleController,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: modernInput(hint: l10n.enterLessonTitle),
                    ),
                    const SizedBox(height: 12),
                    // Lesson Description
                    TextFormField(
                      controller: lessonDescriptionController,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: modernInput(hint: l10n.enterLessonDescription),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    // Lesson Price
                    TextFormField(
                      controller: lessonPriceController,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: modernInput(hint: l10n.enterLessonPrice),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    // Lesson Duration
                    TextFormField(
                      controller: lessonDurationController,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: modernInput(hint: l10n.enterLessonDuration),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Gender
                  Text(
                    l10n.gender,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: state.gender.isNotEmpty ? state.gender : null,
                    items: const ["Male", "Female"]
                        .map((g) => DropdownMenuItem(
                          value: g, 
                          child: Text(
                            g == "Male" ? l10n.male : l10n.female,
                            style: TextStyle(
                              color: Colors.black, // Dropdown item text color
                            ),
                          ),
                        ))
                        .toList(),
                    onChanged: (value) =>
                        bloc.add(ProfileFieldChanged(gender: value)),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: modernInput(),
                    dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Education Level
                  Text(
                    l10n.educationLevel,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: state.educationLevel.isNotEmpty
                        ? state.educationLevel
                        : null,
                    items: const [
                      "Middle School",
                      "High School",
                      "University",
                      "Master",
                      "PhD",
                    ]
                        .map(
                          (edu) => DropdownMenuItem(
                            value: edu,
                            child: Text(
                              edu == "Middle School" ? l10n.middleSchool :
                              edu == "High School" ? l10n.highSchool :
                              edu == "University" ? l10n.university :
                              edu == "Master" ? l10n.master :
                              l10n.phd,
                              style: TextStyle(
                                color: Colors.black, // Dropdown item text color
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        bloc.add(ProfileFieldChanged(educationLevel: value)),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    decoration: modernInput(),
                    dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // School (Autocomplete)
                  Text(
                    l10n.school,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Autocomplete<String>(
                    initialValue: TextEditingValue(text: state.school),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return getSchoolOptions();
                      }
                      return getSchoolOptions().where(
                        (option) => option.toLowerCase().contains(
                          textEditingValue.text.toLowerCase(),
                        ),
                      );
                    },
                    onSelected: (value) =>
                        bloc.add(ProfileFieldChanged(school: value)),
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          color: isDarkMode ? Colors.grey[800] : Colors.white,
                          elevation: 4.0,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final String option = options.elementAt(index);
                                return InkWell(
                                  onTap: () => onSelected(option),
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      option,
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    fieldViewBuilder:
                        (context, controller, focusNode, onEditingComplete) {
                      controller.text = state.school;
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        onEditingComplete: onEditingComplete,
                        onChanged: (val) =>
                            bloc.add(ProfileFieldChanged(school: val)),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        decoration: modernInput(hint: l10n.enterYourSchool),
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.isSaving
                          ? null
                          : handleSaveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.blue.shade200 : Colors.blue,
                        foregroundColor: isDarkMode ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: state.isSaving
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: isDarkMode ? Colors.black : Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              l10n.saveProfile,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomNavBar(l10n, isDarkMode, 4, (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeView()),
                  );
                  break;
                case 1:
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchView()),
                  );
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

  BottomNavigationBar _buildBottomNavBar(AppLocalizations local, bool isDarkMode, int currentIndex, Function(int) onTap) {
    return BottomNavigationBar(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => onTap(index),
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.star), label: local.featured),
        BottomNavigationBarItem(icon: const Icon(Icons.search), label: local.search),
        BottomNavigationBarItem(icon: const Icon(Icons.menu_book), label: local.myLearning),
        BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: local.wishlist),
        BottomNavigationBarItem(icon: const Icon(Icons.account_circle), label: local.account),
      ],
    );
  }
}