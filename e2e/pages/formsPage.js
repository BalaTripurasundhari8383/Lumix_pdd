const BasePage = require('./basePage');
const { logger } = require('../utils/logger');

class FormsPage extends BasePage {
  constructor(driver) {
    super(driver);

    // Form Field Locators
    this.emailField = this.byValueKey('form_email_input');
    this.phoneField = this.byValueKey('form_phone_input');
    this.passwordField = this.byValueKey('form_password_input');
    this.nameField = this.byValueKey('form_name_input');
    this.datePickerTrigger = this.byValueKey('form_date_picker');
    this.departmentDropdown = this.byValueKey('form_department_dropdown');
    this.termsCheckbox = this.byValueKey('form_terms_checkbox');
    this.genderRadioMale = this.byValueKey('form_gender_male');
    this.genderRadioFemale = this.byValueKey('form_gender_female');
    this.notificationsSwitch = this.byValueKey('form_notifications_switch');
    this.submitFormButton = this.byValueKey('form_submit_btn');
    
    // Validation Error Message Locators
    this.emailValidationError = this.byValueKey('email_val_error');
    this.phoneValidationError = this.byValueKey('phone_val_error');
    this.passwordValidationError = this.byValueKey('password_val_error');
    this.generalFormError = this.byValueKey('form_general_error');
  }

  async fillEmail(email) {
    await this.typeInput(this.emailField, email);
  }

  async fillPhone(phone) {
    await this.typeInput(this.phoneField, phone);
  }

  async fillPassword(password) {
    await this.typeInput(this.passwordField, password);
  }

  async fillName(name) {
    await this.typeInput(this.nameField, name);
  }

  async selectDepartment(deptName) {
    logger.info(`Selecting department: ${deptName}`);
    await this.clickElement(this.departmentDropdown);
    const option = this.byText(deptName);
    await this.clickElement(option);
  }

  async toggleTermsCheckbox() {
    logger.info('Toggling terms checkbox...');
    await this.clickElement(this.termsCheckbox);
  }

  async selectGender(gender = 'male') {
    logger.info(`Selecting gender: ${gender}`);
    if (gender.toLowerCase() === 'female') {
      await this.clickElement(this.genderRadioFemale);
    } else {
      await this.clickElement(this.genderRadioMale);
    }
  }

  async submitForm() {
    logger.info('Submitting form...');
    await this.clickElement(this.submitFormButton);
  }

  async getEmailErrorText() {
    return await this.getElementText(this.emailValidationError);
  }

  async getPhoneErrorText() {
    return await this.getElementText(this.phoneValidationError);
  }

  async getPasswordErrorText() {
    return await this.getElementText(this.passwordValidationError);
  }
}

module.exports = FormsPage;
