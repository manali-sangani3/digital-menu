# PROJECT SCOPE & ARCHITECTURE

**Project Name:** DigitalMenu
**Version:** 1.0
**Date:** 2026-06-10
**Author:** Senior Product Manager

---

## 1. Goal & Problem Statement

* **The Problem:** A café relies on paper menus, making it slow and costly to update dish information and inaccessible to customers who prefer a digital experience.
* **The Solution:** A QR-code-accessible, browser-based digital menu that allows customers to instantly view categorised dish cards (name, price, photo) and enables the café owner to manage the menu through a simple admin panel.

---

## 2. Tech Stack

* **Frontend:** Flutter
* **Database & Caching:** Firebase Firestore

---

## 3. Core Features & Acceptance Criteria

| Feature Number | Feature Name | Description | Acceptance Criteria |
| --- | --- | --- | --- |
| F-01 | QR Code Entry | A unique QR code that opens the digital menu in any mobile browser — no app download required | QR code scan must resolve to the live menu URL; menu must open in a mobile browser without requiring an app download |
| F-02 | Categorised Menu Display | Dishes grouped by category (e.g., Breakfast, Drinks) with dish name, price, and photo visible on each card | Each dish card must display name, price, and photo; dishes must appear under their correct assigned category |
| F-03 | Minimum Dish Visibility | At least 5 dishes with photos must be visible on the menu page at launch | Minimum 5 dishes with photos are visible and all photo assets load correctly on page open |
| F-04 | Mobile-Responsive Layout | Menu is fully readable and navigable on standard mobile viewports | Menu renders correctly on 375 px–428 px viewports with no horizontal scrolling |
| F-05 | Photo Fallback | Failed dish photo loads display a placeholder image | 100% of failed photo loads must show a placeholder; dish card layout must not break |
| F-06 | Empty Category Message | A message is shown when a category contains no dishes | "No items available in this category" message appears for any category with zero dishes |
| F-07 | Admin Login | Café owner authenticates to access the admin panel | 100% of valid credential submissions must grant admin access; invalid credentials must be rejected |
| F-08 | Add Dish | Admin can add a new dish with name, price, photo, and category | A new dish submitted with all required fields must appear on the live customer-facing menu immediately after save |
| F-09 | Edit Dish | Admin can update an existing dish's name, price, photo, or category | Updated dish details must reflect on the live menu immediately after save |
| F-10 | Form Validation | Admin form rejects submissions with missing required fields | 100% of submissions missing name, price, photo, or category must return field-level error messages and not be saved |
| F-11 | Unsupported Image Rejection | Admin photo upload rejects unsupported file types | Non-JPG/PNG/WebP uploads must be rejected with an error specifying accepted formats |
| F-12 | Session Expiry Handling | Expired admin sessions redirect to the login page | 100% of expired sessions must redirect to login; unsaved changes are discarded |

---

## 4. UI/UX Standards

* **Theme & Style:** Material 3.
* **Layout:** Mobile-first, responsive grid, micro-animations.

---

## 5. Out of Scope

* Online ordering
* Payment processing
* Cart and checkout flow
* Customer accounts
* Reviews
* Table reservations
* Push notifications
* Loyalty programmes
* Offline support
* Role-based access control (RBAC)
* Image CDN or hosting management
* Allergen information display
* WCAG / accessibility audit
* Image copyright verification
