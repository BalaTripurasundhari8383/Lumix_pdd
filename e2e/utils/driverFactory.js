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

    try {
      logger.info('Initializing Appium session with appium-flutter-driver...');
      const flutterOptions = getAppiumOptions('Flutter');
      driverInstance = await remote(flutterOptions);
      currentAutomationName = 'Flutter';
      logger.info('Appium session initialized successfully with Flutter driver.');
      return driverInstance;
    } catch (flutterErr) {
      logger.warn(`Failed to launch session with appium-flutter-driver: ${flutterErr.message}`);
      logger.info('Attempting fallback session initialization with UiAutomator2 driver...');
      try {
        const uiAutomatorOptions = getAppiumOptions('UiAutomator2');
        driverInstance = await remote(uiAutomatorOptions);
        currentAutomationName = 'UiAutomator2';
        logger.info('Fallback Appium session initialized successfully with UiAutomator2 driver.');
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
