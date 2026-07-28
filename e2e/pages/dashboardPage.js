const BasePage = require('./basePage');
const { logger } = require('../utils/logger');

class DashboardPage extends BasePage {
  constructor(driver) {
    super(driver);

    this.dashboardTitle = this.byValueKey('dashboard_title');
    this.studentProfileCard = this.byValueKey('student_profile_card');
    this.coursesTile = this.byValueKey('courses_nav_tile');
    this.assignmentsTile = this.byValueKey('assignments_nav_tile');
    this.aiAssistantTile = this.byValueKey('ai_assistant_nav_tile');
    this.bottomNavHome = this.byValueKey('bottom_nav_home');
    this.bottomNavCourses = this.byValueKey('bottom_nav_courses');
    this.bottomNavProfile = this.byValueKey('bottom_nav_profile');
  }

  async isDashboardLoaded() {
    return await this.isElementDisplayed(this.dashboardTitle);
  }

  async navigateToCourses() {
    logger.info('Navigating to Courses section...');
    await this.clickElement(this.bottomNavCourses);
  }

  async navigateToProfile() {
    logger.info('Navigating to Profile section...');
    await this.clickElement(this.bottomNavProfile);
  }
}

module.exports = DashboardPage;
