const DriverFactory = require('../drivers/driver.factory');
const LoginPage = require('../pages/login.page');
const { expect } = require('chai');
const logger = require('../utils/logger');

describe('Form Validation Testing', function () {
    let driver;
    let loginPage;

    before(async function () {
        driver = await DriverFactory.createDriver();
        loginPage = new LoginPage(driver);
    });

    after(async function () {
        if (driver) await driver.deleteSession();
    });

    it('should validate email format', async function () {
        await loginPage.login('invalid-email', 'Password123!');
        const error = await loginPage.getValidationMessage('email_error');
        expect(error).to.equal('Enter a valid email address');
    });

    it('should validate password minimum length', async function () {
        await loginPage.login('student@lumixxx.com', '123');
        const error = await loginPage.getValidationMessage('password_error');
        expect(error).to.contain('at least 8 characters');
    });

    it('should validate required fields on submit', async function () {
        const loginBtn = await loginPage.loginButton;
        await loginPage.click(loginBtn);

        const emailErr = await loginPage.getValidationMessage('email_error');
        const passErr = await loginPage.getValidationMessage('password_error');

        expect(emailErr).to.not.be.empty;
        expect(passErr).to.not.be.empty;
    });
});
