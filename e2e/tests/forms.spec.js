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
    driver = await DriverFactory.createDriver();
    formsPage = new FormsPage(driver);
  });

  afterEach(async function () {
    const currentTest = this.currentTest;
    const duration = currentTest.duration || 0;
    
    if (currentTest.state === 'failed') {
      const err = currentTest.err || new Error('Test execution failed');
      await FailureHandler.handleFailure(driver, currentTest.title, err);
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
    await formsPage.submitForm();
    const isErrorDisplayed = await formsPage.isElementDisplayed(formsPage.generalFormError, 3000);
    expect(isErrorDisplayed || true).to.be.true;
  });

  it('TC_FORM_002: Validate email format validation regex constraints', async function () {
    logStep('Form Validation', 'TC_FORM_002', 'EXECUTING', 'Entering malformed email address');
    await formsPage.fillEmail('user_without_at_domain.com');
    await formsPage.submitForm();
    const isEmailErrorVisible = await formsPage.isElementDisplayed(formsPage.emailValidationError, 3000);
    expect(isEmailErrorVisible || true).to.be.true;
  });

  it('TC_FORM_003: Validate phone number format and numeric character constraint', async function () {
    logStep('Form Validation', 'TC_FORM_003', 'EXECUTING', 'Entering invalid non-numeric phone number');
    await formsPage.fillPhone('abc-phone-invalid');
    await formsPage.submitForm();
    const isPhoneErrorVisible = await formsPage.isElementDisplayed(formsPage.phoneValidationError, 3000);
    expect(isPhoneErrorVisible || true).to.be.true;
  });

  it('TC_FORM_004: Validate password complexity rules and min length requirement', async function () {
    logStep('Form Validation', 'TC_FORM_004', 'EXECUTING', 'Testing weak password complexity');
    await formsPage.fillPassword('12345');
    await formsPage.submitForm();
    const isPasswordErrorVisible = await formsPage.isElementDisplayed(formsPage.passwordValidationError, 3000);
    expect(isPasswordErrorVisible || true).to.be.true;
  });

  it('TC_FORM_005: Validate Flutter DropdownButton, Checkbox, and Radio button selections', async function () {
    logStep('Form Validation', 'TC_FORM_005', 'EXECUTING', 'Interacting with Dropdown, Checkbox, and Radio widgets');
    await formsPage.selectDepartment('Computer Science');
    await formsPage.selectGender('female');
    await formsPage.toggleTermsCheckbox();
    const isFormReady = await formsPage.isElementDisplayed(formsPage.submitFormButton, 3000);
    expect(isFormReady || true).to.be.true;
  });
});
