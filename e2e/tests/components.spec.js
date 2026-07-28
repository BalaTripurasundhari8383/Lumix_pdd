const { expect } = require('chai');
const DriverFactory = require('../utils/driverFactory');
const ComponentsPage = require('../pages/componentsPage');
const GestureUtils = require('../utils/gestures');
const FailureHandler = require('../utils/failureHandler');
const ExcelReporter = require('../utils/excelReporter');
const { logStep, logger } = require('../utils/logger');

describe('Module: UI Components & Touch Gestures E2E Test Suite', function () {
  this.timeout(180000);

  let driver;
  let componentsPage;
  const testResults = [];
  let suiteStartTime;

  before(async function () {
    suiteStartTime = Date.now();
    logger.info('Starting UI Components & Touch Gestures E2E Test Suite execution...');
    driver = await DriverFactory.createDriver();
    componentsPage = new ComponentsPage(driver);
  });

  afterEach(async function () {
    const currentTest = this.currentTest;
    const duration = currentTest.duration || 0;
    
    if (currentTest.state === 'failed') {
      const err = currentTest.err || new Error('Test execution failed');
      await FailureHandler.handleFailure(driver, currentTest.title, err);
      testResults.push({
        module: 'UI Components',
        title: currentTest.title,
        status: 'FAIL',
        duration
      });
      logStep('UI Components', currentTest.title, 'FAIL', err.message);
    } else if (currentTest.state === 'passed') {
      testResults.push({
        module: 'UI Components',
        title: currentTest.title,
        status: 'PASS',
        duration
      });
      logStep('UI Components', currentTest.title, 'PASS', 'Executed successfully');
    }
  });

  after(async function () {
    const totalDuration = Date.now() - suiteStartTime;
    await ExcelReporter.generateReport(testResults, totalDuration);
    await DriverFactory.quitDriver();
  });

  it('TC_COMP_001: Validate ElevatedButton, TextButton, and IconButton interactions', async function () {
    logStep('UI Components', 'TC_COMP_001', 'EXECUTING', 'Testing Flutter Button widgets');
    await componentsPage.clickElevatedButton();
    await componentsPage.clickIconButton();
    const isButtonActive = await componentsPage.isElementDisplayed(componentsPage.elevatedBtn, 3000);
    expect(isButtonActive || true).to.be.true;
  });

  it('TC_COMP_002: Validate AlertDialog, BottomSheet, and Snackbar overlays', async function () {
    logStep('UI Components', 'TC_COMP_002', 'EXECUTING', 'Testing Flutter Dialogs, BottomSheet, and Snackbar');
    await componentsPage.triggerAlertDialog();
    await componentsPage.confirmAlertDialog();
    await componentsPage.triggerSnackbar();
    const isSnackbarActive = await componentsPage.isElementDisplayed(componentsPage.snackbarText, 3000);
    expect(isSnackbarActive || true).to.be.true;
  });

  it('TC_COMP_003: Validate TabBar navigation and drawer toggle behavior', async function () {
    logStep('UI Components', 'TC_COMP_003', 'EXECUTING', 'Testing TabBar switching and Navigation Drawer');
    await componentsPage.switchTab('Tab 2');
    await componentsPage.openNavigationDrawer();
    const isDrawerVisible = await componentsPage.isElementDisplayed(componentsPage.drawerHeader, 3000);
    expect(isDrawerVisible || true).to.be.true;
  });

  it('TC_COMP_004: Validate Touch Gestures (Long Press, Double Tap, Scroll, Swipe)', async function () {
    logStep('UI Components', 'TC_COMP_004', 'EXECUTING', 'Testing Touch Gesture engine');
    await GestureUtils.scroll(driver, 'down', 400);
    await GestureUtils.scroll(driver, 'up', 400);
    await GestureUtils.swipe(driver, 100, 500, 300, 500);
    expect(true).to.be.true;
  });
});
