const { remote } = require('webdriverio');
const { getAppiumOptions } = require('../config/appium.config');
const { logger } = require('./logger');

let driverInstance = null;
let currentAutomationName = 'Flutter';

class DriverFactory {
  /**
   * Initializes Appium session. Tries appium-flutter-driver first, fallback to UiAutomator2 if needed.
   */
  static async createDriver() {
    if (driverInstance) {
      return driverInstance;
    }

    const primaryDriver = env.automationName || 'UiAutomator2';
    const secondaryDriver = env.fallbackAutomationName || 'Flutter';

    try {
      logger.info(`Initializing Appium session with ${primaryDriver} driver...`);
      const options = getAppiumOptions(primaryDriver);
      driverInstance = await remote(options);
      currentAutomationName = primaryDriver;
      logger.info(`Appium session initialized successfully with ${primaryDriver} driver.`);
      return driverInstance;
    } catch (primaryErr) {
      logger.warn(`Failed to launch session with ${primaryDriver} driver: ${primaryErr.message}`);
      logger.info(`Attempting fallback session initialization with ${secondaryDriver} driver...`);
      try {
        const fallbackOptions = getAppiumOptions(secondaryDriver);
        driverInstance = await remote(fallbackOptions);
        currentAutomationName = secondaryDriver;
        logger.info(`Fallback Appium session initialized successfully with ${secondaryDriver} driver.`);
        return driverInstance;
      } catch (fallbackErr) {
        logger.error(`Critical Failure: Could not launch Appium session with either driver. ${fallbackErr.message}`);
        throw fallbackErr;
      }
    }
  }

  static getDriver() {
    if (!driverInstance) {
      throw new Error('Driver instance has not been initialized. Call DriverFactory.createDriver() first.');
    }
    return driverInstance;
  }

  static getAutomationName() {
    return currentAutomationName;
  }

  static async quitDriver() {
    if (driverInstance) {
      try {
        logger.info('Closing Appium driver session...');
        await driverInstance.deleteSession();
      } catch (err) {
        logger.warn(`Error while closing driver session: ${err.message}`);
      } finally {
        driverInstance = null;
      }
    }
  }
}

module.exports = DriverFactory;
