# Enterprise Appium 2.x E2E Automation Framework for Flutter Android

A production-ready, enterprise-grade mobile test automation framework designed specifically for **Flutter Android APKs** using **Appium 2.x**, **Node.js (JavaScript)**, **Mocha**, **Chai**, **Mochawesome**, **ExcelJS**, **Winston Logger**, and **GitHub Actions**.

---

## 🌟 Key Features

- 📱 **Appium 2.x & `appium-flutter-driver`**: Direct Flutter element locating using `byValueKey`, `byText`, and `bySemanticsLabel` with automated fallback to `UiAutomator2`.
- 🏗️ **Page Object Model (POM)**: Decoupled, modular page classes for Authentication, Form Validation, UI Components, and Dashboard Navigation.
- 🖐️ **Reusable Touch Gestures**: Built-in helpers for `tap`, `doubleTap`, `longPress`, `scroll`, `swipe`, `dragAndDrop`, `pinch`, and `zoom`.
- 📊 **Multi-Tab Excel Reports**: Custom `ExcelJS` report (`reports/Flutter_E2E_Report.xlsx`) featuring 4 sheets:
  1. **Summary**: Execution Date, Device, OS Version, Pass Rate, Total/Passed/Failed/Skipped.
  2. **Test Cases**: Granular test details, status, and duration.
  3. **Failed Tests**: Failure logs, error stack traces, screenshot paths.
  4. **Execution Logs**: Complete step-by-step execution stream.
- 📄 **Mochawesome HTML Reporting**: Visual test dashboard output at `reports/index.html`.
- 🤖 **Smart AI Testing Module**: Automated screen analyzer, widget discovery engine, dynamic edge-case payload generator, and navigation graph discovery.
- 🛡️ **Robust Failure Handling**: Automated capture of screenshots, device `logcat` logs, screen state, and Flutter widget trees stored under `reports/failures/`.
- ⚡ **CI/CD Automation**: GitHub Actions workflow (`.github/workflows/flutter-appium.yml`) for automated headless Android emulator test runs.

---

## 📁 Framework Directory Structure

```
e2e/
├── package.json                   # Dependencies & npm scripts
├── .mocharc.json                  # Mocha & Mochawesome test configuration
├── .env.example                   # Environment configuration template
├── config/
│   ├── env.js                     # Environment variable loader
│   └── appium.config.js           # Appium capabilities & device auto-discovery
├── utils/
│   ├── driverFactory.js           # Driver session manager (Flutter -> UiAutomator2 fallback)
│   ├── logger.js                  # Winston logger with step tracking
│   ├── gestures.js                # Touch & gesture utility library
│   ├── failureHandler.js          # Failure artifact capturer (Screenshots, logcat, widget tree)
│   ├── excelReporter.js           # 4-sheet Excel report generator
│   └── aiTestingEngine.js         # Smart AI screen discovery & dynamic test engine
├── pages/
│   ├── basePage.js                # Base page object with Flutter locator primitives
│   ├── loginPage.js               # Authentication page object
│   ├── formsPage.js               # Flutter form fields & validation page object
│   ├── componentsPage.js          # UI component widgets page object
│   └── dashboardPage.js           # Student shell dashboard navigation page object
├── tests/
│   ├── auth.spec.js               # Authentication E2E test suite
│   ├── forms.spec.js              # Form validation E2E test suite
│   ├── components.spec.js         # UI widgets & gestures test suite
│   └── aiSmart.spec.js            # Smart AI exploratory test suite
└── README.md                      # Setup and execution guide
```

---

## 🚀 Quick Setup Guide

### 1. Prerequisites
- **Node.js**: v18.x or v20.x
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

### 3. Ensure Flutter Release APK Exists
Build the Flutter APK or verify its location:
```bash
flutter build apk --release
# Default location: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🧪 Executing Tests

### 1. Start Appium Server
In a separate terminal, launch the Appium 2.x server:
```bash
appium
```

### 2. Run All E2E Test Suites
```bash
cd e2e
npm test
```

### 3. Run Specific Test Suites
```bash
npm run test:auth        # Run Authentication tests
npm run test:forms       # Run Form Validation tests
npm run test:components  # Run UI Components & Gestures tests
npm run test:ai          # Run Smart AI Exploratory tests
```

---

## 📊 Viewing Test Reports

After test execution completes:
- **Excel Report**: Open `e2e/reports/Flutter_E2E_Report.xlsx` in Microsoft Excel.
- **HTML Report**: Open `e2e/reports/index.html` in any web browser.
- **Failure Artifacts**: Check `e2e/reports/failures/screenshots/` and `e2e/reports/failures/logs/`.

---

## 🔄 GitHub Actions CI/CD Pipeline

The GitHub Actions workflow is defined at `.github/workflows/flutter-appium.yml`.

### Workflow Execution Flow:
1. Checks out repository source code.
2. Sets up Node.js 20 & JDK 17.
3. Installs Flutter SDK & compiles `app-release.apk`.
4. Spawns a headless Android Emulator (API level 34).
5. Launches Appium server & runs the full E2E test suite.
6. Generates Mochawesome HTML and Excel reports.
7. Uploads test artifacts (`Flutter_E2E_Report.xlsx`, `index.html`, failure screenshots, logcat logs).
