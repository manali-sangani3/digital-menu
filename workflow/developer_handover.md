# Developer Handover & Workflow Document

**Project:** DigitalMenu  
**Version:** 1.0  
**Date:** 2026-06-11  
**Prepared By:** Senior Flutter Architect  
**Audience:** New developers, maintainers, QA engineers  
**Hosting URLs:**  
* https://digital-menu-prod-2026.firebaseapp.com  
* https://digital-menu-prod-2026.web.app
---

## 1. Project Overview

### Project Name
**DigitalMenu** — A QR-code-accessible, browser-based café digital menu system.

### Business Purpose
To replace a traditional paper-based café menu with a real-time, mobile-accessible digital experience. Customers scan a printed QR code at their table and instantly browse dish categories, prices, and photos — no app download required. The café owner manages the menu through a secure admin portal.

### Problem Statement
A café relies on physical paper menus, making it slow and costly to update dish information. Whenever prices change or new dishes are added, the café must reprint and redistribute menus. Customers who prefer a digital experience are underserved, and the owner bears recurring operational costs.

### Solution Summary
A Flutter Web application deployed on a local or cloud-hosted server, backed by Firebase Firestore for real-time data. A QR code on each table links to the customer-facing menu URL. The admin portal is protected by Firebase Authentication and allows the owner to add, edit, and delete dishes with name, price, photo, and category. Changes propagate instantly to all live customer views via Firestore real-time streams.

### Key Features

| Feature | Description |
|---------|-------------|
| QR Code Entry | Unique QR code displayed on a simulated table stand; opens menu in the mobile browser without requiring app download |
| Categorised Menu Display | Dishes grouped by category (Breakfast, Drinks, Desserts) with name, price, and photo on each card |
| Real-Time Updates | All Firestore changes propagate instantly to the customer view via stream listeners |
| Admin Authentication | Firebase Email/Password authentication securing the admin panel |
| Add Dish | Admin form with name, price, photo upload (Base64), category selection, and full validation |
| Edit Dish | Pre-filled edit dialog; preserves existing photo if no new image is selected |
| Delete Dish | Confirmation dialog before permanent Firestore deletion |
| Form Validation | Field-level error messages; rejects incomplete submissions |
| Image Validation | Accepts only JPG, PNG, WebP; enforces 600 KB size limit for Firestore compatibility |
| Session Guard | GoRouter redirect guard prevents unauthenticated access to `/admin` routes |
| Photo Fallback | `CachedNetworkImage` placeholder shown on failed image loads; Base64 data URIs decoded via `Image.memory` |
| Shimmer Loading | Shimmer skeleton shown while categories and dishes are fetching from Firestore |

---

## 2. Technology Stack

| Layer | Technologies |
|-------|-------------|
| Frontend | Flutter 3.x (Web target), Dart 3.x |
| State Management | flutter_bloc 8.x — Cubit pattern |
| Navigation | go_router 14.x with redirect guards |
| Backend / Database | Firebase Firestore (real-time streams), Firebase Authentication |
| Image Handling | client-side Base64 encoding (no Firebase Storage), cached_network_image for URL-based images |
| Dependency Injection | get_it 8.x — lazy singletons and factories |
| Code Generation | freezed + json_serializable via build_runner |
| File Picker | file_picker 8.x (web-compatible) |
| QR Code | qr_flutter 4.x |
| Testing | flutter_test, bloc_test, mocktail |
| Linting | flutter_lints 5.x |

---

## 3. Architecture Overview

### High-Level Architecture

```
┌──────────────────────────────────────────────────────────┐
│                     Flutter Web App                       │
│  ┌────────────┐   ┌─────────────┐   ┌─────────────────┐  │
│  │ Customer   │   │ Admin Panel │   │ GoRouter + Auth │  │
│  │ Menu Pages │   │ Pages       │   │ Guard           │  │
│  └─────┬──────┘   └──────┬──────┘   └────────┬────────┘  │
│        │                 │                   │           │
│  ┌─────▼─────────────────▼───────────────────▼────────┐  │
│  │              Cubit / State Management              │  │
│  │  MenuCubit │ AdminDishCubit │ AuthCubit            │  │
│  └─────────────────────┬──────────────────────────────┘  │
│                        │ Use Cases                        │
│  ┌─────────────────────▼──────────────────────────────┐  │
│  │             Domain Layer (Use Cases)               │  │
│  │  GetCategories │ GetDishesByCategory │ AddDish     │  │
│  │  UpdateDish │ DeleteDish │ UploadImage │ Login      │  │
│  └─────────────────────┬──────────────────────────────┘  │
│                        │ Repositories                     │
│  ┌─────────────────────▼──────────────────────────────┐  │
│  │             Data Layer (Repositories)              │  │
│  │  MenuRepositoryImpl │ AuthRepositoryImpl           │  │
│  └─────────────────────┬──────────────────────────────┘  │
│                        │ Remote Data Sources              │
│  ┌─────────────────────▼──────────────────────────────┐  │
│  │         Remote Data Sources (Firestore / Auth)     │  │
│  │  MenuRemoteDataSourceImpl │ AuthRemoteDataSourceImpl│  │
│  └─────────────────────┬──────────────────────────────┘  │
└────────────────────────┼─────────────────────────────────┘
                         │
           ┌─────────────▼──────────────┐
           │       Firebase Cloud        │
           │  Firestore │ Firebase Auth  │
           └────────────────────────────┘
```

