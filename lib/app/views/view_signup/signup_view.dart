import 'package:egitimciler/app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:egitimciler/app/views/view_signup/view_model/signup_event.dart';
import 'package:egitimciler/app/views/view_signup/view_model/signup_state.dart';
import 'package:egitimciler/app/views/view_signup/view_model/signup_view_model.dart';
import '../../app_provider/theme_cubit.dart'; // Dark mode cubit

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get localization instance
    final l10n = AppLocalizations.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;
    
    return BlocProvider(
      create: (_) => SignUpViewModel(),
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: BlocConsumer<SignUpViewModel, SignUpState>(
          listener: (context, state) {
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l10n.registrationSuccess,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
              
              // Ana sayfaya yönlendirme - DEĞİŞİKLİK BURADA
              Future.delayed(const Duration(milliseconds: 1500), () {
                // Navigator.pop(context); // Eskisi - sadece geri dönüyordu
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  '/home', 
                  (route) => false // Tüm önceki routeları temizle
                );
              });
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        state.errorMessage!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            }
          },
          builder: (context, state) {
            final bloc = context.read<SignUpViewModel>();
            final size = MediaQuery.of(context).size;
            
            final bool isValidEmail = _validateEmail(state.email);
            final bool isEmailEmpty = state.email.isEmpty;
            final bool isValidPassword = _validatePassword(state.password);
            final bool isPasswordEmpty = state.password.isEmpty;
            final bool passwordsMatch = state.password == state.confirmPassword;
            final bool isConfirmPasswordEmpty = state.confirmPassword.isEmpty;
            final bool isValidName = state.fullName.length >= 3;
            final bool isNameEmpty = state.fullName.isEmpty;

            // Form validation for button state
            final bool isFormValid = isValidName && isValidEmail && isValidPassword && passwordsMatch;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.06),
                    
                    // Back Button
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back, 
                        color: isDarkMode ? Colors.white : Colors.grey.shade700,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // App Logo
                    Center(
                      child: Image.asset(
                        'assets/png/splash/splash.png',
                        width: 100,
                        height: 100,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.school, size: 50, color: Colors.white),
                          );
                        },
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.03),
                    
                    // Title
                    Text(
                      l10n.createAccount,
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Subtitle
                    Text(
                      l10n.joinUs,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.04),
                    
                    // Full Name Field
                    Text(
                      l10n.fullName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) => bloc.add(SignUpFullNameChanged(value)),
                      decoration: InputDecoration(
                        hintText: l10n.enterFullName,
                        hintStyle: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.white38 : Colors.grey.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isNameEmpty 
                              ? (isValidName ? Colors.green : Colors.red)
                              : (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300),
                            width: !isNameEmpty ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isNameEmpty 
                              ? (isValidName ? Colors.green : Colors.red)
                              : (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300),
                            width: !isNameEmpty ? 2 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isNameEmpty 
                              ? (isValidName ? Colors.green : Colors.blue)
                              : Colors.blue,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: isDarkMode ? Colors.grey[900] : Colors.white,
                        prefixIcon: Icon(
                          Icons.person_outline, 
                          color: !isNameEmpty 
                            ? (isValidName ? Colors.green : Colors.red)
                            : (isDarkMode ? Colors.white70 : Colors.grey.shade600),
                        ),
                        suffixIcon: !isNameEmpty
                          ? Icon(
                              isValidName ? Icons.check_circle : Icons.error,
                              color: isValidName ? Colors.green : Colors.red,
                            )
                          : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      style: GoogleFonts.poppins(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    
                    // Name validation error
                    if (!isNameEmpty && !isValidName)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          l10n.pleaseEnterValidName,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 20),
                    
                    // Email Field
                    Text(
                      l10n.email,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) => bloc.add(SignUpEmailChanged(value)),
                      decoration: InputDecoration(
                        hintText: l10n.enterEmail,
                        hintStyle: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.white38 : Colors.grey.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isEmailEmpty 
                              ? (isValidEmail ? Colors.green : Colors.red)
                              : (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300),
                            width: !isEmailEmpty ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isEmailEmpty 
                              ? (isValidEmail ? Colors.green : Colors.red)
                              : (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300),
                            width: !isEmailEmpty ? 2 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isEmailEmpty 
                              ? (isValidEmail ? Colors.green : Colors.blue)
                              : Colors.blue,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: isDarkMode ? Colors.grey[900] : Colors.white,
                        prefixIcon: Icon(
                          Icons.email_outlined, 
                          color: !isEmailEmpty 
                            ? (isValidEmail ? Colors.green : Colors.red)
                            : (isDarkMode ? Colors.white70 : Colors.grey.shade600),
                        ),
                        suffixIcon: !isEmailEmpty
                          ? Icon(
                              isValidEmail ? Icons.check_circle : Icons.error,
                              color: isValidEmail ? Colors.green : Colors.red,
                            )
                          : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.poppins(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    
                    // Email validation error
                    if (!isEmailEmpty && !isValidEmail)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          l10n.pleaseEnterValidName,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 20),
                    
                    // Password Field
                    Text(
                      l10n.password,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      onChanged: (value) => bloc.add(SignUpPasswordChanged(value)),
                      decoration: InputDecoration(
                        hintText: l10n.createPassword,
                        hintStyle: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.white38 : Colors.grey.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isPasswordEmpty 
                              ? (isValidPassword ? Colors.green : Colors.red)
                              : (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300),
                            width: !isPasswordEmpty ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isPasswordEmpty 
                              ? (isValidPassword ? Colors.green : Colors.red)
                              : (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300),
                            width: !isPasswordEmpty ? 2 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isPasswordEmpty 
                              ? (isValidPassword ? Colors.green : Colors.blue)
                              : Colors.blue,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: isDarkMode ? Colors.grey[900] : Colors.white,
                        prefixIcon: Icon(
                          Icons.lock_outline, 
                          color: !isPasswordEmpty 
                            ? (isValidPassword ? Colors.green : Colors.red)
                            : (isDarkMode ? Colors.white70 : Colors.grey.shade600),
                        ),
                        suffixIcon: !isPasswordEmpty
                          ? Icon(
                              isValidPassword ? Icons.check_circle : Icons.error,
                              color: isValidPassword ? Colors.green : Colors.red,
                            )
                          : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      style: GoogleFonts.poppins(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    
                    // Password validation error
                    if (!isPasswordEmpty && !isValidPassword)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          l10n.passwordRequirements,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 20),
                    
                    // Confirm Password Field
                    Text(
                      l10n.confirmPassword,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      onChanged: (value) => bloc.add(SignUpConfirmPasswordChanged(value)),
                      decoration: InputDecoration(
                        hintText: l10n.confirmYourPassword,
                        hintStyle: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.white38 : Colors.grey.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isConfirmPasswordEmpty 
                              ? (passwordsMatch ? Colors.green : Colors.red)
                              : (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300),
                            width: !isConfirmPasswordEmpty ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isConfirmPasswordEmpty 
                              ? (passwordsMatch ? Colors.green : Colors.red)
                              : (isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300),
                            width: !isConfirmPasswordEmpty ? 2 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isConfirmPasswordEmpty 
                              ? (passwordsMatch ? Colors.green : Colors.blue)
                              : Colors.blue,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: isDarkMode ? Colors.grey[900] : Colors.white,
                        prefixIcon: Icon(
                          Icons.lock_outline, 
                          color: !isConfirmPasswordEmpty 
                            ? (passwordsMatch ? Colors.green : Colors.red)
                            : (isDarkMode ? Colors.white70 : Colors.grey.shade600),
                        ),
                        suffixIcon: !isConfirmPasswordEmpty
                          ? Icon(
                              passwordsMatch ? Icons.check_circle : Icons.error,
                              color: passwordsMatch ? Colors.green : Colors.red,
                            )
                          : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      style: GoogleFonts.poppins(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    
                    // Confirm password validation error
                    if (!isConfirmPasswordEmpty && !passwordsMatch)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          l10n.passwordsDoNotMatch,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: (state.isSubmitting || !isFormValid)
                            ? null
                            : () {
                                if (!isFormValid) {
                                  String errorMessage = '';
                                  if (!isValidName) {
                                    errorMessage = l10n.pleaseEnterValidName;
                                  } else if (!isValidEmail) {
                                    errorMessage = l10n.pleaseUseValidEmail;
                                  } else if (!isValidPassword) {
                                    errorMessage = l10n.passwordRequirements;
                                  } else if (!passwordsMatch) {
                                    errorMessage = l10n.passwordsDoNotMatch;
                                  }
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      backgroundColor: Colors.red,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }
                                bloc.add(const SignUpSubmitted());
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFormValid ? Colors.blue : (isDarkMode ? Colors.grey[800] : Colors.grey),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        child: state.isSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                l10n.createAccount,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.04),
                    
                    // Divider with localized text
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300, 
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            l10n.orSignUpWith,
                            style: GoogleFonts.poppins(
                              color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300, 
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Social Sign Up Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey[900] : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode ? Colors.black54 : Colors.grey.shade200,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/png/icons/google.png',
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.mail, color: Colors.red, size: 24);
                              },
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Apple
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode ? Colors.black54 : Colors.grey.shade200,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/icons/apple.png',
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.apple, color: Colors.white, size: 24);
                              },
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Facebook
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1877F2),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode ? Colors.black54 : Colors.grey.shade200,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/icons/facebook.png',
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.facebook, color: Colors.white, size: 24);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: size.height * 0.04),
                    
                    // Login Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.alreadyHaveAccount,
                            style: GoogleFonts.poppins(
                              color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              l10n.signIn,
                              style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: _buildBottomNavBar(context, l10n, isDarkMode),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, AppLocalizations l10n, bool isDarkMode) {
    final user = Supabase.instance.client.auth.currentUser;

    return BottomNavigationBar(
      currentIndex: 4,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: isDarkMode ? Colors.white70 : Colors.grey.shade600,
      showUnselectedLabels: true,
      onTap: (index) {
        if (index != 4) {
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
          }
        }
      },
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.star), label: l10n.featured),
        BottomNavigationBarItem(icon: const Icon(Icons.search), label: l10n.search),
        BottomNavigationBarItem(icon: const Icon(Icons.menu_book), label: l10n.myLearning),
        BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: l10n.wishlist),
        BottomNavigationBarItem(icon: const Icon(Icons.account_circle), label: l10n.account),
      ],
    );
  }

  bool _validateEmail(String email) {
    if (!email.contains('@')) return false;
    if (!email.endsWith('@gmail.com') && !email.endsWith('@yahoo.com')) {
      return false;
    }
    return true;
  }

  bool _validatePassword(String password) {
    if (password.length < 10) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }
}