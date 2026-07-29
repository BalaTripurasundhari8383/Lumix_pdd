const { By } = require('selenium-webdriver');
const BasePage = require('./basePage');
const FlutterWebHelper = require('../utils/flutterWebHelper');
const { recordLog } = require('../utils/logger');

class FormPage extends BasePage {
  constructor(driver) {
    super(driver);
    this.titleInput = 'input[placeholder*="Title"], [aria-label*="Title"]';
    this.descriptionInput = 'textarea, [placeholder*="Description"], [aria-label*="Description"]';
    this.submitButton = 'button:has-text("Submit"), [aria-label="Submit"]';
  }

  /**
   * Fills out a generic data entry form
   */
  async submitForm(title, description) {
    recordLog('Form', `Filling form with Title: "${title}"`, 'STARTED');
    await this.type(this.titleInput, title);
    await this.type(this.descriptionInput, description);
    
    await FlutterWebHelper.clickElement(this.driver, By.xpath("//*[contains(text(), 'Submit') or contains(text(), 'Save')]"));
    await this.driver.sleep(1000);
    recordLog('Form', `Submitted form successfully`, 'SUCCESS');
  }

  /**
   * Verifies form submission confirmation message
   */
  async isFormSubmissionSuccessful() {
    return await this.verifyTextPresent('Successfully', 5000) || await this.verifyTextPresent('Saved', 5000);
  }
}

module.exports = FormPage;
