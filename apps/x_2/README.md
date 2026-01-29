# Flutter Figma Port

Port of the React/Vite web application to Flutter.

## Project Structure

- `lib/main.dart`: Application entry point.
- `lib/theme/`: App Theme and Color definitions (ported from `theme.css`).
- `lib/navigation/`: Routing logic using `go_router` and Main Scaffold (Bottom Nav).
- `lib/screens/`:
  - `home/`: Home screen implementation.
  - `profile/`: User profile screen.
  - `common/`: Shared widgets like `ComingSoonPage`.

## Getting Started

1.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

2.  **Run the App**:
    *   **Desktop**: `flutter run -d windows`
    *   **Web**: `flutter run -d chrome`
    *   **Mobile**: `flutter run -d emulator` (Ensure AVD is running)

## Porting Status

- [x] **Navigation**: Bottom Tab Bar (Home, Fortune, Compatibility, History, Profile) + Stack Navigation.
- [x] **Theme**: Warm Brown/Cream palette implemented in `AppTheme`.
- [x] **Home Screen**: UI ported with layout and styling matching React version.
- [x] **Placeholders**: `ComingSoonPage` implemented for missing features.
