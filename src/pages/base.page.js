const logger = require('../utils/logger');
const path = require('path');
const fs = require('fs-extra');

class BasePage {
    constructor(driver) {
        this.driver = driver;
    }

    async findByText(text) {
        return await this.driver.execute('flutter:waitFor', this.driver.execute('flutter:byText', text));
    }

    async findByValueKey(key) {
        return await this.driver.execute('flutter:waitFor', this.driver.execute('flutter:byValueKey', key));
    }

    async findBySemanticsLabel(label) {
        return await this.driver.execute('flutter:waitFor', this.driver.execute('flutter:bySemanticsLabel', label));
    }

    async click(element) {
        logger.info(`Clicking on element`);
        await element.click();
    }

    async type(element, text) {
        logger.info(`Typing text: ${text}`);
        await element.setValue(text);
    }

    async takeScreenshot(testName) {
        const screenshotDir = path.join(__dirname, '../../reports/failures');
        await fs.ensureDir(screenshotDir);
        const filePath = path.join(screenshotDir, `${testName}_${Date.now()}.png`);
        await this.driver.saveScreenshot(filePath);
        logger.info(`Screenshot saved at: ${filePath}`);
        return filePath;
    }

    async getLogs() {
        return await this.driver.getLogs('logcat');
    }
}

module.exports = BasePage;
