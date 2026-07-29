const { By } = require('selenium-webdriver');
const BasePage = require('./basePage');
const FlutterWebHelper = require('../utils/flutterWebHelper');
const { recordLog } = require('../utils/logger');

class AuthPage extends BasePage {
  constructor(driver) {
    super(driver);
    // Locators matching Flutter Web output and accessibility semantics
    this.emailInput = 'input[type="email"], [aria-label="Email Address"]';
    this.passwordInput = 'input[type="password"], [aria-label="Password"]';
    this.nameInput = 'input[placeholder="Full Name"], [aria-label="Full Name"]';
    this.submitBtn = 'button, [role="button"]';
    this.toggleSignUpBtn = 'button:has-text("account"), [aria-label*="account"]';
  }

  /**
   * Performs Supabase Login Flow
   */
  async login(email, password) {
    recordLog('Auth', `Attempting login with email: ${email}`, 'STARTED');
    await this.navigateTo('/');
    
    await this.type(this.emailInput, email);
    await this.type(this.passwordInput, password);
    
    await FlutterWebHelper.clickElement(this.driver, By.xpath("//*[contains(text(), 'Sign In') or @aria-label='Sign In']"));
    await this.driver.sleep(1000);
    recordLog('Auth', `Submitted login form for ${email}`, 'SUCCESS');
  }

  /**
   * Performs Supabase Sign-Up Flow with Role Selection
   */
  async signUp(fullName, email, password, role = 'student') {
    recordLog('Auth', `Attempting sign-up for ${fullName} (${role})`, 'STARTED');
    await this.navigateTo('/');
    
    // Toggle to Sign Up mode
    await FlutterWebHelper.clickElement(this.driver, By.xpath("//*[contains(text(), 'Create an account') or contains(text(), 'New here')]"));
    await this.driver.sleep(500);

    // Fill Full Name
    await this.type(this.nameInput, fullName);

    // Select Role
    const roleCapitalized = role.charAt(0).toUpperCase() + role.slice(1);
    await FlutterWebHelper.clickElement(this.driver, By.xpath(`//*[contains(text(), '${roleCapitalized}')]`));

    // Fill Email and Password
    await this.type(this.emailInput, email);
    await this.type(this.passwordInput, password);

    // Submit Sign Up
    await FlutterWebHelper.clickElement(this.driver, By.xpath("//*[contains(text(), 'Create Account')]"));
    await this.driver.sleep(1000);
    recordLog('Auth', `Submitted sign up for ${email}`, 'SUCCESS');
  }

  /**
   * Verifies successful login/auth redirection
   */
  async isLoginSuccessful() {
    return await this.verifyTextPresent('Dashboard', 10000) || await this.verifyTextPresent('Welcome', 10000);
  }

  /**
   * Verifies SnackBar error message display
   */
  async getErrorMessage() {
    try {
      await FlutterWebHelper.waitForText(this.driver, 'fill in all fields', 3000);
      return 'Please fill in all fields';
    } catch (e) {
      try {
        await FlutterWebHelper.waitForText(this.driver, 'Invalid login credentials', 3000);
        return 'Invalid login credentials';
      } catch (err) {
        return null;
      }
    }
  }
}

module.exports = AuthPage;