### Request / Data Flow

**Customer reads menu:**
1. Browser navigates to `/#/menu`
2. `MenuPage` creates `MenuCubit` and calls `loadMenu()`
3. `MenuCubit` subscribes to `GetCategoriesUseCase` stream
4. Firestore `categories` collection streams updates via `MenuRemoteDataSourceImpl`
5. Categories list appears; first category is auto-selected
6. `MenuCubit` subscribes to `GetDishesByCategoryUseCase` for selected category
7. `DishCard` widgets render with photos (Base64 or network URL)

**Admin adds/edits a dish:**
1. Admin navigates to `/#/admin/login`, authenticates via `AuthCubit.login()`
2. GoRouter redirect guard checks `AuthStatus`; redirects to `/#/admin` on success
3. Admin opens `AddDishDialog`, fills form fields
4. On submit, `AdminDishCubit.createDish()` or `editDish()` is called
5. Image bytes are encoded to Base64 data URI via `UploadDishImageUseCase`
6. Dish is written to Firestore via `MenuRepositoryImpl.addDish()` or `updateDish()`
7. All `MenuCubit` stream subscribers across all open tabs receive the update instantly

### Major Components

| Component | File | Responsibility |
|-----------|------|----------------|
| `DigitalMenuApp` | `lib/app.dart` | Root widget; provides `AuthCubit` and `MaterialApp.router` |
| `appRouter` | `lib/core/router/router.dart` | GoRouter config with redirect guard for admin routes |
| `MenuCubit` | `lib/features/menu/presentation/bloc/menu_cubit.dart` | Streams categories and dishes from Firestore |
| `AuthCubit` | `lib/features/admin/presentation/controllers/auth_cubit.dart` | Monitors FirebaseAuth state, handles login/logout |
| `AdminDishCubit` | `lib/features/admin/presentation/controllers/admin_dish_cubit.dart` | Orchestrates create, edit, and delete dish operations |
| `MenuRemoteDataSourceImpl` | `lib/features/menu/data/datasources/menu_remote_datasource.dart` | Firestore stream and write operations for dishes/categories |
| `AuthRemoteDataSourceImpl` | `lib/features/admin/data/datasources/auth_remote_datasource.dart` | Firebase Auth sign-in, sign-out, auth state stream |
| `DatabaseSeeder` | `lib/core/utils/database_seeder.dart` | Seeds initial categories and dishes if Firestore is empty |

### External Integrations

| Integration | Purpose |
|-------------|---------|
| Firebase Firestore | Real-time NoSQL database for categories and dishes |
| Firebase Authentication | Email/Password authentication for admin access |
| Unsplash CDN | Seed dish photo URLs (used only for initial demo data) |

---

## 4. Project Structure

