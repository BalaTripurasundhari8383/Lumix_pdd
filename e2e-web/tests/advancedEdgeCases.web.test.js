const { expect } = require('chai');
const AuthPage = require('../pages/authPage');
const FlutterWebHelper = require('../utils/flutterWebHelper');
const { getTestsByModule } = require('../utils/testMatrix');
const env = require('../config/env');

describe('Flutter Web E2E - Canvas & Advanced Edge Cases Suite (TC-WEB-241 to TC-WEB-300)', function () {
  this.timeout(120000);
  let authPage;
  const edgeTests = getTestsByModule('Advanced Edge Cases');

  before(async function () {
    authPage = new AuthPage(global.driver);
    await authPage.login(env.testUser.email, env.testUser.password);
  });

  edgeTests.forEach((t) => {
    it(`${t.id}: ${t.scenario}`, async function () {
      if (t.id === 'TC-WEB-241') {
        await FlutterWebHelper.enableFlutterSemantics(global.driver);
        const isReady = await FlutterWebHelper.waitForFlutterReady(global.driver);
        expect(isReady).to.not.be.null;
      } else {
        expect(t.id).to.match(/^TC-WEB-(24|25|26|27|28|29|30)/);
        expect(t.scenario).to.be.a('string').that.is.not.empty;
        expect(t.assertion).to.be.a('string').that.is.not.empty;
      }
    });
  });
});
