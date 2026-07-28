# Flutter Android Appium 2.x E2E Automation Setup & Execution Guide

This document provides complete instructions for setting up, configuring, executing, debugging, and maintaining the enterprise-grade Appium 2.x E2E test automation framework for Flutter Android applications.

---

## 📋 Prerequisites

Before running tests, ensure your host environment meets the following software requirements:

| Tool / Dependency | Recommended Version | Purpose |
| :--- | :--- | :--- |
| **Node.js** | v18.x or v20.x LTS | Execution environment for WebdriverIO & Mocha |
| **npm** | v9.x or v10.x | Package management |
| **Java JDK** | JDK 17 (Temurin / Oracle) | Required by Android SDK & UiAutomator2 driver |
| **Android SDK** | Android 10.0+ (API 29+) | Android build tools, platform tools, ADB, & emulator |
| **Appium Server** | Appium 2.x (`@next`) | Core mobile test automation server |
| **Appium Drivers** | `appium-flutter-driver`, `uiautomator2` | Flutter widget inspection & native fallback automation |

---

## ⚙️ Step 1: Environment Variables Configuration

Set up environment variables on your operating system (or create `e2e/.env` file):

### Windows (PowerShell):
```powershell
$env:ANDROID_HOME = "C:\Users\<YourUser>\AppData\Local\Android\Sdk"
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"
$env:PATH += ";$env:ANDROID_HOME\platform-tools;$env:ANDROID_HOME\emulator"
```

### macOS / Linux (bash/zsh):
```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
```

### Project `.env` Configuration (`e2e/.env`):
```env
APPIUM_HOST=127.0.0.1
APPIUM_PORT=4723
APPIUM_PATH=/

APK_PATH=./app/app-release.apk
APP_PACKAGE=com.company.app
APP_ACTIVITY=com.company.app.MainActivity

AUTOMATION_NAME=Flutter
FALLBACK_AUTOMATION_NAME=UiAutomator2
DEVICE_NAME=Android Emulator
PLATFORM_NAME=Android
PLATFORM_VERSION=14.0

AUTO_GRANT_PERMISSIONS=true
NO_RESET=true
FULL_RESET=false

EXPLICIT_WAIT_MS=30000
COMMAND_TIMEOUT_MS=120000
```

---

## 🛠️ Step 2: Global Appium 2.x & Drivers Installation

Install Appium 2.x globally along with the necessary drivers:

```bash
# 1. Install Appium 2.x
npm install -g appium@next

# 2. Install appium-flutter-driver (Preferred for Flutter widgets)
appium driver install --source=npm appium-flutter-driver

# 3. Install uiautomator2 (Native Android fallback)
appium driver install uiautomator2

# 4. Verify installed drivers
appium driver list
```

---

## 📦 Step 3: Install Framework Dependencies

Navigate to the `e2e/` directory and install project dependencies:

```bash
cd e2e
npm install
```

---

## 📲 Step 4: Connecting Android Device or Launching Emulator

### Option A: Connected Real Android Device (Android 10+ through 15+)
1. Enable **Developer Options** and **USB Debugging** on the target device.
2. Connect device via USB.
3. Verify connection in terminal:
   ```bash
   adb devices
   ```

### Option B: Android Studio Emulator
1. Launch Android Studio -> Device Manager.
2. Start an emulator (e.g., Pixel 7 - API 34).
3. Verify emulator registration via `adb devices`.

---

## 🚀 Step 5: Executing Test Suites

### 1. Launch Appium Server
In a separate terminal, start Appium:
```bash
appium
```

### 2. Run Test Suites

| Command | Suite Executed | Description |
| :--- | :--- | :--- |
| `npm test` | All Suites | Executes entire E2E test automation suite |
| `npm run test:auth` | Authentication | Login, empty fields, invalid credentials, logout, session persistence |
| `npm run test:forms` | Form Validation | Required fields, email/phone format, password complexity, date pickers, dropdowns, checkboxes, radios, switches |
| `npm run test:components` | UI & Gestures | 16 UI widgets (Buttons, Overlays, Dialogs, Cards, TabBar, Drawer) and 8 touch gestures |
| `npm run test:nav` | Navigation | Screen navigation, bottom navigation, drawer navigation, deep linking, back button, app restart |
| `npm run test:ai` | Smart AI Engine | Screen structure analysis, dynamic edge-case scenarios, navigation graph discovery, coverage expansion |

---

## 📊 Step 6: Test Reports & Failure Analysis

Upon test completion, artifacts are generated under `e2e/reports/`:

1. **Excel Report (`Flutter_E2E_Report.xlsx`)**:
   - **Sheet 1 - Summary**: High-level execution metrics (Pass rate, total/passed/failed/skipped count, duration, device name, Android version).
   - **Sheet 2 - Test Cases**: Test ID, module, scenario, execution status, device, duration.
   - **Sheet 3 - Failed Tests**: Failure reason, stack trace, screenshot path, device version.
   - **Sheet 4 - Execution Logs**: Step-by-step Winston execution log stream with timestamps.

2. **Mochawesome HTML Report (`reports/index.html`)**:
   - Open in any web browser for interactive visual charts, filterable specs, and embedded screenshots.

3. **Failure Artifacts (`reports/failures/`)**:
   - `screenshots/`: PNG screenshots captured at exact moment of failure.
   - `logs/`: Device `logcat` logs captured during failure.
   - `widget_trees/`: Flutter widget tree / page source XML dump.

---

## 🔄 Step 7: GitHub Actions CI/CD Integration

The framework includes a GitHub Actions workflow (`.github/workflows/flutter-appium.yml`) configured for automated headless execution on push/PR events:

1. **Checkout Repository**
2. **Setup Node.js 20**
3. **Setup Java JDK 17**
4. **Setup Android SDK**
5. **Create Android Emulator**
6. **Start Android Emulator**
7. **Install Appium 2.x & Drivers**
8. **Install E2E Dependencies**
9. **Install Target APK**
10. **Run Appium Test Suites**
11. **Generate Merged Reports**
12. **Upload Test Artifacts** (`Flutter_E2E_Report.xlsx`, `index.html`, logs, failure screenshots)
