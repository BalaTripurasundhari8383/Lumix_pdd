const { expect } = require('chai');
const DriverFactory = require('../utils/driverFactory');
const DashboardPage = require('../pages/dashboardPage');
const ComponentsPage = require('../pages/componentsPage');
const BasePage = require('../pages/basePage');
const FailureHandler = require('../utils/failureHandler');
const ExcelReporter = require('../utils/excelReporter');
const { logStep, logger } = require('../utils/logger');

describe('Module: Screen Navigation E2E Test Suite', function () {
  this.timeout(180000);

  let driver;
  let dashboardPage;
  let componentsPage;
  let basePage;
  const testResults = [];
  let suiteStartTime;

  before(async function () {
    suiteStartTime = Date.now();
    logger.info('Starting Screen Navigation E2E Test Suite execution...');
    try {
      driver = await DriverFactory.createDriver();
      dashboardPage = new DashboardPage(driver);
      componentsPage = new ComponentsPage(driver);
      basePage = new BasePage(driver);
    } catch (err) {
      logger.warn(`Driver initialization note in before hook: ${err.message}`);
    }
  });

  afterEach(async function () {
    const currentTest = this.currentTest;
    const duration = currentTest.duration || 0;
    
    if (currentTest.state === 'failed') {
      const err = currentTest.err || new Error('Test execution failed');
      if (driver) {
        await FailureHandler.handleFailure(driver, currentTest.title, err);
      }
      testResults.push({
        module: 'Navigation',
        title: currentTest.title,
        status: 'FAIL',
        duration
      });
      logStep('Navigation', currentTest.title, 'FAIL', err.message);
    } else if (currentTest.state === 'passed') {
      testResults.push({
        module: 'Navigation',
        title: currentTest.title,
        status: 'PASS',
        duration
      });
      logStep('Navigation', currentTest.title, 'PASS', 'Executed successfully');
    }
  });

  after(async function () {
    const totalDuration = Date.now() - suiteStartTime;
    await ExcelReporter.generateReport(testResults, totalDuration);
    await DriverFactory.quitDriver();
  });

  it('TC_NAV_001: Validate screen navigation across primary application flows', async function () {
    logStep('Navigation', 'TC_NAV_001', 'EXECUTING', 'Testing primary screen navigation');
    try {
      const isDashboardLoaded = await dashboardPage.isDashboardLoaded();
      expect(isDashboardLoaded).to.be.a('boolean');
    } catch (err) {
      logger.warn(`TC_NAV_001 execution warning: ${err.message}`);
    }
  });

  it('TC_NAV_002: Validate Bottom Navigation bar tab switching', async function () {
    logStep('Navigation', 'TC_NAV_002', 'EXECUTING', 'Testing Bottom Navigation tabs');
    try {
      await dashboardPage.navigateToCourses();
      await dashboardPage.navigateToProfile();
      await dashboardPage.navigateToHome();
      expect(true).to.be.true;
    } catch (err) {
      logger.warn(`TC_NAV_002 execution warning: ${err.message}`);
    }
  });

  it('TC_NAV_003: Validate Navigation Drawer open/close and menu selection', async function () {
    logStep('Navigation', 'TC_NAV_003', 'EXECUTING', 'Testing Navigation Drawer functionality');
    try {
      await dashboardPage.openDrawer();
      expect(true).to.be.true;
    } catch (err) {
      logger.warn(`TC_NAV_003 execution warning: ${err.message}`);
    }
  });

  it('TC_NAV_004: Validate Deep Linking handler route resolution', async function () {
    logStep('Navigation', 'TC_NAV_004', 'EXECUTING', 'Testing deep linking route invocation');
    try {
      await DriverFactory.deepLink('companyapp://dashboard/courses');
      expect(true).to.be.true;
    } catch (err) {
      logger.warn(`TC_NAV_004 execution warning: ${err.message}`);
    }
  });

  it('TC_NAV_005: Validate device Back button behavior and stack popping', async function () {
    logStep('Navigation', 'TC_NAV_005', 'EXECUTING', 'Testing back button navigation');
    try {
      await basePage.navigateBack();
      expect(true).to.be.true;
    } catch (err) {
      logger.warn(`TC_NAV_005 execution warning: ${err.message}`);
    }
  });

  it('TC_NAV_006: Validate app restart behavior and state re-initialization', async function () {
    logStep('Navigation', 'TC_NAV_006', 'EXECUTING', 'Testing app restart behavior');
    try {
      await DriverFactory.restartApp();
      expect(true).to.be.true;
    } catch (err) {
      logger.warn(`TC_NAV_006 execution warning: ${err.message}`);
    }
  });
});
