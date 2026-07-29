const SeleniumConfig = require('../config/selenium.config');
const ExcelReporter = require('../utils/excel-reporter');
const { logger, recordLog } = require('../utils/logger');

const testResults = [];
let suiteStartTime = 0;
let globalDriver = null;

exports.mochaHooks = {
  async beforeAll() {
    logger.info('=== Starting Flutter Web Selenium E2E Test Suite ===');
    suiteStartTime = Date.now();
    globalDriver = await SeleniumConfig.createDriver();
    global.driver = globalDriver;
  },

  async beforeEach() {
    const testTitle = this.currentTest ? this.currentTest.fullTitle() : 'E2E Test Case';
    logger.info(`---> Executing: ${testTitle}`);
    recordLog('Suite', `Start Test: ${testTitle}`, 'RUNNING');
  },

  async afterEach() {
    const test = this.currentTest;
    if (!test) return;

    const duration = test.duration || 0;
    const isPassed = test.state === 'passed';
    const isFailed = test.state === 'failed';
    const isSkipped = test.pending || (!isPassed && !isFailed);

    let screenshotPath = null;
    let errorStack = null;
    let errorMessage = null;

    if (isFailed) {
      if (test.err) {
        errorMessage = test.err.message || String(test.err);
        errorStack = test.err.stack || String(test.err);
      }
      logger.error(`[FAIL] ${test.fullTitle()} - Error: ${errorMessage}`);
      screenshotPath = await SeleniumConfig.captureScreenshot(globalDriver, test.title);
    } else if (isPassed) {
      logger.info(`[PASS] ${test.fullTitle()} (${duration}ms)`);
    }

    testResults.push({
      title: test.title,
      fullTitle: test.fullTitle(),
      suite: test.parent ? test.parent.title : 'Root Suite',
      status: isPassed ? 'PASS' : isFailed ? 'FAIL' : 'SKIP',
      duration,
      errorMessage,
      errorStack,
      screenshotPath
    });
  },

  async afterAll() {
    const totalDurationMs = Date.now() - suiteStartTime;
    logger.info(`=== Test Suite Completed in ${(totalDurationMs / 1000).toFixed(2)}s ===`);
    
    // Close Selenium Browser
    await SeleniumConfig.quitDriver(globalDriver);

    // Generate Excel Report
    try {
      const excelPath = await ExcelReporter.generateReport(testResults, totalDurationMs);
      logger.info(`Excel analysis report generated: ${excelPath}`);
    } catch (err) {
      logger.error(`Failed to generate Excel report: ${err.message}`);
    }
  }
};
