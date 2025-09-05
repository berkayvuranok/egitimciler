import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egitimciler/app/views/view_login/view_model/login_event.dart';
import 'package:egitimciler/app/views/view_login/view_model/login_state.dart';
import 'package:egitimciler/app/views/view_login/view_model/login_view_model.dart';
import 'package:egitimciler/app/views/view_profile/profile_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<LoginViewModel, LoginState>(
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProfileView()),
              );
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            final bloc = context.read<LoginViewModel>();
            final size = MediaQuery.of(context).size;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.08),
                    
                    // Logo
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
                            child: Icon(Icons.school, size: 60, color: Colors.white),
                          );
                        },
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.04),
                    
                    // Welcome Text
                    Text(
                      'Welcome Back!',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    Text(
                      'Sign in to continue your learning journey',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.06),
                    
                    // Email Field
                    Text(
                      'Email',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      onChanged: (value) => bloc.add(LoginEmailChanged(value)),
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.poppins(),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Password Field
                    Text(
                      'Password',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      onChanged: (value) => bloc.add(LoginPasswordChanged(value)),
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.visibility_outlined,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {
                            // Şifre görünürlüğü toggle
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      style: GoogleFonts.poppins(),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Şifremi unuttum sayfasına yönlendir
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () {
                                bloc.add(LoginSubmitted());
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
                                'Sign In',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.04),
                    
                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey.shade300, thickness: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or continue with',
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey.shade300, thickness: 1),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Social Login Buttons
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
                            onPressed: () {
                              // Google ile giriş
                            },
                            icon: Icon(Icons.mail, color: Colors.red, size: 28),
                          ),
                        ),
                        
                        SizedBox(width: 16),
                        
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
                            onPressed: () {
                              // Apple ile giriş
                            },
                            icon: Icon(Icons.apple, color: Colors.white, size: 28),
                          ),
                        ),
                        
                        SizedBox(width: 16),
                        
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
                            onPressed: () {
                              // Facebook ile giriş
                            },
                            icon: Icon(Icons.facebook, color: Colors.white, size: 28),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: size.height * 0.05),
                    
                    // Sign Up Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Kayıt ol sayfasına yönlendir
                            },
                            child: Text(
                              'Sign Up',
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
                    
                    SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: _buildBottomNavBar(4, (index) {
          if (index != 4) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavBar(int currentIndex, Function(int) onTap) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black54,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
      onTap: (index) => onTap(index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.star, size: 24),
          label: 'Featured',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, size: 24),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book, size: 24),
          label: 'My Learning',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite, size: 24),
          label: 'WishList',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, size: 24),
          label: 'Account',
        ),
      ],
    );
  }
}