const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });

// Auto-detect & export ANDROID_HOME on Windows if missing
if (!process.env.ANDROID_HOME && !process.env.ANDROID_SDK_ROOT) {
  const defaultSdkPath = path.join(process.env.LOCALAPPDATA || 'C:\\Users\\ktrip\\AppData\\Local', 'Android\\Sdk');
  process.env.ANDROID_HOME = defaultSdkPath;
  process.env.ANDROID_SDK_ROOT = defaultSdkPath;
  const platformTools = path.join(defaultSdkPath, 'platform-tools');
  const emulatorTools = path.join(defaultSdkPath, 'emulator');
  process.env.PATH = `${process.env.PATH};${platformTools};${emulatorTools}`;
}

module.exports = {
  appiumHost: process.env.APPIUM_HOST || '127.0.0.1',
  appiumPort: parseInt(process.env.APPIUM_PORT || '4723', 10),
  appiumPath: process.env.APPIUM_PATH || '/',
  
  apkPath: path.resolve(process.cwd(), process.env.APK_PATH || './build/app/outputs/flutter-apk/app-release.apk'),
  appPackage: process.env.APP_PACKAGE || 'com.example.lumixxx',
  appActivity: process.env.APP_ACTIVITY || 'com.example.lumixxx.MainActivity',

  automationName: process.env.AUTOMATION_NAME || 'UiAutomator2',
  fallbackAutomationName: process.env.FALLBACK_AUTOMATION_NAME || 'Flutter',
  deviceName: process.env.DEVICE_NAME || 'Android Emulator',
  platformName: process.env.PLATFORM_NAME || 'Android',
  platformVersion: process.env.PLATFORM_VERSION || '14.0',

  autoGrantPermissions: process.env.AUTO_GRANT_PERMISSIONS === 'true',
  noReset: process.env.NO_RESET === 'true',
  fullReset: process.env.FULL_RESET === 'true',

  explicitWaitMs: parseInt(process.env.EXPLICIT_WAIT_MS || '30000', 10),
  commandTimeoutMs: parseInt(process.env.COMMAND_TIMEOUT_MS || '120000', 10),

  reportsDir: path.resolve(process.cwd(), process.env.REPORTS_DIR || './reports'),
  failuresDir: path.resolve(process.cwd(), process.env.FAILURES_DIR || './reports/failures')
};
