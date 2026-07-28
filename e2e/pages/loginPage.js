const BasePage = require('./basePage');
const { logger } = require('../utils/logger');

class LoginPage extends BasePage {
  constructor(driver) {
    super(driver);

    // Locators using ValueKey, Text, Semantics
    this.emailInput = this.byValueKey('email_input_field');
    this.passwordInput = this.byValueKey('password_input_field');
    this.loginButton = this.byValueKey('login_submit_button');
    this.roleDropdown = this.byValueKey('role_select_dropdown');
    this.errorMessage = this.byValueKey('auth_error_message');
    this.welcomeHeader = this.byValueKey('dashboard_welcome_header');
    this.logoutButton = this.byValueKey('logout_menu_item');
    this.appTitle = this.byText('Academic Intelligence Portal');
  }

  async enterEmail(email) {
    await this.typeInput(this.emailInput, email);
  }

  async enterPassword(password) {
    await this.typeInput(this.passwordInput, password);
  }

  async selectRole(roleName) {
    logger.info(`Selecting role: ${roleName}`);
    await this.clickElement(this.roleDropdown);
    const roleOption = this.byText(roleName);
    await this.clickElement(roleOption);
  }

  async clickLogin() {
    logger.info('Clicking login button...');
    await this.clickElement(this.loginButton);
  }

  async performLogin(email, password, role = 'Student') {
    logger.info(`Executing login flow for user: ${email}`);
    await this.enterEmail(email);
    await this.enterPassword(password);
    await this.clickLogin();
  }

  async getErrorMessage() {
    return await this.getElementText(this.errorMessage);
  }

  async isDashboardDisplayed() {
    return await this.isElementDisplayed(this.welcomeHeader);
  }

  async performLogout() {
    logger.info('Performing logout...');
    await this.clickElement(this.logoutButton);
  }
}

module.exports = LoginPage;