```
digital_menu/
├── lib/
│   ├── main.dart                         # App entry point; Firebase init + DI init
│   ├── app.dart                          # Root DigitalMenuApp widget + router config
│   ├── core/
│   │   ├── config/
│   │   │   └── firebase_options.dart     # Generated Firebase config (do not edit manually)
│   │   ├── constants/
│   │   │   └── constants.dart            # Firestore collection name constants
│   │   ├── di/
│   │   │   └── di.dart                   # GetIt service locator registrations
│   │   ├── errors/
│   │   │   └── failures.dart             # Failure type hierarchy (ServerFailure, etc.)
│   │   ├── network/
│   │   │   ├── cloud_result.dart         # Generic result wrapper (statusCode, data, message)
│   │   │   └── network_info.dart         # Network connectivity utility
│   │   ├── router/
│   │   │   └── router.dart               # GoRouter instance with auth redirect guard
│   │   ├── theme/
│   │   │   └── theme.dart                # Material 3 theme (Coffee Brown palette)
│   │   └── utils/
│   │       └── database_seeder.dart      # One-time Firestore seed for demo data
│   ├── features/
│   │   ├── admin/                        # Admin feature (auth + dish management)
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── auth_remote_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── login_usecase.dart
│   │   │   │       ├── logout_usecase.dart
│   │   │   │       └── stream_user_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── controllers/
│   │   │       │   ├── admin_dish_cubit.dart
│   │   │       │   ├── admin_dish_state.dart
│   │   │       │   ├── auth_cubit.dart
│   │   │       │   └── auth_state.dart
│   │   │       ├── pages/
│   │   │       │   ├── admin_login_page.dart
│   │   │       │   └── admin_page.dart
│   │   │       └── widgets/
│   │   │           ├── add_dish_dialog.dart  # Dual-mode Add/Edit dialog
│   │   │           └── admin_dish_card.dart  # Card with edit/delete overlays
│   │   └── menu/                         # Customer menu feature
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── menu_remote_datasource.dart
│   │       │   ├── models/
│   │       │   │   ├── dish_model.dart        # Freezed model + Firestore mapping
│   │       │   │   └── menu_category_model.dart
│   │       │   └── repositories/
│   │       │       └── menu_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   ├── dish.dart
│   │       │   │   └── menu_category.dart
│   │       │   ├── repositories/
│   │       │   │   └── menu_repository.dart
│   │       │   └── usecases/
│   │       │       ├── add_dish_usecase.dart
│   │       │       ├── delete_dish_usecase.dart
│   │       │       ├── get_categories.dart
│   │       │       ├── get_dishes_by_category.dart
│   │       │       ├── update_dish_usecase.dart
│   │       │       └── upload_dish_image_usecase.dart
│   │       └── presentation/
│   │           ├── bloc/
│   │           │   ├── menu_cubit.dart
│   │           │   └── menu_state.dart
│   │           ├── pages/
│   │           │   ├── home_page.dart    # QR code display / table stand page
│   │           │   └── menu_page.dart   # Customer menu with category/dish browsing
│   │           └── widgets/
│   │               └── dish_card.dart   # Customer-facing dish card
│   └── shared/
│       └── widgets/
│           └── shimmer_loader.dart      # Loading skeleton animation
└── test/
    ├── features/
    │   └── admin/
    │       └── presentation/
    │           └── controllers/
    │               └── admin_dish_cubit_test.dart  # Unit tests for edit/delete
    └── widget_test.dart                            # Smoke test for home screen
```

### Key Folders Explained

| Folder | Purpose |
|--------|---------|
| `lib/core/di/` | All GetIt registrations in a single `init()` function called at app startup |
| `lib/core/router/` | GoRouter configuration; the `redirect` function enforces admin authentication |
| `lib/features/*/domain/` | Pure Dart classes with no Flutter or Firebase dependencies; business logic only |
| `lib/features/*/data/` | Implements domain contracts; maps Firestore documents ↔ domain entities |
| `lib/features/*/presentation/` | Flutter widgets, pages, and Cubit state machines |
| `lib/shared/widgets/` | Reusable widgets used across multiple features |

---

## 5. Module Summary

| Module | Purpose | Key Components | Dependencies |
|--------|---------|----------------|-------------|
| Menu (Customer) | Displays categories and dish cards to customers in real time | `MenuCubit`, `MenuPage`, `DishCard`, `MenuRemoteDataSourceImpl` | Firestore, `GetCategoriesUseCase`, `GetDishesByCategoryUseCase` |
| Admin Auth | Authenticates the café owner and manages session state | `AuthCubit`, `AuthState`, `AdminLoginPage`, `AuthRemoteDataSourceImpl` | Firebase Auth, `LoginUseCase`, `LogoutUseCase`, `StreamUserUseCase` |
| Admin Dish Management | Enables the admin to create, update, and delete dishes | `AdminDishCubit`, `AdminPage`, `AddDishDialog`, `AdminDishCard` | `AddDishUseCase`, `UpdateDishUseCase`, `DeleteDishUseCase`, `UploadDishImageUseCase` |
| QR Code Entry | Displays a clickable QR code pointing to the menu URL | `HomePage`, `qr_flutter` | `go_router` for navigation |
| Core / DI | Wires all dependencies at startup | `di.dart`, `cloud_result.dart`, `failures.dart` | `get_it`, `firebase_core` |
| Database Seeder | Seeds Firestore with demo data on first launch | `DatabaseSeeder` | Firestore |

---

## 6. Database Overview

### Firestore Collections

| Collection | Purpose | Relationships |
|------------|---------|---------------|
| `categories` | Stores dish categories (e.g., Breakfast, Drinks, Desserts) | Referenced by `dishes.categoryId` |
| `dishes` | Stores all dish entries with name, price, photo, and category reference | Belongs to one `category` via `categoryId` |

### Collection Schemas

**`categories` document:**
```json
{
  "id": "<auto-generated Firestore document ID>",
  "name": "Breakfast"
}
```

**`dishes` document:**
```json
{
  "id": "<auto-generated Firestore document ID>",
  "name": "Avocado Toast",
  "price": 180.0,
  "photoUrl": "data:image/jpeg;base64,...  OR  https://images.unsplash.com/...",
  "categoryId": "<categories document ID>"
}
```

