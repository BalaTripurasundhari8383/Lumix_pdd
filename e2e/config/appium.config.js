const env = require('./env');
const { execSync } = require('child_process');
const fs = require('fs');

/**
 * Helper to auto-detect first connected Android device or running emulator via ADB.
 */
function getConnectedDevice() {
  try {
    const output = execSync('adb devices', { encoding: 'utf-8' });
    const lines = output.trim().split('\n').slice(1);
    for (const line of lines) {
      const parts = line.trim().split(/\s+/);
      if (parts.length >= 2 && parts[1] === 'device') {
        return parts[0];
      }
    }
  } catch (error) {
    // ADB not in PATH or execution failed
  }
  return null;
}

/**
 * Returns WebdriverIO / Appium 2.x options configuration object.
 * @param {string} automationType - 'Flutter' | 'UiAutomator2'
 */
function getAppiumOptions(automationType = env.automationName) {
  const deviceUdid = getConnectedDevice() || env.deviceName;
  const apkExists = fs.existsSync(env.apkPath);
  const isCI = process.env.CI === 'true' || process.env.GITHUB_ACTIONS === 'true';

  const capabilities = {
    platformName: env.platformName,
    'appium:automationName': automationType,
    'appium:deviceName': deviceUdid,
    'appium:appPackage': env.appPackage,
    'appium:appActivity': env.appActivity,
    'appium:newCommandTimeout': Math.floor(env.commandTimeoutMs / 1000),
    'appium:autoGrantPermissions': true,
    'appium:noReset': true,
    'appium:fullReset': false
  };

  if (getConnectedDevice()) {
    capabilities['appium:udid'] = deviceUdid;
  }

  if (apkExists) {
    capabilities['appium:app'] = env.apkPath;
  }

  return {
    hostname: env.appiumHost,
    port: env.appiumPort,
    path: env.appiumPath,
    logLevel: 'error',
    capabilities,
    connectionRetryTimeout: isCI ? 3000 : 15000,
    connectionRetryCount: 1
  };
}

module.exports = {
  getAppiumOptions,
  getConnectedDevice
};
