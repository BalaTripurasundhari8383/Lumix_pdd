const DriverFactory = require('../drivers/driver.factory');
const LoginPage = require('../pages/login.page');
const { expect } = require('chai');
const logger = require('../utils/logger');

describe('Authentication Flow', function () {
    let driver;
    let loginPage;

    before(async function () {
        driver = await DriverFactory.createDriver();
        loginPage = new LoginPage(driver);
    });

    after(async function () {
        if (driver) {
            await driver.deleteSession();
        }
    });

    afterEach(async function () {
        if (this.currentTest.state === 'failed') {
            await loginPage.takeScreenshot(this.currentTest.title);
            const logs = await loginPage.getLogs();
            // Save logs to file if needed
        }
    });

    it('should show error for empty credentials', async function () {
        logger.info('Starting test: Empty credentials');
        await loginPage.login('', '');
        const error = await loginPage.getValidationMessage('email_error');
        expect(error).to.equal('Email is required');
    });

    it('should login successfully with valid credentials', async function () {
        logger.info('Starting test: Valid login');
        await loginPage.login('student@lumixxx.com', 'Password123!');
        const logoutBtn = await loginPage.logoutButton;
        expect(await logoutBtn.isDisplayed()).to.be.true;
    });

    it('should logout successfully', async function () {
        logger.info('Starting test: Logout');
        const logoutBtn = await loginPage.logoutButton;
        await loginPage.click(logoutBtn);
        const loginBtn = await loginPage.loginButton;
        expect(await loginBtn.isDisplayed()).to.be.true;
    });
});
