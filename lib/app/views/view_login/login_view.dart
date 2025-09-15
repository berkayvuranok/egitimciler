import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egitimciler/app/views/view_login/view_model/login_event.dart';
import 'package:egitimciler/app/views/view_login/view_model/login_state.dart';
import 'package:egitimciler/app/views/view_login/view_model/login_view_model.dart';
import 'package:egitimciler/app/views/view_profile/profile_view.dart';
import 'package:egitimciler/app/views/view_signup/signup_view.dart';
import 'package:egitimciler/app/l10n/app_localizations.dart';
import '../../app_provider/theme_cubit.dart'; // Dark mode cubit

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;
    
    return BlocProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: BlocConsumer<LoginViewModel, LoginState>(
          listener: (context, state) {
            if (state.isSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text('${locale.signInButton} successful!', style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
              
              Future.delayed(const Duration(milliseconds: 1500), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileView()),
                );
              });
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(state.errorMessage!, style: GoogleFonts.poppins(color: Colors.white)),
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
            final bloc = context.read<LoginViewModel>();
            final size = MediaQuery.of(context).size;
            final bool isValidEmail = state.email.contains('@gmail.') || state.email.contains('@yahoo.');
            final bool isEmailEmpty = state.email.isEmpty;
            final bool isValidPassword = _validatePassword(state.password);
            final bool isPasswordEmpty = state.password.isEmpty;
            final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.08),
                    
                    Center(
                      child: Image.asset(
                        'assets/png/splash/splash.png',
                        width: 120,
                        height: 120,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.blue.shade700 : Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(Icons.school, size: 60, color: isDarkMode ? Colors.white : Colors.white),
                          );
                        },
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.04),
                    
                    // Welcome Text
                    Text(
                      locale.welcomeBack,
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      locale.signInToContinue,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.06),
                    
                    // Email Field
                    Text(
                      locale.email,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) => bloc.add(LoginEmailChanged(value)),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: locale.enterEmail,
                        hintStyle: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isEmailEmpty 
                              ? (isValidEmail ? Colors.green : Colors.red)
                              : isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                            width: !isEmailEmpty ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isEmailEmpty 
                              ? (isValidEmail ? Colors.green : Colors.red)
                              : isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
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
                        fillColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
                        prefixIcon: Icon(
                          Icons.email_outlined, 
                          color: !isEmailEmpty 
                            ? (isValidEmail ? Colors.green : Colors.red)
                            : isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
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
                    ),
                    
                    if (!isEmailEmpty && !isValidEmail)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          locale.emailError,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 20),
                    
                    // Password Field
                    Text(
                      locale.password,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      onChanged: (value) => bloc.add(LoginPasswordChanged(value)),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: locale.createPassword,
                        hintStyle: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isPasswordEmpty 
                              ? (isValidPassword ? Colors.green : Colors.red)
                              : isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                            width: !isPasswordEmpty ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isPasswordEmpty 
                              ? (isValidPassword ? Colors.green : Colors.red)
                              : isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
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
                        fillColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
                        prefixIcon: Icon(
                          Icons.lock_outline, 
                          color: !isPasswordEmpty 
                            ? (isValidPassword ? Colors.green : Colors.red)
                            : isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                        suffixIcon: !isPasswordEmpty
                          ? Icon(
                              isValidPassword ? Icons.check_circle : Icons.error,
                              color: isValidPassword ? Colors.green : Colors.red,
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.visibility_outlined,
                                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                              onPressed: () {},
                            ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                    
                    if (!isPasswordEmpty && !isValidPassword)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          locale.passwordError,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          _showForgotPasswordDialog(context, locale, isDarkMode);
                        },
                        child: Text(
                          locale.forgotPassword,
                          style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: (state.isSubmitting || !isValidEmail || !isValidPassword)
                            ? null
                            : () {
                                if (isValidEmail && isValidPassword) {
                                  bloc.add(LoginSubmitted());
                                } else {
                                  String errorMessage = '';
                                  if (!isValidEmail) {
                                    errorMessage = locale.emailError;
                                  } else if (!isValidPassword) {
                                    errorMessage = locale.passwordError;
                                  }
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? Colors.blue.shade200 : Colors.blue,
                          foregroundColor: isDarkMode ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        child: state.isSubmitting
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: isDarkMode ? Colors.black : Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                locale.signInButton,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    
                    Center(
                      child: Text(
                        locale.orContinueWith,
                        style: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                            ),
                            boxShadow: isDarkMode 
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
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
                                return Icon(
                                  Icons.mail, 
                                  color: isDarkMode ? Colors.white : Colors.red, 
                                  size: 24
                                );
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
                            color: isDarkMode ? Colors.grey.shade800 : Colors.black,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isDarkMode 
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
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
                                return Icon(
                                  Icons.apple, 
                                  color: isDarkMode ? Colors.white : Colors.white, 
                                  size: 24
                                );
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
                            color: isDarkMode ? Colors.blue.shade800 : const Color(0xFF1877F2),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isDarkMode 
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
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
                                return Icon(
                                  Icons.facebook, 
                                  color: isDarkMode ? Colors.white : Colors.white, 
                                  size: 24
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          locale.dontHaveAccount,
                          style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SignUpView()),
                            );
                          },
                          child: Text(
                            locale.signUpLink,
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: _buildBottomNavBar(context, 4, (index) {
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
        }, isDarkMode),
      ),
    );
  }

  bool _validatePassword(String password) {
    if (password.length < 10) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  void _showForgotPasswordDialog(BuildContext context, AppLocalizations locale, bool isDarkMode) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
          title: Text(
            locale.passwordResetTitle, 
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                locale.passwordResetHint, 
                style: GoogleFonts.poppins(
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: locale.email,
                  labelStyle: TextStyle(
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                locale.cancel, 
                style: GoogleFonts.poppins(
                  color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                if (email.contains('@gmail.') || email.contains('@yahoo.')) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${locale.passwordResetSuccess} $email'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(locale.emailError),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.blue.shade200 : Colors.blue,
                foregroundColor: isDarkMode ? Colors.black : Colors.white,
              ),
              child: Text(locale.sendResetLink, style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  BottomNavigationBar _buildBottomNavBar(BuildContext context, int currentIndex, Function(int) onTap, bool isDarkMode) {
    final locale = AppLocalizations.of(context);
    return BottomNavigationBar(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
      onTap: (index) => onTap(index),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.star, size: 24),
          label: locale.featured,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.search, size: 24),
          label: locale.search,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.menu_book, size: 24),
          label: locale.myLearning,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite, size: 24),
          label: locale.wishlist,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.account_circle, size: 24),
          label: locale.account,
        ),
      ],
    );
  }
}