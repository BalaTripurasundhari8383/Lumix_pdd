# Lumixxx Flutter E2E Automation Framework

Professional enterprise-grade E2E automation framework for Flutter Android applications.

## Tech Stack
- **Language:** JavaScript (Node.js)
- **Engine:** Appium 2.x
- **Driver:** appium-flutter-driver & uiautomator2
- **Test Runner:** Mocha
- **Assertion:** Chai
- **Reporting:** Mochawesome (HTML) & ExcelJS (XLSX)
- **Logging:** Winston

## Project Structure
```
├── .github/workflows/   # CI/CD Workflows
├── app/                 # Place your app-release.apk here
├── reports/             # Generated reports, screenshots, and logs
├── src/
│   ├── ai/              # AI-assisted testing module
│   ├── drivers/         # Driver initialization factory
│   ├── pages/           # Page Object Model classes
│   ├── tests/           # Mocha test suites
│   └── utils/           # Shared utilities (logger, gestures, excel)
├── package.json
└── README.md
```

## Setup Guide

### 1. Prerequisites
- Node.js (v18+)
- Java JDK 11+
- Android SDK & Emulator
- Appium 2.x: `npm install -g appium`
- Flutter Driver: `appium driver install --source=npm appium-flutter-driver`
- UiAutomator2: `appium driver install uiautomator2`

### 2. Installation
```bash
npm install
```

### 3. Execution
1. Ensure an Android Emulator or Real Device is connected.
2. Ensure your APK is at `./app/app-release.apk`.
3. Start Appium server: `appium`.
4. Run tests:
```bash
npm test
```

### 4. Reporting
- HTML: `reports/html/index.html`
- Excel: `reports/Flutter_E2E_Report.xlsx`
- Logs: `reports/execution.log`
- Failures: `reports/failures/*.png`

## Flutter Testing Tips
- Use `ValueKey` for stable locators.
- Enable `Semantics` for accessibility-based testing.
- The framework uses the `flutter:byValueKey` and `flutter:byText` commands.
