const { remote } = require('webdriverio');
const { getAppiumOptions, getConnectedDevice } = require('../config/appium.config');
const { logger } = require('./logger');
const env = require('../config/env');

let driverInstance = null;
let currentAutomationName = 'Flutter';

class DriverFactory {
  /**
   * Initializes Appium session. Tries appium-flutter-driver (preferred) first, fallback to UiAutomator2 if needed.
   */
  static async createDriver() {
    if (driverInstance) {
      return driverInstance;
    }

    const connectedDevice = getConnectedDevice();
    if (!connectedDevice) {
      logger.warn('[DriverFactory]: No connected Android device or running emulator was detected via ADB.');
      logger.warn('[DriverFactory]: Please start an emulator or connect a device via USB, and ensure Appium server is running on http://127.0.0.1:4723.');
    }

    const primaryDriver = env.automationName || 'Flutter';
    const secondaryDriver = env.fallbackAutomationName || 'UiAutomator2';

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

  /**
   * Restarts the target Android application.
   */
  static async restartApp() {
    if (!driverInstance) return;
    logger.info('Restarting application package...');
    try {
      await driverInstance.terminateApp(env.appPackage);
      await driverInstance.activateApp(env.appPackage);
    } catch (err) {
      logger.warn(`Restart app fallback: ${err.message}`);
    }
  }

  /**
   * Triggers a Deep Link URL.
   */
  static async deepLink(deepLinkUrl) {
    if (!driverInstance) return;
    logger.info(`Opening deep link: ${deepLinkUrl}`);
    try {
      await driverInstance.execute('mobile: deepLink', {
        url: deepLinkUrl,
        package: env.appPackage
      });
    } catch (err) {
      logger.warn(`Deep link execution warning: ${err.message}`);
    }
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
