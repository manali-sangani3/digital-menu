# Project Structure Creation

This plan outlines the steps to initialize the Flutter project and set up the clean architecture folder structure for the frontend and backend layers.

## User Review Required

> [!IMPORTANT]
> - We will initialize the Flutter project in the current workspace directory.
> - We will preserve the existing `lib/core/config/firebase_options.dart` configuration file that contains the active project SDK configurations.
> - The directories will be created to align with both the `personas/frontend_persona.md` and `personas/backend_persona.md` guidelines.

## Open Questions

None.

## Proposed Changes

### Project Structure Initialization

We will create the directory trees and files to match the Clean Architecture layout for both features (`menu` and `admin`).

#### [MODIFY] [pubspec.yaml](file:///Users/neosoft/StudioProjects/vibe-coding-poc/pubspec.yaml)
Add dependencies: `flutter_bloc`, `freezed`, `json_serializable`, `cloud_firestore`, `firebase_core`, `go_router`, `get_it`, `cached_network_image`.

#### [NEW] [main.dart](file:///Users/neosoft/StudioProjects/vibe-coding-poc/lib/main.dart)
Primary entry point, initialized with Firebase and URL strategy.

#### [NEW] [app.dart](file:///Users/neosoft/StudioProjects/vibe-coding-poc/lib/app.dart)
MaterialApp configuration, theme, and router injection.

#### [NEW] [core directories & files](file:///Users/neosoft/StudioProjects/vibe-coding-poc/lib/core)
- `core/config/` (Firebase initialization, options)
- `core/constants/` (Firestore collection names, document keys)
- `core/errors/` (Custom Firebase Failures/Exceptions mapping)
- `core/network/` (Network connectivity listeners)
- `core/theme/` (Typography scales, cafe color palette)
- `core/router/` (GoRouter configuration: `/menu`, `/admin`)
- `core/di/` (GetIt Service Locator)

#### [NEW] [features/menu directories & files](file:///Users/neosoft/StudioProjects/vibe-coding-poc/lib/features/menu)
Clean architecture folders: data, domain, presentation.

#### [NEW] [features/admin directories & files](file:///Users/neosoft/StudioProjects/vibe-coding-poc/lib/features/admin)
Clean architecture folders: data, domain, presentation.

#### [NEW] [shared & widgets directories](file:///Users/neosoft/StudioProjects/vibe-coding-poc/lib/shared)
- `shared/widgets/` (Skeletal shimmers, image frames)

---

## Verification Plan

### Automated Tests
- Run `flutter analyze` or `dart analyze` to ensure there are no compilation errors.

### Manual Verification
- Check folder structures via file listing.
