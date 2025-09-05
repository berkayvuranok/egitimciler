import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egitimciler/app/views/view_login/view_model/login_view_model.dart';
import 'package:egitimciler/app/views/view_signup/view_model/signup_event.dart';
import 'package:egitimciler/app/views/view_signup/view_model/signup_state.dart';
import 'package:egitimciler/app/views/view_signup/view_model/signup_view_model.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<SignUpViewModel, SignUpState>(
          listener: (context, state) {
            if (state.isSuccess) {
              // Başarılı kayıtta snackbar göster
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('Registration successful! Please sign in.', 
                          style: GoogleFonts.poppins(color: Colors.white)),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
              
              // 1.5 saniye sonra login sayfasına dön
              Future.delayed(Duration(milliseconds: 1500), () {
                Navigator.pop(context);
              });
            } else if (state.errorMessage != null) {
              // Hata durumunda snackbar göster
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(state.errorMessage!, 
                          style: GoogleFonts.poppins(color: Colors.white)),
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
            
            // Validasyon kontrolü
            final bool isValidEmail = state.email.contains('@');
            final bool isEmailEmpty = state.email.isEmpty;
            final bool isValidPassword = _validatePassword(state.password);
            final bool isPasswordEmpty = state.password.isEmpty;
            final bool passwordsMatch = state.password == state.confirmPassword;
            final bool isConfirmPasswordEmpty = state.confirmPassword.isEmpty;
            final bool isValidName = state.fullName.length >= 3;
            final bool isNameEmpty = state.fullName.isEmpty;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.06),
                    
                    // Back Button
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.grey.shade700),
                      onPressed: () => Navigator.pop(context),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Logo
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
                            child: Icon(Icons.school, size: 50, color: Colors.white),
                          );
                        },
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.03),
                    
                    // Welcome Text
                    Text(
                      'Create Account',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: 8),
                    
                    Text(
                      'Join us to start your learning journey',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    
                    SizedBox(height: size.height * 0.04),
                    
                    // Full Name Field
                    Text(
                      'Full Name',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      onChanged: (value) => bloc.add(SignUpFullNameChanged(value)),
                      decoration: InputDecoration(
                        hintText: "Enter your full name",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isNameEmpty 
                              ? (isValidName ? Colors.green : Colors.red)
                              : Colors.grey.shade300,
                            width: !isNameEmpty ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isNameEmpty 
                              ? (isValidName ? Colors.green : Colors.red)
                              : Colors.grey.shade300,
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
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.person_outline, 
                          color: !isNameEmpty 
                            ? (isValidName ? Colors.green : Colors.red)
                            : Colors.grey.shade600,
                        ),
                        suffixIcon: !isNameEmpty
                          ? Icon(
                              isValidName ? Icons.check_circle : Icons.error,
                              color: isValidName ? Colors.green : Colors.red,
                            )
                          : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      style: GoogleFonts.poppins(),
                    ),
                    
                    if (!isNameEmpty && !isValidName)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Name must be at least 3 characters long',
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    
                    SizedBox(height: 20),
                    
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
                      onChanged: (value) => bloc.add(SignUpEmailChanged(value)),
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
                          'Please enter a valid email address',
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
                      onChanged: (value) => bloc.add(SignUpPasswordChanged(value)),
                      decoration: InputDecoration(
                        hintText: "Create a password",
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
                          : null,
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
                    
                    SizedBox(height: 20),
                    
                    // Confirm Password Field
                    Text(
                      'Confirm Password',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      onChanged: (value) => bloc.add(SignUpConfirmPasswordChanged(value)),
                      decoration: InputDecoration(
                        hintText: "Confirm your password",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isConfirmPasswordEmpty 
                              ? (passwordsMatch ? Colors.green : Colors.red)
                              : Colors.grey.shade300,
                            width: !isConfirmPasswordEmpty ? 2 : 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: !isConfirmPasswordEmpty 
                              ? (passwordsMatch ? Colors.green : Colors.red)
                              : Colors.grey.shade300,
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
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.lock_outline, 
                          color: !isConfirmPasswordEmpty 
                            ? (passwordsMatch ? Colors.green : Colors.red)
                            : Colors.grey.shade600,
                        ),
                        suffixIcon: !isConfirmPasswordEmpty
                          ? Icon(
                              passwordsMatch ? Icons.check_circle : Icons.error,
                              color: passwordsMatch ? Colors.green : Colors.red,
                            )
                          : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      style: GoogleFonts.poppins(),
                    ),
                    
                    if (!isConfirmPasswordEmpty && !passwordsMatch)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Passwords do not match',
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    
                    SizedBox(height: 24),
                    
                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: (state.isSubmitting || !isValidName || !isValidEmail || !isValidPassword || !passwordsMatch)
                            ? null
                            : () {
                                if (isValidName && isValidEmail && isValidPassword && passwordsMatch) {
                                  bloc.add(SignUpSubmitted());
                                } else {
                                  String errorMessage = '';
                                  if (!isValidName) {
                                    errorMessage = 'Please enter a valid name';
                                  } else if (!isValidEmail) {
                                    errorMessage = 'Please enter a valid email address';
                                  } else if (!isValidPassword) {
                                    errorMessage = 'Password must be at least 10 characters long, contain uppercase, lowercase, and special characters';
                                  } else if (!passwordsMatch) {
                                    errorMessage = 'Passwords do not match';
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
                                'Create Account',
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
                            'Or sign up with',
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
                    
                    // Social Sign Up Buttons
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
                              // Google ile kayıt
                            },
                            icon: Image.asset(
                              'assets/icons/google.png',
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
                              // Apple ile kayıt
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
                              // Facebook ile kayıt
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
                    
                    SizedBox(height: size.height * 0.04),
                    
                    // Login Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Sign In',
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
}