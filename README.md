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
│ ├── views/
│ │ ├── view_home/ # Home page with product listing
│ │ ├── view_profile/ # Profile page with lesson creation
│ │ │ └── view_model/ # Profile bloc (event, state, view_model)
│ │ ├── view_search/ # Search page
│ │ └── view_login/ # Login page
│ └── providers/ # Supabase & Auth providers
└── main.dart # App entry point

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


---

## 🎯 Current Flow

1. User signs up / logs in with Supabase.  
2. Profile is loaded → user can update info.  
3. If role = Teacher → can create lessons.  
4. Lessons are stored in Supabase → displayed on **Home**.  
5. Students can search & browse lessons.  

---

## ✅ Roadmap (Next Steps)

- [ ] Add **Wishlist** functionality.  
- [ ] Implement **My Learning** section.  
- [ ] Support **Lesson Categories** on Home.  
- [ ] Enable **Lesson Enrollment / Purchase** flow.  
- [ ] Add **Profile Picture Upload**.  
- [ ] Localization (TR/EN).  

---

## 🖼️ Screenshots (To Add Later)
- Profile Page  
- Home Page  
- Lesson Creation  
- Search Page  

---

## 📌 Installation & Run

1. Clone repository:
   ```bash
   git clone https://github.com/username/egitimciler.git
