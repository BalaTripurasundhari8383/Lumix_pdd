const { By, until } = require('selenium-webdriver');
const FlutterWebHelper = require('../utils/flutterWebHelper');
const { recordLog, logger } = require('../utils/logger');
const env = require('../config/env');

class BasePage {
  constructor(driver) {
    this.driver = driver;
  }

  /**
   * Navigates to target relative or absolute URL and waits for Flutter Web ready
   */
  async navigateTo(path = '') {
    const targetUrl = path.startsWith('http') ? path : `${env.baseUrl}${path.startsWith('/') ? path : '/' + path}`;
    logger.info(`Navigating to URL: ${targetUrl}`);
    await this.driver.get(targetUrl);
    await FlutterWebHelper.waitForFlutterReady(this.driver);
    recordLog('Navigation', `Navigate to ${targetUrl}`, 'SUCCESS');
  }

  /**
   * Universal explicit wait helper
   */
  async waitFor(conditionFn, timeoutMs = env.explicitWaitMs, message = 'Condition timed out') {
    return await this.driver.wait(conditionFn, timeoutMs, message);
  }

  /**
   * Finds an element with explicit wait
   */
  async find(locator) {
    return await FlutterWebHelper.waitForElement(this.driver, locator);
  }

  /**
   * Types text into input field safely
   */
  async type(locatorOrSelector, text) {
    await FlutterWebHelper.fillInput(this.driver, locatorOrSelector, text);
    recordLog('Input', `Type into ${locatorOrSelector}`, 'SUCCESS', `Text length: ${text.length}`);
  }

  /**
   * Clicks an element with retry / JS fallback
   */
  async click(locatorOrSelector) {
    await FlutterWebHelper.clickElement(this.driver, locatorOrSelector);
    recordLog('Action', `Clicked ${locatorOrSelector}`, 'SUCCESS');
  }

  /**
   * Asserts text presence on page
   */
  async verifyTextPresent(text, timeoutMs = env.explicitWaitMs) {
    const isPresent = await FlutterWebHelper.waitForText(this.driver, text, timeoutMs);
    recordLog('Assertion', `Verify text "${text}" present`, isPresent ? 'PASS' : 'FAIL');
    return isPresent;
  }

  /**
   * Fetches current page title
   */
  async getTitle() {
    return await this.driver.getTitle();
  }
}

module.exports = BasePage;
