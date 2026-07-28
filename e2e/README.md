# Enterprise Appium 2.x E2E Automation Framework for Flutter Android

A production-ready, enterprise-grade mobile test automation framework designed specifically for **Flutter Android APKs** using **Appium 2.x**, **Node.js (JavaScript)**, **Mocha**, **Chai**, **Mochawesome**, **ExcelJS**, **Winston Logger**, and **GitHub Actions**.

---

## 🌟 Key Architecture & Capabilities

- 📱 **Appium 2.x & `appium-flutter-driver`**: Direct Flutter element locating using `find.byValueKey()`, `find.byText()`, `find.bySemanticsLabel()`, `find.byAccessibilityId()`, and `find.byType()` with automated fallback to `UiAutomator2`.
- 🏗️ **Page Object Model (POM)**: Decoupled, modular page classes for Authentication, Form Validation, UI Components, Navigation, and Dashboard.
- 🖐️ **Reusable Touch Gestures**: Built-in W3C actions library for `tap`, `doubleTap`, `longPress`, `scroll`, `swipe`, `dragAndDrop`, `pinch`, and `zoom`.
- 📊 **Multi-Tab Excel Reports**: Custom `ExcelJS` report (`reports/Flutter_E2E_Report.xlsx`) featuring 4 formatted sheets:
  1. **Summary**: Execution Date, Device, Platform Version, Pass Rate, Total/Passed/Failed/Skipped.
  2. **Test Cases**: Granular test details, status, and duration.
  3. **Failed Tests**: Failure logs, error stack traces, screenshot paths, device name, Android version.
  4. **Execution Logs**: Complete step-by-step execution stream with timestamps.
- 📄 **Mochawesome HTML Reporting**: Visual test dashboard output at `reports/index.html` with charts, filtering, and duration metrics.
- 🤖 **Smart AI Testing Module**: Automated screen analyzer, widget discovery engine, dynamic edge-case payload generator, navigation graph discovery, and dynamic coverage expander.
- 🛡️ **Robust Failure Handling**: Automated capture of screenshots, device `logcat` logs, screen state, and Flutter widget trees stored under `reports/failures/`.
- ⚡ **CI/CD Automation**: GitHub Actions workflow (`.github/workflows/flutter-appium.yml`) for automated headless Android emulator test runs with artifact publishing.

---

## 📁 Framework Directory Structure

```
e2e/
├── package.json                   # Dependencies & npm scripts
├── .mocharc.json                  # Mocha & Mochawesome test configuration
├── .env.example                   # Environment configuration template
├── SETUP_GUIDE.md                 # Full setup and execution guide
├── config/
│   ├── env.js                     # Environment variable loader (resolves APK_PATH)
│   └── appium.config.js           # Appium capabilities & ADB device auto-discovery
├── utils/
│   ├── finder.js                  # Flutter Finder utility (find.byValueKey, find.byText, etc.)
│   ├── driverFactory.js           # Driver session manager (Flutter -> UiAutomator2 fallback)
│   ├── logger.js                  # Winston logger with step tracking & Excel buffer
│   ├── gestures.js                # Touch & gesture utility library (8 reusable gestures)
│   ├── failureHandler.js          # Failure artifact capturer (Screenshots, logcat, widget tree)
│   ├── excelReporter.js           # 4-sheet Excel report generator
│   └── aiTestingEngine.js         # Smart AI screen discovery & dynamic test engine
├── pages/
│   ├── basePage.js                # Base page object with Flutter locators & find API
│   ├── loginPage.js               # Authentication page object
│   ├── formsPage.js               # Flutter form fields & validation page object
│   ├── componentsPage.js          # 16 UI component widgets page object
│   └── dashboardPage.js           # Shell dashboard navigation page object
├── tests/
│   ├── auth.spec.js               # Authentication E2E test suite
│   ├── forms.spec.js              # Form validation E2E test suite
│   ├── components.spec.js         # UI widgets & 8 touch gestures test suite
│   ├── navigation.spec.js         # Screen, bottom nav, drawer, deep link, & restart test suite
│   └── aiSmart.spec.js            # Smart AI exploratory test suite
└── README.md                      # Framework architecture & guide
```

---

## 🚀 Quick Setup Guide

### 1. Prerequisites
- **Node.js**: v18.x or v20.x LTS
- **Java JDK**: 17+
- **Android SDK & ADB**: Configured in system PATH (`ANDROID_HOME`)
- **Appium 2.x**:
  ```bash
  npm install -g appium@next
  appium driver install --source=npm appium-flutter-driver
  appium driver install uiautomator2
  ```

### 2. Install Framework Dependencies
```bash
cd e2e
npm install
```

### 3. Ensure Target APK Exists
Build the Flutter APK or verify its location (`./app/app-release.apk`):
```bash
flutter build apk --release
```

---

## 🧪 Executing Tests

### 1. Start Appium Server
```bash
appium
```

### 2. Run Test Suites
```bash
cd e2e

# Run all test suites
npm test

# Run specific test suites
npm run test:auth        # Authentication suite
npm run test:forms       # Form validation suite
npm run test:components  # UI components & gestures suite
npm run test:nav         # Screen navigation & deep linking suite
npm run test:ai          # Smart AI exploratory suite
```

---

## 📊 Reports & Deliverables

- **Excel Report**: `e2e/reports/Flutter_E2E_Report.xlsx`
- **HTML Report**: `e2e/reports/index.html`
- **Failure Artifacts**: `e2e/reports/failures/screenshots/`, `e2e/reports/failures/logs/`, `e2e/reports/failures/widget_trees/`
- **Execution Logs**: `e2e/reports/execution.log`
- **GitHub Workflow**: `.github/workflows/flutter-appium.yml`
