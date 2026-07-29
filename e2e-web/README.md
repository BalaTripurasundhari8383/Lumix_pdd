# Lumix Flutter Web E2E Automation Framework

An enterprise-grade End-to-End (E2E) UI Automation Framework for **Flutter Web Applications** using **Selenium WebDriver (Node.js)**, **Mocha**, **Chai**, and **ExcelJS**.

---

## 🛠️ Tech Stack & Dependencies
- **Runtime**: Node.js (v18+)
- **Browser Automation**: `selenium-webdriver` (v4.23+)
- **Browser Drivers**: `chromedriver`
- **Test Runner & Assertions**: `mocha` (v10+), `chai` (v4+)
- **Reporting Engine**: `exceljs` (v4.4+), `winston`
- **Backend Integration**: Supabase Auth

---

## 📁 Architecture & Directory Structure

```
e2e-web/
├── config/
│   ├── env.js                # Environment configuration loader
│   └── selenium.config.js    # Driver factory & Flutter Web Chrome options
├── pages/                    # Page Object Model (POM) layer
│   ├── basePage.js           # Base page with explicit waits & logging
│   ├── authPage.js           # Supabase Auth POM (Login/Signup/Roles)
│   ├── dashboardPage.js      # Dashboard Navigation POM
│   ├── formPage.js           # Form Submission POM
│   └── aiComponentPage.js    # AI Assistant Interaction POM
├── utils/
│   ├── excel-reporter.js     # ExcelJS Multi-tab report generator (.xlsx)
│   ├── flutterWebHelper.js   # Flutter Web canvas, shadow DOM & explicit waits
│   └── logger.js             # Winston logger for step recording
├── tests/
│   ├── setup.hooks.js        # Global Mocha lifecycle hooks & driver teardown
│   ├── auth.web.test.js      # Supabase Auth E2E test scenarios
│   ├── navigation.web.test.js# Dashboard navigation test scenarios
│   ├── forms.web.test.js     # Form input test scenarios
│   └── aiComponent.web.test.js # AI component test scenarios
├── reports/                  # Output directory for screenshots & .xlsx reports
├── .env                      # Local environment configuration
├── .env.example              # Template environment file
├── .mocharc.json             # Mocha runner options
└── package.json              # E2E web package manifest
```

---

## 🚀 Getting Started

### 1. Installation Commands
```bash
# Navigate to web test directory
cd e2e-web

# Install dependencies
npm install
```

Or from the project root:
```bash
npm install --prefix e2e-web
```

---

## 🧪 Executing Web Tests

| Command | Description |
| :--- | :--- |
| `npm run test:web` | Run the complete Web E2E test suite |
| `npm run test:web:auth` | Run Supabase Authentication tests (`auth.web.test.js`) |
| `npm run test:web:nav` | Run Dashboard Navigation tests (`navigation.web.test.js`) |
| `npm run test:web:forms` | Run Form Submission tests (`forms.web.test.js`) |
| `npm run test:web:ai` | Run AI Core component tests (`aiComponent.web.test.js`) |
| `npm run report:web:excel` | Re-generate Excel test analysis report manually |

---

## 📊 Excel Test Analysis Report (`excel-reporter.js`)

After test suite completion, an Excel report (`Flutter_Web_E2E_Report.xlsx`) is automatically generated in `reports/`:

1. **Executive Summary Tab**: High-level execution metrics (Pass Rate %, Total/Passed/Failed/Skipped counts, duration, browser details).
2. **Test Analysis Report Tab**: Detailed table containing Test ID (`TC-WEB-xxx`), Module, Scenario Name, Status (PASS/FAIL), Execution Time (ms), and Stack Trace.
3. **Failed Tests Tab**: Focused failure diagnostics showing test name, error message, full error stack trace, and screenshot paths.
4. **Execution Logs Tab**: Chronological audit log of every step, click, input, and assertion.

---

## ⚡ Flutter Web Automation Specifics (`flutterWebHelper.js`)

Flutter Web applications render elements differently from traditional HTML pages. This framework solves common Flutter Web automation challenges:

- **Explicit Waits (`driver.wait`)**: Waits for Flutter Web engine initialization and rendering completion (`waitForFlutterReady`).
- **Semantics Tree Activation**: Toggles Flutter accessibility tree (`<flt-semantics-placeholder>`) so web elements are discoverable.
- **Shadow DOM Traversal**: Interacts with elements inside `<flt-glass-pane>` and `<flutter-view>` shadow DOM roots (`findElementInShadowDom`).
- **Resilient Input & Click Handling**: Supports standard DOM input/click fallback to JavaScript event triggers when canvas overlay blocks default clicks.
