const path = require('path');
const fs = require('fs');
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

// Resolve default APK path checking relative to both workspace root & e2e directory
function resolveApkPath() {
  if (process.env.APK_PATH) {
    const customPath = path.resolve(process.cwd(), process.env.APK_PATH);
    if (fs.existsSync(customPath)) return customPath;
    const customPathParent = path.resolve(__dirname, '..', process.env.APK_PATH);
    if (fs.existsSync(customPathParent)) return customPathParent;
  }
  
  const candidatePaths = [
    path.resolve(__dirname, '../../build/app/outputs/flutter-apk/app-release.apk'),
    path.resolve(__dirname, '../../app/app-release.apk'),
    path.resolve(process.cwd(), './app/app-release.apk'),
    path.resolve(process.cwd(), './build/app/outputs/flutter-apk/app-release.apk')
  ];
  
  for (const candidate of candidatePaths) {
    if (fs.existsSync(candidate)) return candidate;
  }
  return candidatePaths[0]; // Default fallback
}

const isCI = process.env.CI === 'true' || process.env.GITHUB_ACTIONS === 'true';

module.exports = {
  appiumHost: process.env.APPIUM_HOST || '127.0.0.1',
  appiumPort: parseInt(process.env.APPIUM_PORT || '4723', 10),
  appiumPath: process.env.APPIUM_PATH || '/',
  
  apkPath: resolveApkPath(),
  appPackage: process.env.APP_PACKAGE || 'com.example.lumixxx',
  appActivity: process.env.APP_ACTIVITY || 'com.example.lumixxx.MainActivity',

  automationName: process.env.AUTOMATION_NAME || 'UiAutomator2',
  fallbackAutomationName: process.env.FALLBACK_AUTOMATION_NAME || 'Flutter',
  deviceName: process.env.DEVICE_NAME || 'Android Emulator',
  platformName: process.env.PLATFORM_NAME || 'Android',
  platformVersion: process.env.PLATFORM_VERSION || '14.0',

  autoGrantPermissions: true,
  noReset: process.env.NO_RESET === 'true',
  fullReset: false,

  explicitWaitMs: isCI ? 3000 : parseInt(process.env.EXPLICIT_WAIT_MS || '30000', 10),
  commandTimeoutMs: isCI ? 15000 : parseInt(process.env.COMMAND_TIMEOUT_MS || '120000', 10),

  reportsDir: path.resolve(process.cwd(), process.env.REPORTS_DIR || './reports'),
  failuresDir: path.resolve(process.cwd(), process.env.FAILURES_DIR || './reports/failures')
};
