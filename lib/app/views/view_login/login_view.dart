import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egitimciler/app/views/view_login/view_model/login_event.dart';
import 'package:egitimciler/app/views/view_login/view_model/login_state.dart';
import 'package:egitimciler/app/views/view_login/view_model/login_view_model.dart';
import 'package:egitimciler/app/views/view_profile/profile_view.dart';
import 'package:egitimciler/app/views/view_signup/signup_view.dart';
import 'package:egitimciler/app/l10n/app_localizations.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
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
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.school, size: 60, color: Colors.white),
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
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      locale.signInToContinue,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.06),
                    
                    // Email Field
                    Text(
                      locale.email,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (value) => bloc.add(LoginEmailChanged(value)),
                      decoration: InputDecoration(
                        hintText: locale.enterEmail,
                        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isEmailEmpty 
                              ? (isValidEmail ? Colors.green : Colors.red)
                              : Colors.grey.shade300,
                            width: !isEmailEmpty ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isEmailEmpty 
                              ? (isValidEmail ? Colors.green : Colors.red)
                              : Colors.grey.shade300,
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
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.email_outlined, 
                          color: !isEmailEmpty 
                            ? (isValidEmail ? Colors.green : Colors.red)
                            : Colors.grey.shade600,
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
                      style: GoogleFonts.poppins(),
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
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      onChanged: (value) => bloc.add(LoginPasswordChanged(value)),
                      decoration: InputDecoration(
                        hintText: locale.createPassword,
                        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isPasswordEmpty 
                              ? (isValidPassword ? Colors.green : Colors.red)
                              : Colors.grey.shade300,
                            width: !isPasswordEmpty ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isPasswordEmpty 
                              ? (isValidPassword ? Colors.green : Colors.red)
                              : Colors.grey.shade300,
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
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.lock_outline, 
                          color: !isPasswordEmpty 
                            ? (isValidPassword ? Colors.green : Colors.red)
                            : Colors.grey.shade600,
                        ),
                        suffixIcon: !isPasswordEmpty
                          ? Icon(
                              isValidPassword ? Icons.check_circle : Icons.error,
                              color: isValidPassword ? Colors.green : Colors.red,
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.visibility_outlined,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {},
                            ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      style: GoogleFonts.poppins(),
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
                          _showForgotPasswordDialog(context, locale);
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
                          backgroundColor: Colors.blue,
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
                          color: Colors.grey.shade600,
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
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
                                return const Icon(Icons.facebook, color: Colors.white, size: 24);
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
                            color: Colors.grey.shade600,
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
        }),
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

  void _showForgotPasswordDialog(BuildContext context, AppLocalizations locale) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(locale.passwordResetTitle, style: GoogleFonts.poppins()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.passwordResetHint, style: GoogleFonts.poppins(color: Colors.grey.shade600)),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: locale.email,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(locale.cancel, style: GoogleFonts.poppins()),
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
              child: Text(locale.sendResetLink, style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  BottomNavigationBar _buildBottomNavBar(BuildContext context, int currentIndex, Function(int) onTap) {
    final locale = AppLocalizations.of(context);
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black54,
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