const { By } = require('selenium-webdriver');
const BasePage = require('./basePage');
const FlutterWebHelper = require('../utils/flutterWebHelper');
const { recordLog } = require('../utils/logger');

class DashboardPage extends BasePage {
  constructor(driver) {
    super(driver);
  }

  /**
   * Navigates to specific section via bottom navigation or drawer menu
   */
  async navigateToSection(sectionName) {
    recordLog('Dashboard', `Navigating to section: ${sectionName}`, 'STARTED');
    await FlutterWebHelper.clickElement(this.driver, By.xpath(`//*[contains(text(), '${sectionName}') or @aria-label='${sectionName}']`));
    await this.driver.sleep(800);
    recordLog('Dashboard', `Navigated to section: ${sectionName}`, 'SUCCESS');
  }

  /**
   * Verifies if Student Dashboard elements are rendered
   */
  async isStudentDashboardLoaded() {
    return await this.verifyTextPresent('Courses', 8000) || await this.verifyTextPresent('My Learning', 8000);
  }

  /**
   * Verifies if Teacher Dashboard elements are rendered
   */
  async isTeacherDashboardLoaded() {
    return await this.verifyTextPresent('Students', 8000) || await this.verifyTextPresent('Classroom', 8000);
  }

  /**
   * Verifies if Parent Dashboard elements are rendered
   */
  async isParentDashboardLoaded() {
    return await this.verifyTextPresent('Child Progress', 8000) || await this.verifyTextPresent('Reports', 8000);
  }
}

module.exports = DashboardPage;
