# PRODUCT REQUIREMENTS DOCUMENT (PRD)

**Project Name:** DigitalMenu
**Version:** 1.0
**Date:** 2026-06-10
**Author:** Senior Product Manager

---

## 1. Problem Statement

* **The Issue:** A café currently relies on paper menus, making it slow and costly to update dish information and inaccessible to customers who prefer a digital experience.
* **Target User:** Café customers who scan a QR code at the table, and the café owner/admin who manages dish listings.
* **Impact:** Without a digital menu, the café cannot quickly reflect price changes or new dishes; customers experience delays and friction, and the owner bears recurring printing costs.

---

## 2. Solution Overview

* **Value Prop:** A QR-code-accessible, browser-based digital menu that allows customers to instantly view categorised dish cards (name, price, photo) and enables the café owner to manage the menu through a simple admin panel.
* **Core Features:**
    * **QR Code Entry:** A unique QR code that opens the digital menu in any mobile browser — no app download required.
    * **Categorised Menu Display:** Dishes grouped by category (e.g., Breakfast, Drinks) with dish name, price, and photo visible on each card.
    * **Admin Panel:** A simple interface for the owner to add and edit dish entries (name, price, photo, category).
* **Out of Scope:** Online ordering, payment processing, cart/checkout flow, customer accounts, reviews, table reservations, push notifications, and loyalty programmes.

---

## 3. User Flow

### Customer Flow

1. **Trigger:** Customer is seated at the café table and sees the printed QR code.
2. **Action:** Customer opens their phone camera and scans the QR code; the browser navigates to the digital menu URL.
3. **Process:** Menu page loads → Customer views dish categories → Customer taps/scrolls to a category → System displays dish cards (name, price, photo) within that category.
4. **Outcome:** Customer browses all available dishes with photos and prices directly on their mobile browser.

### Admin Flow

1. **Trigger:** Café owner needs to add or update a dish.
2. **Action:** Owner navigates to the admin panel URL and logs in with credentials.
3. **Process:** Owner selects "Add Dish" or selects an existing dish → Fills in dish name, price, uploads a photo, and selects a category → Saves the entry.
4. **Outcome:** The new or updated dish card is immediately visible on the live customer-facing menu.

---

## 4. API Design

### Firebase Firestore Methods

* **Fetch All Categories**
    * **Collection:** `categories`
    * **Method:** `getDocs(collection(db, "categories"))`
    * **Returns:** `[ { id: "docId", name: "Breakfast" } ]`

* **Fetch Dishes by Category**
    * **Collection:** `dishes`
    * **Method:** `getDocs(query(collection(db, "dishes"), where("category_id", "==", categoryId)))`
    * **Returns:** `[ { id: "docId", name: "Avocado Toast", price: 180, photo_url: "https://...", category_id: "docId" } ]`

* **Add a New Dish** _(Admin)_
    * **Collection:** `dishes`
    * **Method:** `addDoc(collection(db, "dishes"), { name, price, photo_url, category_id })`
    * **Returns:** `DocumentReference` with auto-generated `id`

* **Update an Existing Dish** _(Admin)_
    * **Collection:** `dishes`
    * **Method:** `updateDoc(doc(db, "dishes", dishId), { name, price, photo_url, category_id })`
    * **Returns:** `void` (resolves on success)

---

## 5. Edge Cases & Error Handling

* **Dish photo fails to load:** → Display a placeholder image so the dish card layout is not broken.
* **QR code scanned with no internet connection:** → Browser shows a standard network error; no custom fallback within scope.
* **Admin submits a dish with missing required fields (name/price/photo/category):** → System returns a `400 Bad Request` with field-level validation error messages; the dish is not saved.
* **Dish list is empty for a category:** → Display an "No items available in this category" message instead of a blank section.
* **Unsupported image file type uploaded by admin:** → System rejects upload and returns an error message specifying accepted formats (JPG, PNG, WebP).
* **Admin session expires mid-edit:** → System redirects to the login page; unsaved changes are lost.

---

## 6. KPIs & Acceptance Criteria

### Key Performance Indicators (KPIs)

* **Menu Load Time:** Menu page fully renders on mobile within ≤ 3 seconds on a standard 4G connection.
* **QR Code Success Rate:** 100% of scanned QR codes resolve to the correct live menu URL.
* **Dish Visibility:** Minimum 5 dishes with photos are visible on the menu page post-launch.
* **Admin Task Completion Time:** An admin can add a new dish (name, price, photo, category) in ≤ 2 minutes.
* **Mobile Rendering:** Menu is fully readable and navigable on viewports 375 px–428 px wide (standard mobile screen range).

### Acceptance Criteria

* [ ] GIVEN a customer scans the printed QR code, WHEN the camera app resolves the code, THEN the digital menu opens in the mobile browser without requiring an app download.
* [ ] GIVEN the menu page loads, WHEN the customer views any category, THEN each dish card displays the dish name, price, and photo.
* [ ] GIVEN the menu contains at least 5 dishes with photos, WHEN the menu page is opened on a mobile device, THEN all 5 dishes are visible and their photos load correctly.
* [ ] GIVEN an admin is logged into the admin panel, WHEN the admin submits a new dish with valid name, price, photo, and category, THEN the dish appears immediately on the live customer-facing menu.
* [ ] GIVEN an admin submits a dish without a required field, WHEN the form is submitted, THEN the system displays a validation error and does not save the record.
* [ ] GIVEN the menu page is opened on a mobile device (375 px–428 px width), WHEN the page renders, THEN all dish cards and category navigation are fully readable without horizontal scrolling.

---

## 7. Limitations & Risks

* **Technical:**
    * No offline support; the menu requires an active internet connection to load.
    * Image hosting/CDN is not in scope; large unoptimised photo uploads may impact page load speed.
    * Admin panel has no role-based access control in v1.0 — a single owner credential is assumed.
* **Business/Legal:**
    * Dish photos must be owned or licensed by the café owner; no image copyright verification is in scope.
    * No accessibility audit (WCAG) is planned for v1.0; screen-reader support is not guaranteed.
    * Menu is display-only; any regulatory requirement to show allergen information is not addressed in this version.
