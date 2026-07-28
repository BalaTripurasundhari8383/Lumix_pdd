const fs = require('fs');
const path = require('path');
const env = require('../config/env');
const { logger } = require('./logger');

const failedTestsRecord = [];

class FailureHandler {
  /**
   * Captures artifacts upon test failure.
   */
  static async handleFailure(driver, testTitle, error) {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const sanitizedTitle = testTitle.replace(/[^a-zA-Z0-9_-]/g, '_');
    
    const failuresDir = env.failuresDir;
    const screenshotsDir = path.join(failuresDir, 'screenshots');
    const logsDir = path.join(failuresDir, 'logs');
    const widgetTreesDir = path.join(failuresDir, 'widget_trees');

    [failuresDir, screenshotsDir, logsDir, widgetTreesDir].forEach((dir) => {
      if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
    });

    let screenshotPath = '';
    let logPath = '';
    let widgetTreePath = '';

    // 1. Capture Screenshot
    try {
      if (driver && typeof driver.takeScreenshot === 'function') {
        const screenshotBuffer = await driver.takeScreenshot();
        screenshotPath = path.join(screenshotsDir, `${sanitizedTitle}_${timestamp}.png`);
        fs.writeFileSync(screenshotPath, Buffer.from(screenshotBuffer, 'base64'));
        logger.info(`Saved failure screenshot to: ${screenshotPath}`);
      }
    } catch (err) {
      logger.warn(`Failed to capture screenshot: ${err.message}`);
    }

    // 2. Capture Device Logs (logcat)
    try {
      if (driver && typeof driver.getLogs === 'function') {
        const logs = await driver.getLogs('logcat');
        logPath = path.join(logsDir, `${sanitizedTitle}_${timestamp}.log`);
        const logContent = logs.map(l => `[${l.timestamp}] [${l.level}] ${l.message}`).join('\n');
        fs.writeFileSync(logPath, logContent);
        logger.info(`Saved device logcat to: ${logPath}`);
      }
    } catch (err) {
      logger.warn(`Failed to capture logcat logs: ${err.message}`);
    }

    // 3. Capture Flutter Widget Tree / Page Source
    try {
      if (driver && typeof driver.getPageSource === 'function') {
        const pageSource = await driver.getPageSource();
        widgetTreePath = path.join(widgetTreesDir, `${sanitizedTitle}_${timestamp}.xml`);
        fs.writeFileSync(widgetTreePath, pageSource);
        logger.info(`Saved page source / widget tree dump to: ${widgetTreePath}`);
      }
    } catch (err) {
      logger.warn(`Failed to capture widget tree dump: ${err.message}`);
    }

    const failureDetails = {
      testName: testTitle,
      failureReason: error.message || String(error),
      stackTrace: error.stack || '',
      screenshotPath,
      logPath,
      widgetTreePath,
      deviceName: env.deviceName,
      platformVersion: env.platformVersion,
      timestamp: new Date().toISOString()
    };

    failedTestsRecord.push(failureDetails);
    return failureDetails;
  }

  static getFailedTests() {
    return failedTestsRecord;
  }

  static clearFailedTests() {
    failedTestsRecord.length = 0;
  }
}

module.exports = FailureHandler;
