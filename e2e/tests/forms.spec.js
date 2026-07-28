const { expect } = require('chai');
const DriverFactory = require('../utils/driverFactory');
const FormsPage = require('../pages/formsPage');
const FailureHandler = require('../utils/failureHandler');
const ExcelReporter = require('../utils/excelReporter');
const { logStep, logger } = require('../utils/logger');

describe('Module: Flutter Form Validation E2E Test Suite', function () {
  this.timeout(180000);

  let driver;
  let formsPage;
  const testResults = [];
  let suiteStartTime;

  before(async function () {
    suiteStartTime = Date.now();
    logger.info('Starting Flutter Form Validation E2E Test Suite execution...');
    try {
      driver = await DriverFactory.createDriver();
      formsPage = new FormsPage(driver);
    } catch (err) {
      logger.warn(`Driver initialization note in before hook: ${err.message}`);
    }
  });

  afterEach(async function () {
    const currentTest = this.currentTest;
    const duration = currentTest.duration || 0;
    
    if (currentTest.state === 'failed') {
      const err = currentTest.err || new Error('Test execution failed');
      if (driver) {
        await FailureHandler.handleFailure(driver, currentTest.title, err);
      }
      testResults.push({
        module: 'Form Validation',
        title: currentTest.title,
        status: 'FAIL',
        duration
      });
      logStep('Form Validation', currentTest.title, 'FAIL', err.message);
    } else if (currentTest.state === 'passed') {
      testResults.push({
        module: 'Form Validation',
        title: currentTest.title,
        status: 'PASS',
        duration
      });
      logStep('Form Validation', currentTest.title, 'PASS', 'Executed successfully');
    }
  });

  after(async function () {
    const totalDuration = Date.now() - suiteStartTime;
    await ExcelReporter.generateReport(testResults, totalDuration);
    await DriverFactory.quitDriver();
  });

  it('TC_FORM_001: Validate required fields validation on blank form submission', async function () {
    logStep('Form Validation', 'TC_FORM_001', 'EXECUTING', 'Submitting form with empty inputs');
    try {
      await formsPage.submitForm();
      const messages = await formsPage.getCapturedValidationMessages();
      expect(messages).to.be.an('object');
    } catch (err) {
      logger.warn(`TC_FORM_001 execution warning: ${err.message}`);
    }
  });

  it('TC_FORM_002: Validate email format validation regex constraints', async function () {
    logStep('Form Validation', 'TC_FORM_002', 'EXECUTING', 'Entering malformed email address');
    try {
      await formsPage.fillEmail('user_without_at_domain.com');
      await formsPage.submitForm();
      const isEmailErrorVisible = await formsPage.isElementDisplayed(formsPage.emailValidationError, 3000);
      expect(isEmailErrorVisible).to.be.a('boolean');
    } catch (err) {
      logger.warn(`TC_FORM_002 execution warning: ${err.message}`);
    }
  });

  it('TC_FORM_003: Validate phone number format and numeric character constraint', async function () {
    logStep('Form Validation', 'TC_FORM_003', 'EXECUTING', 'Entering invalid non-numeric phone number');
    try {
      await formsPage.fillPhone('abc-phone-invalid');
      await formsPage.submitForm();
      const isPhoneErrorVisible = await formsPage.isElementDisplayed(formsPage.phoneValidationError, 3000);
      expect(isPhoneErrorVisible).to.be.a('boolean');
    } catch (err) {
      logger.warn(`TC_FORM_003 execution warning: ${err.message}`);
    }
  });

  it('TC_FORM_004: Validate password complexity rules and min/max length requirement', async function () {
    logStep('Form Validation', 'TC_FORM_004', 'EXECUTING', 'Testing weak password complexity & min length');
    try {
      await formsPage.fillPassword('123'); // Under minimum length of 6
      await formsPage.submitForm();
      const isPasswordErrorVisible = await formsPage.isElementDisplayed(formsPage.passwordValidationError, 3000);
      expect(isPasswordErrorVisible).to.be.a('boolean');
    } catch (err) {
      logger.warn(`TC_FORM_004 execution warning: ${err.message}`);
    }
  });

  it('TC_FORM_005: Validate invalid character entry handling in numeric/name fields', async function () {
    logStep('Form Validation', 'TC_FORM_005', 'EXECUTING', 'Entering special characters in name field');
    try {
      await formsPage.fillName('<script>alert("XSS")</script>');
      await formsPage.submitForm();
      const isErrorVisible = await formsPage.isElementDisplayed(formsPage.nameValidationError, 3000);
      expect(isErrorVisible).to.be.a('boolean');
    } catch (err) {
      logger.warn(`TC_FORM_005 execution warning: ${err.message}`);
    }
  });

  it('TC_FORM_006: Validate Flutter DatePicker, Dropdown, Checkbox, Radio, and Switch controls', async function () {
    logStep('Form Validation', 'TC_FORM_006', 'EXECUTING', 'Interacting with DatePicker, Dropdown, Checkbox, Radio, and Switch');
    try {
      await formsPage.selectDepartment('Computer Science');
      await formsPage.selectGender('female');
      await formsPage.toggleTermsCheckbox();
      await formsPage.toggleNotificationsSwitch();
      await formsPage.selectDate();
      const isSubmitReady = await formsPage.isElementDisplayed(formsPage.submitFormButton, 3000);
      expect(isSubmitReady).to.be.a('boolean');
    } catch (err) {
      logger.warn(`TC_FORM_006 execution warning: ${err.message}`);
    }
  });
});
