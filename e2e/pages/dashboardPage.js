const BasePage = require('./basePage');
const { logger } = require('../utils/logger');

class DashboardPage extends BasePage {
  constructor(driver) {
    super(driver);

    // Dashboard Headers & Cards
    this.dashboardTitle = this.byValueKey('dashboard_title');
    this.welcomeHeader = this.byValueKey('dashboard_welcome_header');
    this.studentProfileCard = this.byValueKey('student_profile_card');

    // Navigation Tiles & Widgets
    this.coursesTile = this.byValueKey('courses_nav_tile');
    this.assignmentsTile = this.byValueKey('assignments_nav_tile');
    this.aiAssistantTile = this.byValueKey('ai_assistant_nav_tile');

    // Bottom Navigation Bar
    this.bottomNavHome = this.byValueKey('bottom_nav_home');
    this.bottomNavCourses = this.byValueKey('bottom_nav_courses');
    this.bottomNavProfile = this.byValueKey('bottom_nav_profile');

    // Navigation Drawer
    this.drawerIcon = this.byValueKey('open_drawer_icon');
    this.drawerLogoutBtn = this.byValueKey('logout_menu_item');
  }

  async isDashboardLoaded() {
    return (await this.isElementDisplayed(this.dashboardTitle)) || (await this.isElementDisplayed(this.welcomeHeader));
  }

  async navigateToCourses() {
    logger.info('Navigating to Courses section via Bottom Navigation...');
    await this.clickElement(this.bottomNavCourses);
  }

  async navigateToProfile() {
    logger.info('Navigating to Profile section via Bottom Navigation...');
    await this.clickElement(this.bottomNavProfile);
  }

  async navigateToHome() {
    logger.info('Navigating to Home section via Bottom Navigation...');
    await this.clickElement(this.bottomNavHome);
  }

  async openDrawer() {
    logger.info('Opening Navigation Drawer...');
    await this.clickElement(this.drawerIcon);
  }
}

module.exports = DashboardPage;