### Image Storage Strategy

Firebase Storage is **not used** in this version. Images uploaded by the admin are converted to **Base64 data URIs** on the client and stored directly in the `photoUrl` field of Firestore documents.

- **Constraint:** Each uploaded image must be **< 600 KB** to keep Firestore document size below its 1 MB limit.
- **Seed data** uses Unsplash CDN URLs (`https://images.unsplash.com/...`) for the initial demo dishes.
- **Rendering:** `DishCard` and `AdminDishCard` detect whether `photoUrl` starts with `data:image` and use `Image.memory(base64Decode(...))` or `CachedNetworkImage` accordingly.

---

## 7. CRUD Overview

### Firestore Operations

| Operation | Firestore Method | Collection | Auth Required | Use Case |
|-----------|-----------------|------------|---------------|----------|
| Stream all categories | `snapshots()` on `categories` collection | `categories` | No | `GetCategoriesUseCase` |
| Stream dishes by category | `where('categoryId', ==, id).snapshots()` | `dishes` | No | `GetDishesByCategoryUseCase` |
| Add a dish | `_dishesRef.add(dish)` | `dishes` | Yes (Admin) | `AddDishUseCase` |
| Update a dish | `_dishesRef.doc(id).set(dish)` | `dishes` | Yes (Admin) | `UpdateDishUseCase` |
| Delete a dish | `_dishesRef.doc(id).delete()` | `dishes` | Yes (Admin) | `DeleteDishUseCase` |
| Encode image to Base64 | Client-side `base64Encode(fileBytes)` | — | Yes (Admin) | `UploadDishImageUseCase` |

### Authentication Flow

| Step | Description |
|------|-------------|
| 1. Admin navigates to `/#/admin` | GoRouter redirect guard checks `AuthStatus`; if `unauthenticated`, redirects to `/#/admin/login` |
| 2. Admin submits credentials | `AuthCubit.login()` calls `LoginUseCase` → `AuthRepositoryImpl.signIn()` → `FirebaseAuth.signInWithEmailAndPassword()` |
| 3. Firebase Auth responds | `AuthRemoteDataSourceImpl.streamCurrentUser()` stream emits the authenticated `User` |
| 4. `AuthCubit` emits `authenticated` | `GoRouterRefreshStream` triggers router re-evaluation; guard redirects to `/#/admin` |
| 5. Admin logs out | `AuthCubit.logout()` → `LogoutUseCase` → `FirebaseAuth.signOut()`; guard redirects back to `/#/admin/login` |
| 6. Session expiry | Firebase Auth emits `null` user; `AuthCubit` emits `unauthenticated`; guard redirects to login |

---

## 8. Environment & Setup

### Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Flutter SDK | ≥ 3.x (Dart 3.x) | Application framework |
| Google Chrome | Latest | Web development and debugging |
| Firebase CLI | Latest | Firebase project management |
| Node.js (for Firebase CLI) | ≥ 18 | Required by Firebase CLI |

### Firebase Project Configuration

The project uses Firebase project **`digital-menu-prod-2026`**. The configuration is stored in:

```
lib/core/config/firebase_options.dart
```

This file is **auto-generated** by `flutterfire configure`. Do **not** edit it manually. To regenerate:

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=digital-menu-prod-2026
```

### Admin Account Setup

The admin login uses Firebase Authentication (Email/Password). Create an account in the Firebase Console:

1. Go to [Firebase Console](https://console.firebase.google.com) → Select project `digital-menu-prod-2026`
2. Navigate to **Authentication → Users → Add user**
3. Set email and password (minimum 6 characters)
4. Use these credentials on the `/#/admin/login` page

> **Default demo credentials (if already set up):**  
> Email: `admin@menu.com`  
> Password: `admin1234`

### Firestore Security Rules

