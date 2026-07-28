const { byValueKey, byText, bySemanticsLabel, byType, pageBack } = require('appium-flutter-finder');
const { logger } = require('../utils/logger');
const env = require('../config/env');
const DriverFactory = require('../utils/driverFactory');

class BasePage {
  constructor(driver) {
    this.driver = driver;
  }

  /**
   * Returns locator for Flutter Widget by ValueKey.
   */
  byValueKey(key) {
    if (DriverFactory.getAutomationName() === 'Flutter') {
      return byValueKey(key);
    }
    return `~${key}`; // Fallback to Accessibility ID for UiAutomator2
  }

  /**
   * Returns locator for Flutter Widget by Text.
   */
  byText(text) {
    if (DriverFactory.getAutomationName() === 'Flutter') {
      return byText(text);
    }
    return `//*[@text="${text}" or @content-desc="${text}"]`;
  }

  /**
   * Returns locator for Flutter Widget by Semantics Label.
   */
  bySemanticsLabel(label) {
    if (DriverFactory.getAutomationName() === 'Flutter') {
      return bySemanticsLabel(label);
    }
    return `~${label}`;
  }

  /**
   * Returns locator for Flutter Widget by Widget Type (e.g. 'ElevatedButton').
   */
  byType(type) {
    if (DriverFactory.getAutomationName() === 'Flutter') {
      return byType(type);
    }
    return `//${type}`;
  }

  /**
   * Finds element using locator.
   */
  async findElement(locator) {
    return await this.driver.$(locator);
  }

  /**
   * Finds element by ValueKey.
   */
  async findByValueKey(key) {
    const loc = this.byValueKey(key);
    return await this.driver.$(loc);
  }

  /**
   * Finds element by Text.
   */
  async findByText(text) {
    const loc = this.byText(text);
    return await this.driver.$(loc);
  }

  /**
   * Finds element by Semantics Label.
   */
  async findBySemanticsLabel(label) {
    const loc = this.bySemanticsLabel(label);
    return await this.driver.$(loc);
  }

  /**
   * Types text into element.
   */
  async typeInput(locator, text) {
    logger.info(`Entering text into element: '${text}'`);
    const element = await this.driver.$(locator);
    await element.waitForDisplayed({ timeout: env.explicitWaitMs });
    await element.clearValue();
    await element.setValue(text);
  }

  /**
   * Clicks target element.
   */
  async clickElement(locator) {
    logger.info(`Clicking element locator: ${JSON.stringify(locator)}`);
    const element = await this.driver.$(locator);
    await element.waitForDisplayed({ timeout: env.explicitWaitMs });
    await element.click();
  }

  /**
   * Gets text displayed on element.
   */
  async getElementText(locator) {
    const element = await this.driver.$(locator);
    await element.waitForDisplayed({ timeout: env.explicitWaitMs });
    return await element.getText();
  }

  /**
   * Checks if element is displayed.
   */
  async isElementDisplayed(locator, timeout = 5000) {
    try {
      const element = await this.driver.$(locator);
      return await element.waitForDisplayed({ timeout });
    } catch (e) {
      return false;
    }
  }

  /**
   * Executes back button navigation.
   */
  async navigateBack() {
    logger.info('Navigating back...');
    if (DriverFactory.getAutomationName() === 'Flutter') {
      await pageBack(this.driver);
    } else {
      await this.driver.back();
    }
  }
}

module.exports = BasePage;
