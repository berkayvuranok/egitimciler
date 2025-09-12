import 'package:flutter/material.dart';
import 'app_localizations_en.dart' as en;
import 'app_localizations_tr.dart' as tr;

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Genel uygulama başlığı
  String get appTitle;

  // Ürün arama
  String get searchHint;
  String get noResultsFound;
  String get noProductsFound;
  String instructorLabel(String instructor);

  // Alt navbar
  String get featured;
  String get search;
  String get myLearning;
  String get wishlist;
  String get account;

  // Hesap oluşturma & kayıt
  String get createAccount;
  String get joinUs;
  String get fullName;
  String get enterFullName;
  String get nameError;
  String get pleaseEnterValidName;
  String get email;
  String get enterEmail;
  String get emailError;
  String get pleaseUseValidEmail;
  String get password;
  String get createPassword;
  String get passwordError;
  String get passwordRequirements;
  String get confirmPassword;
  String get confirmYourPassword;
  String get passwordsDoNotMatch;
  String get createAccountButton;
  String get orSignUpWith;
  String get alreadyHaveAccount;
  String get signIn;
  String get registrationSuccess;
  String get error;
  String get delete;

  // Kategoriler
  String get all;
  String get highschoolEducation;
  String get middleSchoolEducation;
  String get development;
  String get design;
  String get business;
  String get music;
  String get photography;
  String get marketing;

  // Ürün listesi başlıkları
  String get recommended;
  String get shortCourses;

  // Profile section
  String get profile;
  String get profileSavedSuccessfully;
  String get logout;
  String get role;
  String get teacher;
  String get student;
  String get openPrivateLesson;
  String get selectLessonImage;
  String get enterLessonTitle;
  String get enterLessonDescription;
  String get enterLessonPrice;
  String get enterLessonDuration;

  // Parametreli method
  String lessonImageSelected(String fileName);

  String get gender;
  String get male;
  String get female;
  String get educationLevel;
  String get middleSchool;
  String get highSchool;
  String get university;
  String get master;
  String get phd;
  String get school;
  String get enterYourSchool;
  String get saveProfile;

  // LoginView metinleri
  String get welcomeBack;
  String get signInToContinue;
  String get emailLabel;
  String get passwordLabel;
  String get forgotPassword;
  String get signInButton;
  String get orContinueWith;
  String get google;
  String get apple;
  String get facebook;
  String get dontHaveAccount;
  String get signUpLink;
  String get invalidEmailMessage;
  String get invalidPasswordMessage;
  String get passwordResetTitle;
  String get passwordResetHint;
  String get sendResetLink;
  String get cancel;
  String get passwordResetSuccess;
  //Wishlist
  String get noProductFound;
  String get loadingWishlist;
  String get wishlistError;
  String get removeFromWishlist;
  String get addedToWishlist;
}

// Delegate
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'tr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'tr':
        return tr.AppLocalizationsTr();
      case 'en':
      default:
        return en.AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
