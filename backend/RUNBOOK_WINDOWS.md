# Runbook: Oracle on Windows Local (Revised)

This guide details how to run the Backend and Flutter App on a Windows machine, ensuring 8080 port availability and Flutter Web execution.

## 1. Prerequisites
- Node.js (v18+)
- Flutter SDK (v3.x+)
- Chrome Browser

## 2. Backend (NestJS)
**Goal:** Ensure API is listening on `http://localhost:8080`.

### A. Starting the Server
The server is configured to **stay alive** even if Docker/DB is offline (DEV mode).

```powershell
cd oracle/backend
npm install
npm run start:dev
```

### B. Verification
Open a new CMD terminal:
```powershell
curl -i http://localhost:8080/health
# Expected Output:
# HTTP/1.1 200 OK
# {"status":"ok",...}
```

### C. Troubleshooting
**Flutter Execution Fails (l10n error):**
Ensure `pubspec.yaml` has `generate: true`:
```yaml
flutter:
  uses-material-design: true
  generate: true
```

**Port 8080 In Use:**
If server fails with `EADDRINUSE`:
```powershell
netstat -ano | findstr :8080
taskkill /F /PID <PID>
```

## 3. Flutter App
**Goal:** Run the app on Web (Chrome).

### A. Setup & Analysis
```powershell
cd oracle/apps/flutter
flutter config --enable-web
flutter pub get
flutter analyze
# Expected: "No issues found!"
```

### B. Running (Web)
Use `dart-define` to point to the local backend.
```powershell
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080
```

### C. Running (Windows Desktop)
```powershell
flutter config --enable-windows-desktop
flutter run -d windows --dart-define=API_BASE_URL=http://localhost:8080
```

### D. Running (Android Emulator)
**Prerequisite:** Android Studio must be installed and an Emulator (AVD) created.

1. **Launch Emulator:**
   - Open Android Studio -> Device Manager -> Start a Virtual Device (e.g., Pixel API 30+).
   - Or via command line (if properly configured): `emulator -avd <Your_AVD_Name>`

2. **Run App:**
   - The Android Emulator uses `10.0.2.2` to access `localhost` of the host machine.
   - Use the specific base URL for Android:
   ```powershell
   flutter run -d emulator --dart-define=API_BASE_URL=http://10.0.2.2:8080
   ```

3. **Troubleshooting:**
   - If `ERR_CONNECTION_REFUSED`: Ensure Backend is running on port 8080.
   - If build fails: Check `android/app/build.gradle` for `minSdk` compatibility (Needs API 26+).

