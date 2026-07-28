const { pageBack } = require('appium-flutter-finder');
const { find, FlutterFinder } = require('../utils/finder');
const { logger } = require('../utils/logger');
const env = require('../config/env');
const DriverFactory = require('../utils/driverFactory');

class BasePage {
  constructor(driver) {
    this.driver = driver;
    this.find = find; // Exposes find.byValueKey(), find.byText(), find.bySemanticsLabel()
  }

  /**
   * Locators by ValueKey
   */
  byValueKey(key) {
    return FlutterFinder.byValueKey(key);
  }

  /**
   * Locators by Text
   */
  byText(text) {
    return FlutterFinder.byText(text);
  }

  /**
   * Locators by Semantics Label
   */
  bySemanticsLabel(label) {
    return FlutterFinder.bySemanticsLabel(label);
  }

  /**
   * Locators by Accessibility ID
   */
  byAccessibilityId(id) {
    return FlutterFinder.byAccessibilityId(id);
  }

  /**
   * Locators by Widget Type
   */
  byType(type) {
    return FlutterFinder.byType(type);
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
   * Waits for element to be displayed.
   */
  async waitForElement(locator, timeout = env.explicitWaitMs) {
    const element = await this.driver.$(locator);
    await element.waitForDisplayed({ timeout });
    return element;
  }

  /**
   * Types text into element after clearing previous input.
   */
  async typeInput(locator, text) {
    logger.info(`Entering text into element: '${text}'`);
    const element = await this.waitForElement(locator);
    try {
      await element.clearValue();
    } catch (e) {
      // Ignore clear failure if element was empty
    }
    await element.setValue(text);
  }

  /**
   * Clears value of element.
   */
  async clearInput(locator) {
    logger.info('Clearing input field value...');
    const element = await this.waitForElement(locator);
    await element.clearValue();
  }

  /**
   * Clicks target element.
   */
  async clickElement(locator) {
    logger.info(`Clicking element locator: ${typeof locator === 'string' ? locator : JSON.stringify(locator)}`);
    const element = await this.waitForElement(locator);
    await element.click();
  }

  /**
   * Gets text displayed on element.
   */
  async getElementText(locator) {
    const element = await this.waitForElement(locator);
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
    try {
      if (DriverFactory.getAutomationName() === 'Flutter') {
        await pageBack(this.driver);
      } else {
        await this.driver.back();
      }
    } catch (err) {
      logger.warn(`Back navigation fallback triggered: ${err.message}`);
      await this.driver.back();
    }
  }
}

module.exports = BasePage;
