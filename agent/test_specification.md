# Test Specification: DigitalMenu

This document defines the test specifications and test cases for the DigitalMenu project, derived from the [Product Requirements Document (PRD)](file:///Users/neosoft/StudioProjects/vibe-coding-poc/agent/prd_digital_menu.md) and the [KPI Document](file:///Users/neosoft/StudioProjects/vibe-coding-poc/agent/kpi_digital_menu.md).

---

## 1. Module 1: QR Code Entry

| Test Case ID | Test Scenario | Steps | Expected Result | KPI Reference |
| :--- | :--- | :--- | :--- | :--- |
| **TC-QR-01** | QR code resolution and app-free navigation. | 1. Scan the printed QR code using a standard mobile camera.<br>2. Observe the browser behavior. | The QR code resolves to the live menu URL and opens in the native mobile browser without prompting for any app installation. | KPI-01, KPI-03 |
| **TC-QR-02** | Load trigger performance. | 1. Initiate QR code scan on a mobile device.<br>2. Measure the latency between scanning and the browser launching the page request. | The browser starts requesting the menu page URL in ≤ 1 second. | KPI-02 |

---

## 2. Module 2: Menu Display (Customer-Facing)

| Test Case ID | Test Scenario | Steps | Expected Result | KPI Reference |
| :--- | :--- | :--- | :--- | :--- |
| **TC-MD-01** | Menu page load performance. | 1. Connect a mobile device to a standard 4G network.<br>2. Navigate to the menu URL.<br>3. Measure time to full page render. | The page fully renders and displays category headers and dish list within ≤ 3 seconds. | KPI-04 |
| **TC-MD-02** | Dish card data completeness. | 1. Open the menu page.<br>2. Scan all visible dish cards in the active categories. | 100% of visible dish cards contain all three fields: name, price, and photo. | KPI-05 |
| **TC-MD-03** | Minimum dish count checklist. | 1. Navigate to the live menu page.<br>2. Count the total number of dishes displayed with loaded photos. | At least 5 unique dishes with loaded photos are visible. | KPI-06 |
| **TC-MD-04** | Category matching accuracy. | 1. Open a specific category (e.g., "Breakfast").<br>2. Verify each dish displayed belongs to the category. | 100% of the dishes listed match their respective assigned category in Firestore. | KPI-07 |
| **TC-MD-05** | Empty category placeholder. | 1. Tap on a category that contains no dishes.<br>2. Observe the page content. | The message "No items available in this category" is displayed. | KPI-08 |
| **TC-MD-06** | Mobile viewport compatibility. | 1. Open the menu in a browser.<br>2. Use browser developer tools to simulate screen widths between 375 px and 428 px.<br>3. Inspect the layout. | The layout adjusts dynamically with no text truncation, overlapping elements, or horizontal scrollbar. | KPI-09 |
| **TC-MD-07** | Photo fallback behavior. | 1. Simulate a failed image resource load (e.g., by blocklisting the image host or breaking the image url).<br>2. View the menu card. | The dish card loads successfully, displaying a fallback placeholder image instead of a broken icon or layout. | KPI-10 |

---

## 3. Module 3: Admin Panel

| Test Case ID | Test Scenario | Steps | Expected Result | KPI Reference |
| :--- | :--- | :--- | :--- | :--- |
| **TC-AD-01** | Admin login validation. | 1. Navigate to `/#/admin/login`.<br>2. Enter credentials `admin@menu.com` and `admin1234`. <br>3. Click Submit. | The user is authenticated and redirected to the admin dashboard. | KPI-11 |
| **TC-AD-02** | Dish publication timeline. | 1. In the admin dashboard, create a new dish (fill name, price, select category, upload photo).<br>2. Click Save.<br>3. Check the client-side menu page immediately. | The newly added dish appears on the client-facing menu instantly upon successful database save. | KPI-13 |
| **TC-AD-03** | Missing form field validation. | 1. Open the Add Dish form.<br>2. Leave required fields blank (e.g., name or price).<br>3. Click Save. | The system rejects the submission, highlights the invalid fields with error messages, and does not write to Firestore. | KPI-14 |
| **TC-AD-04** | Unsupported file rejection. | 1. Open the Add Dish form.<br>2. Attempt to upload a non-image file type (e.g., `.pdf`, `.txt`). | The application blocks the upload and shows an error message stating accepted formats are JPG, PNG, and WebP. | KPI-15 |
| **TC-AD-05** | Session expiration redirection. | 1. Leave the admin panel inactive until session token expires (or manually invalidate/expire session state).<br>2. Attempt to make a change. | The system redirects the user to the login screen and discards unsaved changes. | KPI-16 |

---

## 4. Module 4: Firestore Data Operations

| Test Case ID | Test Scenario | Steps | Expected Result | KPI Reference |
| :--- | :--- | :--- | :--- | :--- |
| **TC-DB-01** | Categories fetch queries. | 1. Trigger the fetch categories logic from the repository.<br>2. Inspect the returned list. | The app calls `getDocs(collection(db, "categories"))` successfully and returns a non-empty list of categories. | KPI-17 |
| **TC-DB-02** | Category dish query filtering. | 1. Query dishes under a specific category ID.<br>2. Verify properties of each returned dish. | The query returns only dishes whose `category_id` attribute matches the queried parameter. | KPI-18 |
| **TC-DB-03** | Dish persistence write. | 1. Execute the add dish operation from the UI/repository.<br>2. Verify Firestore document persistence. | A new document is successfully written to `dishes` collection and returns a valid document ID. | KPI-19 |
| **TC-DB-04** | Dish update write. | 1. Modify an existing dish property and click update.<br>2. Verify Firestore database changes. | The document is updated, the write resolves with `void`, and the updated data matches. | KPI-20 |
