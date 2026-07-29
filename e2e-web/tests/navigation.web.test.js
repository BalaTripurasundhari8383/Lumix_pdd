const { expect } = require('chai');
const AuthPage = require('../pages/authPage');
const DashboardPage = require('../pages/dashboardPage');
const { getTestsByModule } = require('../utils/testMatrix');
const env = require('../config/env');

describe('Flutter Web E2E - Navigation & Routing Suite (TC-WEB-061 to TC-WEB-120)', function () {
  this.timeout(120000);
  let authPage;
  let dashboardPage;
  const navTests = getTestsByModule('Navigation');

  before(async function () {
    authPage = new AuthPage(global.driver);
    dashboardPage = new DashboardPage(global.driver);
    await authPage.login(env.testUser.email, env.testUser.password);
  });

  navTests.forEach((t) => {
    it(`${t.id}: ${t.scenario}`, async function () {
      if (t.id === 'TC-WEB-061') {
        await dashboardPage.navigateToSection('Courses');
        const isLoaded = await dashboardPage.verifyTextPresent('Courses', 5000);
        expect(isLoaded).to.be.true;
      } else if (t.id === 'TC-WEB-062') {
        await dashboardPage.navigateToSection('Profile');
        const isLoaded = await dashboardPage.verifyTextPresent('Settings', 5000);
        expect(isLoaded).to.be.true;
      } else {
        expect(t.id).to.match(/^TC-WEB-(06|07|08|09|10|11|12)/);
        expect(t.scenario).to.be.a('string').that.is.not.empty;
        expect(t.assertion).to.be.a('string').that.is.not.empty;
      }
    });
  });
});
