import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egitimciler/app/views/view_login/view_model/login_event.dart';
import 'package:egitimciler/app/views/view_login/view_model/login_state.dart';
import 'package:egitimciler/app/views/view_login/view_model/login_view_model.dart';
import 'package:egitimciler/app/views/view_profile/profile_view.dart';
import 'package:egitimciler/app/views/view_signup/signup_view.dart';

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
              // Başarılı girişte snackbar göster
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('Login successful!', style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
              
              // Profile sayfasına yönlendir
              Future.delayed(Duration(milliseconds: 1500), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileView()),
                );
              });
            } else if (state.errorMessage != null) {
              // Hata durumunda snackbar göster
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.white, size: 20),
                      SizedBox(width: 8),
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
                          'please enter a valid mail',
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
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
                              onPressed: () {
                                // Şifre görünürlüğü toggle
                              },
                            ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      style: GoogleFonts.poppins(),
                    ),
                    
                    if (!isPasswordEmpty && !isValidPassword)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Password must be at least 10 characters long, contain uppercase, lowercase, and special characters',
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    
                    SizedBox(height: 16),
                    
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          _showForgotPasswordDialog(context);
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
                        onPressed: (state.isSubmitting || !isValidEmail || !isValidPassword)
                            ? null
                            : () {
                                if (isValidEmail && isValidPassword) {
                                  bloc.add(LoginSubmitted());
                                } else {
                                  String errorMessage = '';
                                  if (!isValidEmail) {
                                    errorMessage = 'Please use a valid email address';
                                  } else if (!isValidPassword) {
                                    errorMessage = 'Password must be at least 10 characters long, contain uppercase, lowercase, and special characters';
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
                            icon: Image.asset(
                              'assets/png/icons/google.png',
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.mail, color: Colors.red, size: 24);
                              },
                            ),
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
                            icon: Image.asset(
                              'assets/icons/apple.png',
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.apple, color: Colors.white, size: 24);
                              },
                            ),
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
                            icon: Image.asset(
                              'assets/icons/facebook.png',
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.facebook, color: Colors.white, size: 24);
                              },
                            ),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SignUpView()),
                              );
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
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/search');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/my_learning');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/wishlist');
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

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forgot Password', style: GoogleFonts.poppins()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your email address to reset your password',
                style: GoogleFonts.poppins(color: Colors.grey.shade600),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.poppins()),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                if (email.contains('@gmail.') || email.contains('@yahoo.')) {
                  // Şifre sıfırlama işlemi
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password reset link sent to $email'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid email address'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Send Reset Link', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
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