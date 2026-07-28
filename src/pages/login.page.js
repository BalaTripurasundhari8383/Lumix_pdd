const BasePage = require('./base.page');

class LoginPage extends BasePage {
    constructor(driver) {
        super(driver);
    }

    // Locators using Flutter Finders (Conceptual)
    get emailField() { return this.findByValueKey('email_field'); }
    get passwordField() { return this.findByValueKey('password_field'); }
    get loginButton() { return this.findByText('Login'); }
    get errorMessage() { return this.findByValueKey('error_message'); }
    get logoutButton() { return this.findByText('Logout'); }

    async login(email, password) {
        const emailEl = await this.emailField;
        const passwordEl = await this.passwordField;
        const loginBtn = await this.loginButton;

        await this.type(emailEl, email);
        await this.type(passwordEl, password);
        await this.click(loginBtn);
    }

    async getValidationMessage(key) {
        const element = await this.findByValueKey(key);
        return await element.getText();
    }
}

module.exports = LoginPage;