Recommended rules for the `digital-menu-prod-2026` project:

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Public read for categories and dishes
    match /categories/{docId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    match /dishes/{docId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### Installation Steps

```bash
# 1. Clone the repository
git clone <repository-url>
cd vibe-coding-poc/digital_menu

# 2. Install Flutter dependencies
flutter pub get

# 3. Generate code (Freezed models, JSON serializers)
dart run build_runner build --delete-conflicting-outputs
```

### Local Development

```bash
# Run on Chrome (recommended for web)
flutter run -d chrome --web-port=50578

# Run with specific hostname for local network testing (QR code)
flutter run -d chrome --web-port=50578 --web-hostname=0.0.0.0
```

### Build Commands

```bash
# Build optimised web bundle for deployment
flutter build web --release
# Output directory: build/web/
```

### Run Commands

| Command | Purpose |
|---------|---------|
| `flutter run -d chrome` | Launch in Chrome (debug mode, hot reload) |
| `flutter run -d chrome --web-port=50578` | Launch on a fixed port |
| `flutter test` | Run all unit and widget tests |
| `flutter analyze` | Run static analysis |
| `dart run build_runner build` | Regenerate Freezed/JSON code |

---

## 9. Business Workflows

### Workflow 1: Customer Browses Menu

**Purpose:** Allow a café customer to view dishes without any authentication.

| Step | Action |
|------|--------|
| 1 | Customer scans QR code at table (or clicks QR card on `/#/`) |
| 2 | Browser navigates to `/#/menu` |
| 3 | `MenuCubit.loadMenu()` streams categories from Firestore |
| 4 | First category is automatically selected |
| 5 | `MenuCubit.selectCategory()` streams dishes for the selected category |
| 6 | `DishCard` widgets render name, price, and photo |
| 7 | Customer taps category chips to switch categories |

**Validation Rules:**
- If a category has no dishes, the message "No items available in this category" is shown.
- If a photo fails to load (network image), a placeholder broken image icon is displayed.
- If Firestore is unreachable, an error banner with a Retry button is shown.

**Expected Outcome:** Customer can browse all available dishes instantly, in real time.

---

### Workflow 2: Admin Logs In

**Purpose:** Authenticate the café owner to access the admin panel.

| Step | Action |
|------|--------|
| 1 | Owner navigates to `/#/admin` |
| 2 | GoRouter guard detects `AuthStatus.unauthenticated`, redirects to `/#/admin/login` |
| 3 | Owner enters email and password |
| 4 | `AuthCubit.login()` calls Firebase Auth |
| 5 | On success, `AuthCubit` emits `AuthStatus.authenticated` |
| 6 | `GoRouterRefreshStream` triggers re-evaluation; guard redirects to `/#/admin` |

**Validation Rules:**
- Both email and password fields are required.
- Firebase returns a human-readable error message on invalid credentials (`wrong-password`, `user-not-found`).
- A loading spinner replaces the login button during authentication.

**Expected Outcome:** Admin accesses the Admin Dashboard at `/#/admin`.

---

### Workflow 3: Admin Adds a New Dish

**Purpose:** Publish a new dish entry to the live menu.

| Step | Action |
|------|--------|
| 1 | Admin clicks "Add Dish" button on the Admin Dashboard |
| 2 | `AddDishDialog` opens in Add mode (empty form) |
| 3 | Admin fills Dish Name, Price, selects Category from dropdown |
| 4 | Admin clicks "Choose Image" and selects a JPG/PNG/WebP file < 600 KB |
| 5 | Admin clicks "Save Dish" |
| 6 | `AdminDishCubit.createDish()` encodes image to Base64 via `UploadDishImageUseCase` |
| 7 | Dish is written to Firestore via `AddDishUseCase` |
| 8 | Dialog closes; success snackbar appears |
| 9 | New dish appears on Admin Dashboard and customer `/#/menu` immediately |

**Validation Rules:**
- Name, price, photo, and category are all required.
- Price must be a positive number.
- Image must be JPG, PNG, or WebP and less than 600 KB.
- Unsupported formats show: "Only JPG, PNG, and WebP formats are accepted."
- Oversized files show: "Image must be smaller than 600 KB."

**Expected Outcome:** Dish appears on the live customer menu within seconds.

---

### Workflow 4: Admin Edits an Existing Dish

**Purpose:** Update dish details (name, price, category, or photo).

| Step | Action |
|------|--------|
| 1 | Admin clicks the pencil (edit) icon on any `AdminDishCard` |
| 2 | `AddDishDialog` opens in Edit mode, pre-filled with existing dish data |
| 3 | Admin modifies desired fields |
| 4 | If changing photo: selects new image file (< 600 KB, JPG/PNG/WebP) |
| 5 | Admin clicks "Update Dish" |
| 6 | `AdminDishCubit.editDish()` encodes new image if selected, or retains existing `photoUrl` |
| 7 | Firestore document is updated via `UpdateDishUseCase` using `_dishesRef.doc(id).set(dish)` |
| 8 | Dialog closes; "Dish updated successfully!" snackbar appears |
| 9 | Updated dish reflects immediately on Admin Dashboard and customer `/#/menu` |

**Validation Rules:**
- Same validation as Add Dish for form fields.
- Photo is optional in edit mode; if no new image is selected, existing `photoUrl` is preserved.

**Expected Outcome:** Dish shows updated information on all open views within seconds.

---

### Workflow 5: Admin Deletes a Dish

**Purpose:** Permanently remove a dish from the menu.

| Step | Action |
|------|--------|
| 1 | Admin clicks the trash (delete) icon on any `AdminDishCard` |
| 2 | Confirmation `AlertDialog` appears: "Are you sure you want to delete '[Dish Name]'?" |
| 3 | Admin clicks "Delete" to confirm |
| 4 | `AdminDishCubit.deleteDish(dishId)` is called |
| 5 | Firestore document is deleted via `DeleteDishUseCase` |
| 6 | "Operation completed successfully." snackbar appears |
| 7 | Dish disappears from Admin Dashboard and customer `/#/menu` in real time |

**Validation Rules:**
- Deletion requires explicit confirmation (Cancel aborts the operation).
- If Firestore deletion fails, an error snackbar is shown with the error message.

**Expected Outcome:** Dish is permanently removed from all views immediately.

---

## 10. Security & Error Handling

### Authentication & Authorization

| Mechanism | Implementation |
|-----------|----------------|
| Authentication provider | Firebase Email/Password |
| Session monitoring | `FirebaseAuth.authStateChanges()` stream; `AuthCubit` always reflects live auth state |
| Route protection | GoRouter `redirect` callback checks `AuthStatus`; all `/admin*` routes redirect to `/admin/login` if unauthenticated |
| Authenticated redirect | If authenticated user visits `/admin/login`, they are redirected to `/admin` |
| Session expiry | Firebase Auth token automatically invalidates; stream emits `null` user; `AuthCubit` emits `unauthenticated`; GoRouter triggers redirect to login |
| Admin singleton | `AuthCubit` is registered as `registerLazySingleton` in `di.dart` to ensure a single shared auth state across the router guard and widget tree |

### Sensitive Data Handling

| Data | Handling |
|------|---------|
| Admin password | Never stored in code; managed entirely by Firebase Auth |
| Firebase config | Stored in `firebase_options.dart` (generated); commit to version control as it is client-facing web config |
| Base64 image data | Stored in Firestore `photoUrl` field; no separate secret handling required |

### Validation Strategy

| Layer | Validation |
|-------|-----------|
| Form (UI) | `TextFormField.validator` checks for empty names, valid positive prices, and selected categories |
| Image (UI) | Extension whitelist `['jpg','jpeg','png','webp']` and 600 KB size check before encoding |
| Repository | All Firestore operations wrapped in `try/catch`; errors returned as `CloudResult` with `statusCode: 500` |

### Error Handling Strategy

All repository methods return a `CloudResult<T>` wrapper:

```dart
class CloudResult<T> {
  final int statusCode;  // HTTP-like: 200 = success, 500 = error
  final T? data;
  final String message;
  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
```

Cubits check `result.isSuccess` and emit either a success state or `error(message)` state. The UI responds by showing snackbars or error banners.

### Error Scenarios

| Scenario | Expected Behavior |
|----------|------------------|
| Invalid admin credentials | `AuthCubit` emits `AuthStatus.error` with Firebase's error message; error text shown below the login form |
| Admin session expires | `AuthCubit` stream emits `unauthenticated`; GoRouter redirects to `/admin/login`; unsaved changes are discarded |
| Dish photo fails to load (network image) | `CachedNetworkImage` shows `Icons.broken_image_outlined` placeholder; dish card layout is preserved |
| Unsupported image format selected | Field-level error shown: "Only JPG, PNG, and WebP formats are accepted." |
| Image exceeds 600 KB | Field-level error shown: "Image must be smaller than 600 KB." |
| Firestore write fails | `AdminDishCubit` emits `error` state; red snackbar shown with error message |
| Firestore stream fails | `MenuCubit` emits `errorMessage`; menu page shows error banner with Retry button |
| Empty category selected | "No items available in this category" message shown instead of blank grid |

---

## 11. Testing Overview

| Test Type | Coverage | Tools | Location |
|-----------|----------|-------|----------|
| Unit Tests | `AdminDishCubit` — `editDish` and `deleteDish` state transitions (success, error, with/without photo change) | `flutter_test`, `bloc_test`, `mocktail` | `test/features/admin/presentation/controllers/admin_dish_cubit_test.dart` |
| Widget Test | Smoke test for home page rendering (`Café Digital Menu` text, no unexpected content) | `flutter_test`, `mocktail` | `test/widget_test.dart` |
| Static Analysis | Full codebase; **result: No issues found!** | `flutter analyze` | Run from `digital_menu/` |

### Test Execution Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/admin/presentation/controllers/admin_dish_cubit_test.dart

# Run static analysis
flutter analyze

# Run with verbose output
flutter test --reporter expanded
```

### Test Patterns Used

- **MockCubit** via `bloc_test`'s `MockCubit` for widget test `AuthCubit` isolation
- **Mocktail `Mock` classes** for use case mocking; fallback values registered in `setUpAll` for `Dish` and `Uint8List`
- **`blocTest`** for BLoC/Cubit state sequence verification with `act`, `expect`, and `verify` blocks

---

## 12. Deployment & Operations

### Deployment Process

```bash
# Step 1: Build release web bundle
cd digital_menu
flutter build web --release

# Step 2: Output is in build/web/
# Serve this directory using any static host (Firebase Hosting, Netlify, S3, Nginx)

# Example: Deploy to Firebase Hosting
firebase deploy --only hosting
```

### Firebase Hosting Setup

**Live Production URLs:**  
* https://digital-menu-prod-2026.firebaseapp.com  
* https://digital-menu-prod-2026.web.app

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize hosting (run from vibe-coding-poc/)
firebase init hosting

# Deploy
firebase deploy --only hosting
```

After deployment, the app is accessible at:
- **Default Domain:**  
  * Customer menu: https://digital-menu-prod-2026.firebaseapp.com/#/menu  
  * Admin portal: https://digital-menu-prod-2026.firebaseapp.com/#/admin  
- **Alternative Domain:**  
  * Customer menu: https://digital-menu-prod-2026.web.app/#/menu  
  * Admin portal: https://digital-menu-prod-2026.web.app/#/admin  

### CI/CD Flow

No automated CI/CD pipeline is configured in v1.0. Recommended pipeline steps:

| Stage | Command |
|-------|---------|
| 1. Lint | `flutter analyze` |
| 2. Test | `flutter test` |
| 3. Build | `flutter build web --release` |
| 4. Deploy | `firebase deploy --only hosting` |

### Monitoring & Logging

| Area | Approach |
|------|---------|
| Firestore errors | Caught by `try/catch` in repository implementations; logged as `CloudResult` error messages surfaced to the UI |
| Auth errors | Firebase Auth exceptions mapped to human-readable messages in `AuthRepositoryImpl` |
| Database seeder failures | Silently swallowed (`catch (e) {}`) to prevent app crash if the seeder lacks permissions |
| Client-side image encoding | Errors surfaced via `_imageError` state in `AddDishDialog` |

### Rollback Strategy

Since data is stored in Firestore and the app is stateless:

1. **Code rollback:** Re-deploy previous `build/web/` artifact to hosting.
2. **Data rollback:** Firestore does not have native point-in-time recovery in the Spark (free) plan. Before bulk operations, export data via Firebase Console → Firestore → Export.
3. **Auth rollback:** Admin accounts are managed in Firebase Console and can be disabled or removed instantly.

---

## 13. Known Limitations & Future Enhancements

| Type | Description | Priority |
|------|-------------|---------|
| Limitation | Images stored as Base64 in Firestore; max 600 KB per image. Large menus will approach Firestore document limits | High |
| Limitation | No offline support; menu requires active internet connection | Medium |
| Limitation | Single admin account; no multi-user or role-based access control | Medium |
| Limitation | No image CDN or resizing; seed images rely on Unsplash uptime | Low |
| Limitation | No WCAG / accessibility audit for screen-reader users | Medium |
| Enhancement | Migrate image storage to Firebase Storage (requires Blaze plan) or Cloudinary for unlimited image sizes | High |
| Enhancement | Add role-based access control (RBAC) for multiple admin accounts | Medium |
| Enhancement | Implement online ordering, cart, and checkout flow | High |
| Enhancement | Add allergen and dietary information fields to dish model | Medium |
| Enhancement | Add push notifications for menu updates | Low |
| Enhancement | Implement PWA offline caching for customer menu | Medium |
| Enhancement | Add CI/CD pipeline (GitHub Actions or Codemagic) | Medium |
| Enhancement | Add dish search/filter functionality to customer menu | Low |
| Enhancement | Add category management (create, rename, delete categories) from Admin Panel | Medium |

---

## 14. Troubleshooting Guide

| Issue | Resolution |
|-------|------------|
| `No issues found!` expected but `flutter analyze` reports errors | Run `dart run build_runner build --delete-conflicting-outputs` to regenerate Freezed files, then re-analyze |
| `LateInitializationError: Field '_instance' has not been initialized` on file picker | This occurs if `FilePicker.platform` is accessed before Flutter is initialized. Ensure `WidgetsFlutterBinding.ensureInitialized()` is called in `main()` before `FilePicker` usage |
| Image upload shows loading spinner indefinitely | Firebase Storage is not enabled on the Spark plan. The codebase uses client-side Base64 encoding instead. Ensure `MenuRemoteDataSourceImpl.uploadImage()` is using `base64Encode` and not any Storage SDK calls |
| Login button shows infinite spinner | `AuthCubit` may be registered as `factory` instead of `lazySingleton` in `di.dart`. Verify `sl.registerLazySingleton(() => AuthCubit(...))` — all layers must share the same `AuthCubit` instance |
| Navigating to `/#/admin` redirects to login even when authenticated | Check that `GoRouterRefreshStream` is receiving the `AuthCubit` stream from `sl<AuthCubit>()` (the singleton), not a new factory instance |
| Dishes not appearing after add/edit | Confirm the `MenuCubit` in `AdminPage` is subscribed via `..loadMenu()`. Also confirm Firestore Security Rules allow authenticated writes |
| Category filter shows all dishes regardless of selection | Verify the Firestore query in `MenuRemoteDataSourceImpl.streamDishesByCategory()` uses `.where('categoryId', isEqualTo: categoryId)` |
| QR code shows wrong IP address | Update the hardcoded `host` fallback in `HomePage` (line 14) to the current machine's local IP address for mobile testing |
| `flutter pub get` fails with SDK constraint errors | Ensure Flutter SDK version ≥ 3.x. Run `flutter upgrade` if needed |
| Firestore Permission Denied on first launch | Database seeder may fail silently. Check Firestore Security Rules allow unauthenticated reads on `categories` and `dishes` |
| `The supplied auth credential is incorrect` | The admin account has not been created in Firebase Console. Follow the Admin Account Setup steps in Section 8 |
| Tests fail with `Couldn't find constructor 'AuthState.unauthenticated'` | `AuthState` uses a named `status` field, not a named constructor. Use `AuthState(status: AuthStatus.unauthenticated)` |
| `Bad state: A test tried to use any on Uint8List` | Register a fallback value: `registerFallbackValue(Uint8List(0))` in `setUpAll` of the test file |

---

## 15. Developer Quick Start

Follow these steps to go from zero to a running, contributing developer in under 10 minutes.

### Step 1: Install Dependencies

```bash
# Verify Flutter installation
flutter doctor

# Navigate to the project
cd vibe-coding-poc/digital_menu

# Install all Dart/Flutter packages
flutter pub get

# Regenerate code (Freezed models + JSON serializers)
dart run build_runner build --delete-conflicting-outputs
```

### Step 2: Configure Environment

1. The Firebase configuration is already committed at `lib/core/config/firebase_options.dart` for project `digital-menu-prod-2026`.
2. If you need to connect to a different Firebase project:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure --project=<your-project-id>
   ```
3. Ensure an admin user exists in Firebase Console → Authentication → Users (see Section 8 for default credentials).

### Step 3: Run Application

```bash
# Launch in Chrome on port 50578
flutter run -d chrome --web-port=50578
```

The app opens at:
- `http://localhost:50578/#/` — QR code table stand (home page)
- `http://localhost:50578/#/menu` — Customer menu
- `http://localhost:50578/#/admin/login` — Admin login
- `http://localhost:50578/#/admin` — Admin dashboard (redirects to login if unauthenticated)

### Step 4: Execute Tests

```bash
# Run all tests (6 tests across 2 files)
flutter test

# Run static analysis (expect: No issues found!)
flutter analyze
```

### Step 5: Build Project

```bash
# Create production web bundle
flutter build web --release
# Output: digital_menu/build/web/
```

### Step 6: Deploy Application

```bash
# Install Firebase CLI (one-time)
npm install -g firebase-tools
firebase login

# Deploy to Firebase Hosting (from project root)
firebase deploy --only hosting
```

---

### Key URLs at a Glance

#### Production (Firebase Hosting)

| URL | Description |
|-----|-------------|
| https://digital-menu-prod-2026.firebaseapp.com | Live app — home page with QR code (Default Domain) |
| https://digital-menu-prod-2026.web.app | Live app — home page with QR code (Alternative Domain) |
| https://digital-menu-prod-2026.firebaseapp.com/#/menu | Live customer-facing menu (Default Domain) |
| https://digital-menu-prod-2026.web.app/#/menu | Live customer-facing menu (Alternative Domain) |
| https://digital-menu-prod-2026.firebaseapp.com/#/admin/login | Live admin login (Default Domain) |
| https://digital-menu-prod-2026.web.app/#/admin/login | Live admin login (Alternative Domain) |
| https://digital-menu-prod-2026.firebaseapp.com/#/admin | Live admin dashboard (Default Domain) |
| https://digital-menu-prod-2026.web.app/#/admin | Live admin dashboard (Alternative Domain) |

#### Local Development

| URL | Description |
|-----|-------------|
| `http://localhost:50578/#/` | Home page with QR code |
| `http://localhost:50578/#/menu` | Customer-facing menu |
| `http://localhost:50578/#/admin/login` | Admin login |
| `http://localhost:50578/#/admin` | Admin dashboard |
| `https://console.firebase.google.com` | Firebase project management |

### Contacts & Resources

| Resource | Link |
|----------|------|
| Firebase Console | https://console.firebase.google.com |
| FlutterFire Docs | https://firebase.flutter.dev |
| go_router Docs | https://pub.dev/packages/go_router |
| flutter_bloc Docs | https://bloclibrary.dev |
| Freezed Docs | https://pub.dev/packages/freezed |
| PRD | `/agent/prd_digital_menu.md` |
| Scope Document | `/agent/scope_digital_menu.md` |
| KPI Document | `/agent/kpi_digital_menu.md` |
