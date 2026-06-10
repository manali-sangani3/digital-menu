# KPI Document

**Project Name:** DigitalMenu
**Version:** 1.0
**Date:** 2026-06-10
**Author:** Senior Product Manager

---

# KPI Matrix

## Module 1: QR Code Entry

| KPI Number | KPI Name | Description | Criteria |
| --- | --- | --- | --- |
| KPI-01 | QR Code Resolution Rate | Percentage of QR code scans that successfully resolve to the live menu URL | 100% of scans must open the correct menu URL in a mobile browser |
| KPI-02 | QR Code Load Trigger Time | Time from QR scan to the browser initiating the menu page request | Browser must initiate the page request within ≤ 1 second of scan |
| KPI-03 | App-Free Access Rate | Percentage of QR code sessions opened without requiring an app download | 100% of sessions must open in the native mobile browser without an app |

---

## Module 2: Menu Display (Customer-Facing)

| KPI Number | KPI Name | Description | Criteria |
| --- | --- | --- | --- |
| KPI-04 | Menu Page Load Time | Time for the menu page to fully render on a mobile device over 4G | Page must fully render within ≤ 3 seconds on a standard 4G connection |
| KPI-05 | Dish Card Completeness Rate | Percentage of dish cards that display all three required fields: name, price, photo | 100% of dish cards must show name, price, and photo |
| KPI-06 | Minimum Dish Visibility | Number of dishes with photos visible on the menu page at launch | Minimum 5 dishes with photos must be visible post-launch |
| KPI-07 | Category Display Accuracy | Percentage of dishes displayed under their correct assigned category | 100% of dishes must appear under their assigned category |
| KPI-08 | Empty Category Handling | System displays a message when a category has no dishes | "No items available in this category" message must appear for empty categories |
| KPI-09 | Mobile Viewport Compatibility | Menu is fully readable and navigable on standard mobile screen widths | Menu must render correctly on 375 px–428 px viewports with no horizontal scrolling |
| KPI-10 | Photo Fallback Rate | Percentage of failed dish photo loads that display a placeholder image | 100% of failed photo loads must show a placeholder; no broken layout |

---

## Module 3: Admin Panel

| KPI Number | KPI Name | Description | Criteria |
| --- | --- | --- | --- |
| KPI-11 | Admin Login Success Rate | Percentage of valid credential submissions that grant admin access | 100% of correct credential submissions must authenticate successfully |
| KPI-12 | Dish Add Task Completion Time | Time for an admin to complete adding a new dish (name, price, photo, category) | Admin must be able to add a dish within ≤ 2 minutes |
| KPI-13 | Dish Publish Immediacy | Time between admin saving a dish and the dish appearing on the live menu | Dish must be visible on the customer-facing menu immediately after save |
| KPI-14 | Form Validation Error Rate | Percentage of incomplete dish submissions that are correctly rejected with field-level error messages | 100% of submissions missing name, price, photo, or category must return a validation error and not be saved |
| KPI-15 | Unsupported Image Rejection Rate | Percentage of unsupported file type uploads that are rejected with an appropriate error message | 100% of non-JPG/PNG/WebP uploads must be rejected with an error specifying accepted formats |
| KPI-16 | Session Expiry Redirect Rate | Percentage of expired admin sessions that correctly redirect to the login page | 100% of expired sessions must redirect to login; unsaved changes are discarded |

---

## Module 4: Firestore Data Operations

| KPI Number | KPI Name | Description | Criteria |
| --- | --- | --- | --- |
| KPI-17 | Category Fetch Success Rate | Percentage of `getDocs(collection(db, "categories"))` calls that return a valid, non-empty result | 100% of fetch calls must return the correct categories list |
| KPI-18 | Dish Fetch Accuracy by Category | Percentage of `getDocs(query(..., where("category_id", "==", categoryId)))` calls that return only dishes matching the requested category | 100% of query results must contain only dishes belonging to the queried category |
| KPI-19 | Dish Add Write Success Rate | Percentage of `addDoc(collection(db, "dishes"), {...})` calls that complete without error and return a valid `DocumentReference` | 100% of valid add operations must persist to Firestore and return a document ID |
| KPI-20 | Dish Update Write Success Rate | Percentage of `updateDoc(doc(db, "dishes", dishId), {...})` calls that resolve successfully | 100% of valid update operations must persist to Firestore and resolve with `void` |

---

# Development Timeline

| Sprint | Focus Area | Deliverables |
| --- | --- | --- |
| Sprint 1 | Foundation & Data Layer | Firestore collections setup (`categories`, `dishes`); seed data for minimum 5 dishes with photos; QR code generation pointing to menu URL |
| Sprint 2 | Customer-Facing Menu | Menu page with category navigation; dish card display (name, price, photo); mobile-responsive layout (375 px–428 px); photo fallback for failed loads; empty category message |
| Sprint 3 | Admin Panel | Admin login with credential validation; Add Dish form (name, price, photo upload, category selector); form validation with field-level error messages; unsupported image type rejection |
| Sprint 4 | Integration & QA | End-to-end QR code scan to menu display flow; Firestore read/write integration tests; mobile viewport testing; session expiry handling; KPI measurement baseline |

---

# Success Criteria

| Category | Success Metric | Target |
| --- | --- | --- |
| QR Code Entry | QR code scan resolves to live menu URL without app download | 100% scan success rate |
| Menu Display | Menu page fully renders on mobile over 4G | ≤ 3 seconds load time |
| Dish Visibility | Dishes with complete cards (name, price, photo) visible at launch | Minimum 5 dishes |
| Mobile Compatibility | Menu readable and navigable on mobile viewports | 375 px–428 px, no horizontal scroll |
| Admin Efficiency | Admin adds a new dish end-to-end | ≤ 2 minutes per task |
| Data Integrity | Dish published by admin appears on live menu | Immediately after save |
| Form Validation | Incomplete dish submissions rejected with error messages | 100% rejection with field-level errors |
| Security | Expired admin sessions redirect to login | 100% redirect rate |
| Firestore Reliability | All Firestore read/write operations complete without error | 100% success rate for valid operations |
