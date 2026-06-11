# Test Execution Report

| Test ID | Test Name | Expected Result | Actual Result | Status |
| :--- | :--- | :--- | :--- | :--- |
| TC-QR-01 | QR code resolution and app-free navigation | Resolves to live menu URL and opens in native mobile browser without app install. | Resolved to live URL and opened in native browser without app prompt. | PASS |
| TC-QR-02 | Load trigger performance | Browser starts requesting menu page URL in ≤ 1 second of scan. | Page request initiated in less than 1 second from scan. | PASS |
| TC-MD-01 | Menu page load performance | Renders headers and dish list within ≤ 3 seconds on standard 4G. | Fully rendered all categories and dish cards within 3 seconds. | PASS |
| TC-MD-02 | Dish card data completeness | 100% of visible dish cards contain name, price, and photo. | Verified all visible cards contain name, price, and image. | PASS |
| TC-MD-03 | Minimum dish count checklist | Minimum 5 unique dishes with photos are visible on launch. | Displayed 5 default seeded dishes with photos successfully. | PASS |
| TC-MD-04 | Category matching accuracy | 100% of dishes appear under their correct assigned category. | Query filters and places dishes under correct category ID. | PASS |
| TC-MD-05 | Empty category placeholder | Displays message "No items available in this category" for empty categories. | Placeholder message displayed successfully on empty category tap. | PASS |
| TC-MD-06 | Mobile viewport compatibility | Layout fits 375 px–428 px screen widths with no horizontal scroll. | Rendered correctly on target mobile screens with zero horizontal scrolling. | PASS |
| TC-MD-07 | Photo fallback behavior | Failed dish photo loads render fallback placeholder image. | Fallback placeholder image loaded successfully on broken image URL. | PASS |
| TC-AD-01 | Admin login validation | Correct credentials authenticate user and redirect to dashboard. | Authenticated successfully and routed to admin page. | PASS |
| TC-AD-02 | Dish publication timeline | New dish appears on client-facing menu instantly upon saving. | Added dish is rendered immediately on customer view post-save. | PASS |
| TC-AD-03 | Missing form field validation | Missing required fields display validation error and block database save. | Incomplete submission rejected with field-level errors; no document created. | PASS |
| TC-AD-04 | Unsupported file rejection | Non-JPG/PNG/WebP uploads are blocked with format-specific error. | Upload blocked and error shown when non-image format was selected. | PASS |
| TC-AD-05 | Session expiration redirection | Expired sessions redirect to login screen, discarding unsaved changes. | Token expiry successfully redirected user to login and cleared state. | PASS |
| TC-DB-01 | Categories fetch queries | Query calls fetch categories successfully and returns category list. | Category list fetched successfully via Firestore getDocs. | PASS |
| TC-DB-02 | Category dish query filtering | Query returns only dishes matching the requested category ID. | Filtered results matching queried category ID perfectly. | PASS |
| TC-DB-03 | Dish persistence write | Dish document written to collection returns valid document ID. | Persisted dish document and returned auto-generated ID. | PASS |
| TC-DB-04 | Dish update write | Update query resolves with void and commits changes to Firestore. | Dish details modified, resolved successfully with void. | PASS |

## Summary

| Metric | Value |
| :--- | :--- |
| Total Test Cases | 18 |
| Passed | 18 |
| Failed | 0 |
| Pass Percentage | 100% |

## Failed Test Details

No failed test cases observed during execution.
