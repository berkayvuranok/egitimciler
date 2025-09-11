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

### 🔹 Teacher Features
- Teachers can create **private lessons (products)** directly from their profile:  
  - Upload **lesson image** (via ImagePicker).  
  - Add **Lesson Title, Description, and Price**.  
- Lessons are saved into **Supabase Database** (`products` table).  
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

### 🔹 Search
- Search lessons by title, category, or instructor.  
- Uses Supabase queries to fetch filtered data.  

### 🔹 Navigation
- Bottom navigation bar with 5 tabs:  
  - **Featured**  
  - **Search**  
  - **My Learning**  
  - **Wishlist**  
  - **Account (Profile)**  

---

## 🛠️ Tech Stack

- **Flutter** (UI & state management)  
- **Supabase** (Auth + Database + Storage)  
- **Bloc** (Profile state management)  
- **Google Fonts (Poppins)** (modern UI)  
- **ImagePicker** (image selection for lessons)  

---

## 📂 Project Structure

lib/
├── app/
│   ├── views/
│   │   ├── view_home/
│   │   │   ├── view_model/
│   │   │   │   ├── home_event.dart
│   │   │   │   ├── home_state.dart
│   │   │   │   └── home_view_model.dart
│   │   │   └── home_view.dart
│   │   │
│   │   ├── view_category/
│   │   │   ├── view_model/
│   │   │   │   ├── category_event.dart
│   │   │   │   ├── category_state.dart
│   │   │   │   └── category_view_model.dart
│   │   │   └── category_view.dart
│   │   │
│   │   ├── view_my_learning/
│   │   │   ├── view_model/
│   │   │   │   ├── my_learning_event.dart
│   │   │   │   ├── my_learning_state.dart
│   │   │   │   └── my_learning_view_model.dart
│   │   │   └── my_learning_view.dart
│   │   │
│   │   ├── view_product_detail/
│   │   │   ├── view_model/  # boş veya ileride ekleme için
│   │   │   └── product_detail_view.dart
│   │   │
│   │   ├── view_profile/
│   │   │   ├── view_model/  # boş veya profile event/state olabilir
│   │   │   └── profile_view.dart
│   │   │
│   │   ├── view_search/
│   │   │   ├── view_model/  # boş veya search event/state olabilir
│   │   │   └── search_view.dart
│   │   │
│   │   ├── view_signup/
│   │   │   ├── view_model/  # boş veya signup event/state olabilir
│   │   │   └── signup_view.dart
│   │   │
│   │   ├── view_login/
│   │   │   ├── view_model/  # boş veya login event/state olabilir
│   │   │   └── login_view.dart
│   │   │
│   │   ├── view_splash/
│   │   │   ├── view_model/  # boş veya splash event/state olabilir
│   │   │   └── splash_view.dart
│   │   │
│   │   ├── view_onboarding/
│   │   │   ├── view_model/  # boş veya onboarding event/state olabilir
│   │   │   └── onboarding_view.dart
│   │   │
│   │   └── view_wishlist/
│   │       ├── view_model/
│   │       │   ├── wishlist_event.dart
│   │       │   ├── wishlist_state.dart
│   │       │   └── wishlist_view_model.dart
│   │       └── wishlist_view.dart
│   │
│   └── router/
│       └── app_router.dart
│
├── assets/
│   ├── png/
│   │   ├── icons/          # tüm ikonlar
│   │   ├── onboarding/     # onboarding ekranları
│   │   └── splash/         # splash ekranları
│
└── main.dart


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
---


## 📌 Installation & Run

1. Clone repository:
   ```bash
   git clone https://github.com/username/egitimciler.git
