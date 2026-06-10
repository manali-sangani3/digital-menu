# Initialize Flutter Web Application and Firestore Database

This plan outlines the steps to create a new folder `digital_menu` in the root workspace, initialize the Flutter web application inside it, set up Firestore, and configure all basic Clean Architecture boilerplate code and configuration files.

## User Review Required

> [!IMPORTANT]
> - A new directory named `digital_menu` will be created in the root workspace, and `flutter create` will be executed to initialize the Flutter Web app.
> - The Firestore database will be initialized using `firebase_init` via the firebase-mcp-server tool.
> - The `firebase_options.dart` file will be created inside the new app directory structure using the credentials retrieved from `walkthrough.md`.

## Open Questions

None.

## Proposed Changes

### Project Initialization & Config

#### [NEW] [pubspec.yaml](file:///Users/neosoft/StudioProjects/vibe-coding-poc/digital_menu/pubspec.yaml)
Add dependencies for Clean Architecture and Firebase integration.
- dependencies: `flutter_bloc`, `firebase_core`, `cloud_firestore`, `go_router`, `get_it`, `cached_network_image`, `freezed_annotation`, `json_annotation`
- dev_dependencies: `build_runner`, `freezed`, `json_serializable`, `bloc_test`, `mocktail`

#### [NEW] [firebase_options.dart](file:///Users/neosoft/StudioProjects/vibe-coding-poc/digital_menu/lib/core/config/firebase_options.dart)
Define Firebase configuration parameters for the `digital-menu-prod-2026` project.

---

### Clean Architecture & Core Structure

#### [NEW] [main.dart](file:///Users/neosoft/StudioProjects/vibe-coding-poc/digital_menu/lib/main.dart)
Initialize Firebase and path URL strategy, then run the MaterialApp.

#### [NEW] [app.dart](file:///Users/neosoft/StudioProjects/vibe-coding-poc/digital_menu/lib/app.dart)
Configure MaterialApp using GoRouter and Material 3 design tokens.

#### [NEW] [router.dart](file:///Users/neosoft/StudioProjects/vibe-coding-poc/digital_menu/lib/core/router/router.dart)
GoRouter configurations mapping `/menu` and `/admin` paths.

#### [NEW] [di.dart](file:///Users/neosoft/StudioProjects/vibe-coding-poc/digital_menu/lib/core/di/di.dart)
GetIt setup for dependency injection.

---

## Verification Plan

### Automated Tests
- Run `flutter analyze` inside the `digital_menu` directory.

### Manual Verification
- Verify that the `digital_menu` directory contains the expected Clean Architecture layout.
- Verify Firestore configuration initialization.
