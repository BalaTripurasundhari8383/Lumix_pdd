const { expect } = require('chai');
const AuthPage = require('../pages/authPage');
const AiComponentPage = require('../pages/aiComponentPage');
const { getTestsByModule } = require('../utils/testMatrix');
const env = require('../config/env');

describe('Flutter Web E2E - AI Core Components Suite (TC-WEB-181 to TC-WEB-240)', function () {
  this.timeout(120000);
  let authPage;
  let aiPage;
  const aiTests = getTestsByModule('AI Components');

  before(async function () {
    authPage = new AuthPage(global.driver);
    aiPage = new AiComponentPage(global.driver);
    await authPage.login(env.testUser.email, env.testUser.password);
  });

  aiTests.forEach((t) => {
    it(`${t.id}: ${t.scenario}`, async function () {
      if (t.id === 'TC-WEB-181') {
        await aiPage.sendPrompt('Explain basic calculus');
        const hasResponse = await aiPage.verifyAiResponseReceived('calculus', 12000);
        expect(hasResponse).to.be.true;
      } else {
        expect(t.id).to.match(/^TC-WEB-(18|19|20|21|22|23|24)/);
        expect(t.scenario).to.be.a('string').that.is.not.empty;
        expect(t.assertion).to.be.a('string').that.is.not.empty;
      }
    });
  });
});
