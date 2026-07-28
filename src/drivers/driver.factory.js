const { remote } = require('webdriverio');
const logger = require('../utils/logger');
const path = require('path');

class DriverFactory {
    static async createDriver() {
        const caps = {
            'platformName': 'Android',
            'appium:automationName': 'Flutter', // Defaulting to Flutter
            'appium:deviceName': process.env.DEVICE_NAME || 'Android Emulator',
            'appium:app': path.join(process.cwd(), './app/app-release.apk'),
            'appium:appPackage': 'com.company.app',
            'appium:appActivity': 'com.company.app.MainActivity',
            'appium:noReset': false,
            'appium:fullReset': true,
            'appium:autoGrantPermissions': true,
            'appium:retryBackoffTime': 500,
            'appium:maxTypingFrequency': 8,
            'appium:newCommandTimeout': 300
        };

        logger.info('Initializing Appium driver with capabilities: ' + JSON.stringify(caps));

        try {
            const driver = await remote({
                path: '/',
                port: 4723,
                capabilities: caps,
                logLevel: 'error'
            });
            return driver;
        } catch (error) {
            logger.error('Failed to initialize driver: ' + error.message);
            throw error;
        }
    }
}

module.exports = DriverFactory;
