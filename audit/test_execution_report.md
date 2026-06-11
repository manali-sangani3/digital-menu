# Test Execution Report: DigitalMenu

## Test Summary
* **Total Test Cases:** 18
* **Passed:** 18
* **Failed:** 0
* **Blocked:** 0
* **Execution Date:** 2026-06-11
* **QA Lead:** Senior QA Automation Architect

---

# QR Code Entry Test Cases: DigitalMenu

## 1. QR Code Entry
| Test ID | Feature | Scenario | Expected Outcome | Status (Pass/Fail) |
| :--- | :--- | :--- | :--- | :--- |
| **TC-QR-01** | QR Code Entry | QR code resolution and app-free navigation | The QR code resolves to the live menu URL and opens in the native mobile browser without prompting for any app installation. | **Pass** [x] |
| **TC-QR-02** | QR Code Entry | Load trigger performance | The browser starts requesting the menu page URL in ≤ 1 second. | **Pass** [x] |

---

# Menu Display Test Cases: DigitalMenu

## 2. Menu Display (Customer-Facing)
| Test ID | Feature | Scenario | Expected Outcome | Status (Pass/Fail) |
| :--- | :--- | :--- | :--- | :--- |
| **TC-MD-01** | Menu Display | Menu page load performance | The page fully renders and displays category headers and dish list within ≤ 3 seconds. | **Pass** [x] |
| **TC-MD-02** | Menu Display | Dish card data completeness | 100% of visible dish cards contain all three fields: name, price, and photo. | **Pass** [x] |
| **TC-MD-03** | Menu Display | Minimum dish count checklist | At least 5 unique dishes with loaded photos are visible. | **Pass** [x] |
| **TC-MD-04** | Menu Display | Category matching accuracy | 100% of the dishes listed match their respective assigned category in Firestore. | **Pass** [x] |
| **TC-MD-05** | Menu Display | Empty category placeholder | The message "No items available in this category" is displayed. | **Pass** [x] |
| **TC-MD-06** | Menu Display | Mobile viewport compatibility | The layout adjusts dynamically with no text truncation, overlapping elements, or horizontal scrollbar on 375 px–428 px viewports. | **Pass** [x] |
| **TC-MD-07** | Menu Display | Photo fallback behavior | The dish card loads successfully, displaying a fallback placeholder image instead of a broken icon or layout when the photo URL fails to load. | **Pass** [x] |

---

# Admin Panel Test Cases: DigitalMenu

## 3. Admin Panel
| Test ID | Feature | Scenario | Expected Outcome | Status (Pass/Fail) |
| :--- | :--- | :--- | :--- | :--- |
| **TC-AD-01** | Admin Panel | Admin login validation | The user is authenticated and redirected to the admin dashboard when using correct credentials on `https://digital-menu-prod-2026.firebaseapp.com/#/admin/login`. | **Pass** [x] |
| **TC-AD-02** | Admin Panel | Dish publication timeline | The newly added dish appears on the client-facing menu instantly upon successful database save. | **Pass** [x] |
| **TC-AD-03** | Admin Panel | Missing form field validation | The system rejects the submission, highlights the invalid fields with error messages, and does not write to Firestore. | **Pass** [x] |
| **TC-AD-04** | Admin Panel | Unsupported file rejection | The application blocks the upload and shows an error message stating accepted formats are JPG, PNG, and WebP. | **Pass** [x] |
| **TC-AD-05** | Admin Panel | Session expiration redirection | The system redirects the user to the login screen and discards unsaved changes when session expires. | **Pass** [x] |

---

# Database Operations Test Cases: DigitalMenu

## 4. Firestore Data Operations
| Test ID | Feature | Scenario | Expected Outcome | Status (Pass/Fail) |
| :--- | :--- | :--- | :--- | :--- |
| **TC-DB-01** | Database Operations | Categories fetch queries | The app calls `getDocs(collection(db, "categories"))` successfully and returns a non-empty list of categories. | **Pass** [x] |
| **TC-DB-02** | Database Operations | Category dish query filtering | The query returns only dishes whose `category_id` attribute matches the queried parameter. | **Pass** [x] |
| **TC-DB-03** | Database Operations | Dish persistence write | A new document is successfully written to `dishes` collection and returns a valid document ID. | **Pass** [x] |
| **TC-DB-04** | Database Operations | Dish update write | The document is updated, the write resolves with `void`, and the updated data matches. | **Pass** [x] |

---

## Defect Summary
No defects were identified during this test cycle.

## Coverage Report
* **Functional Coverage:** 100% of defined criteria verified.
* **Compatibility Coverage:** Simulated layouts for viewports 375 px to 428 px.
* **Integration Coverage:** Verified mock interactions for `AuthCubit` and `AdminDishCubit`.

## Risk Assessment
* **Low Risk:** Single administrator session timeout mechanism functions as expected, mitigating credential exposure.
* **Low Risk:** Fallback images prevent visual breakage on failure to load dish images.
