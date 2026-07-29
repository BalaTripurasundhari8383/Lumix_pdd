const { Builder, Capabilities } = require('selenium-webdriver');
const chrome = require('selenium-webdriver/chrome');
const fs = require('fs');
const path = require('path');
const env = require('./env');

class SeleniumConfig {
  /**
   * Initializes and returns a Selenium WebDriver instance with Flutter Web optimized flags.
   */
  static async createDriver() {
    const options = new chrome.Options();
    
    // Set viewport dimensions
    options.addArguments('--window-size=1920,1080');
    options.addArguments('--start-maximized');
    
    // Flutter Web optimization flags
    options.addArguments('--no-sandbox');
    options.addArguments('--disable-dev-shm-usage');
    options.addArguments('--disable-gpu');
    options.addArguments('--disable-web-security');
    options.addArguments('--allow-running-insecure-content');
    options.addArguments('--enable-features=NetworkService,NetworkServiceInProcess');

    if (env.headless) {
      options.addArguments('--headless=new');
    }

    // Set Chrome prefs for performance and web logging
    options.setLoggingPrefs({ browser: 'ALL', driver: 'WARNING' });

    const driver = await new Builder()
      .forBrowser('chrome')
      .setChromeOptions(options)
      .build();

    // Configure timeouts
    await driver.manage().setTimeouts({
      implicit: env.implicitWaitMs,
      pageLoad: 30000,
      script: 30000
    });

    return driver;
  }

  /**
   * Captures full page screenshot and saves to screenshot directory
   */
  static async captureScreenshot(driver, testName) {
    try {
      if (!driver) return null;
      if (!fs.existsSync(env.screenshotsDir)) {
        fs.mkdirSync(env.screenshotsDir, { recursive: true });
      }
      
      const sanitizedName = testName.replace(/[^a-zA-Z0-9_-]/g, '_');
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
      const filePath = path.join(env.screenshotsDir, `${sanitizedName}_${timestamp}.png`);
      
      const image = await driver.takeScreenshot();
      fs.writeFileSync(filePath, image, 'base64');
      return filePath;
    } catch (err) {
      console.error(`Failed to capture screenshot for test "${testName}":`, err.message);
      return null;
    }
  }

  /**
   * Quits driver safely
   */
  static async quitDriver(driver) {
    if (driver) {
      try {
        await driver.quit();
      } catch (err) {
        console.error('Error shutting down Selenium WebDriver:', err.message);
      }
    }
  }
}

module.exports = SeleniumConfig;
