# 📘 Eğitimciler App

An educational platform built with **Flutter** and **Supabase** where teachers can open private lessons and students can explore and purchase them.  
The app provides **profile management, lesson creation, home product listing, search, and navigation features**.

---

## 🚀 Features

### 🔹 Authentication & Profile
- User login & signup powered by **Supabase Auth**.  
- User profile includes:  
  - Full name (auto-filled from Supabase)  
  - Email (read-only)  
  - Role selection (**Teacher / Student**)  
  - Gender selection (**Male / Female**)  
  - Education level (**Middle School, High School, University, Master, PhD**)  
  - School autocomplete (based on selected education level)  
- Logout functionality with state clearing.
- All strings are localized using AppLocalizations.of(context).

### 🔹 Teacher Features
- Teachers can create **private lessons (products)** directly from their profile:  
  - Upload **lesson image** (via ImagePicker).  
  - Add **Lesson Title, Description, and Price**.  
- Lessons are saved into **Supabase Database** (`products` table).  
- Strings like “Lesson image selected”, “Profile saved successfully”, and button labels are fully localized.
- Snackbars for **success** (green) and **error** (red) feedback.
### Student Features (My Learning)
- Students can see their enrolled courses under My Learning tab.
- Tapping a course navigates to Product Detail.
- Displays a message if no courses exist: “You have no courses yet.”
- Course enrollment handled via Supabase user_courses table with duplicate prevention (upsert).

### 🔹 Home
- Fetches all lessons (products) from Supabase.  
- Displays them dynamically as product cards.  
- Lessons created by teachers are automatically visible to all users.
- Texts like “Recommended” and “Short Courses” are localized.  

### 🔹 Search
- Search lessons by title, category, or instructor.  
- Uses Supabase queries to fetch filtered data.  
### 🔹 WishList
- - Fetches all WishLists (products) from Supabase.  
- Users can save lessons to their wishlist.
- Supports adding/removing items with proper feedback (addedToWishlist, removeFromWishlist).
- Handles empty states with localized message (noProductFound).
- Loading and error states are localized (loadingWishlist, wishlistError).


### 🔹 Navigation
- Bottom navigation bar with 5 tabs:  
  - **Featured**  
  - **Search**  
  - **My Learning**  
  - **Wishlist**  
  - **Account (Profile)** 
  - Labels are localized via AppLocalizations. 

---

## 🛠️ Tech Stack

- **Flutter** (UI & state management)  
- **Supabase** (Auth + Database + Storage)  
- **Bloc** (Profile state management)  
- **Google Fonts (Poppins)** (modern UI)  
- **ImagePicker** (image selection for lessons)
- **L10N** (multi-language support with AppLocalizations delegate)

---

## 📂 Project Structure

lib/
  app/
    l10n/
      app_localizations.dart
      app_localizations_en.dart
      app_localizations_tr.dart

    views/
      view_home/
        view_model/
          home_event.dart
          home_state.dart
          home_view_model.dart
        home_view.dart

      view_category/
        view_model/
          category_event.dart
          category_state.dart
          category_view_model.dart
        category_view.dart

      view_my_learning/
        view_model/
          my_learning_event.dart
          my_learning_state.dart
          my_learning_view_model.dart
        my_learning_view.dart

      view_product_detail/
        view_model/
          product_detail_event.dart
          product_detail_state.dart
          product_detail_view_model.dart
        product_detail_view.dart

      view_profile/
        view_model/
          profile_event.dart
          profile_state.dart
          profile_view_model.dart
        profile_view.dart

      view_search/
        view_model/
          search_event.dart
          search_state.dart
          search_view_model.dart
        search_view.dart

      view_signup/
        view_model/
          signup_event.dart
          signup_state.dart
          signup_view_model.dart
        signup_view.dart

      view_login/
        view_model/
          login_event.dart
          login_state.dart
          login_view_model.dart
        login_view.dart

      view_splash/
        view_model/
          splash_event.dart
          splash_state.dart
          splash_view_model.dart
        splash_view.dart

      view_onboarding/
        view_model/
          onboarding_event.dart
          onboarding_state.dart
          onboarding_view_model.dart
        onboarding_view.dart

      view_wishlist/
        view_model/
          wishlist_event.dart
          wishlist_state.dart
          wishlist_view_model.dart
        wishlist_view.dart

    router/
      app_router.dart

  assets/
    png/
      icons/
      onboarding/
      splash/

  main.dart



---

## 📊 Database Schema

### Users (Profiles) Table
| Column        | Type                        |
|---------------|-----------------------------|
| id            | bigint (PK)                 |
| user_id       | uuid                        |
| email         | text                        |
| password_hash | text                        |
| full_name     | text                        |
| role          | text (Teacher/Student)      |
| gender        | text                        |
| education_lvl | text                        |
| school        | text                        |
| created_at    | timestamp                   |
| updated_at    | timestamp                   |

### Products Table
| Column      | Type              |
|-------------|-------------------|
| id          | int (PK)          |
| name        | text              |
| description | text              |
| duration    | text              |
| instructor  | text              |
| image_url   | text              |
| rating      | numeric           |
| category    | text              |
| price       | text              |
| comments    | text              |
| created_at  | timestamp         |
| updated_at  | timestamp         |

### Wishlist Table
| Column      | Type      |
| ----------- | --------- |
| id          | int (PK)  |
| user\_id    | uuid      |
| product\_id | int       |
| product     | json      |
| created\_at | timestamp |
| updated\_at | timestamp |

### User Courses Table
| Column      | Type      |
| ----------- | --------- |
| id          | int (PK)  |
| user\_id    | uuid      |
| course\_id  | int       |
| created\_at | timestamp |
| updated\_at | timestamp |

---

## 🎯 Current Flow

1. User signs up / logs in with Supabase.  
2. Profile is loaded → user can update info.  
3. If role = Teacher → can create lessons.  
4. Lessons are stored in Supabase → displayed on **Home**.  
5. Students can enroll in courses (added to user_courses).
6. Students can browse My Learning to view their enrolled courses.
7. Tapping a course card navigates to Product Detail.
8. Students can search for lessons by title, instructor, or category via Search tab.
9. Students can also browse lessons by specific categories from Home page.
10. All UI strings are served from AppLocalizations, so changing the language via LocaleCubit instantly updates texts across the app.
---


## 📌 Installation & Run

1. Clone repository:
   ```bash
   git clone https://github.com/username/egitimciler.git
