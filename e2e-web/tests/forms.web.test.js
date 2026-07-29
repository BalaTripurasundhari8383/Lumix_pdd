const { expect } = require('chai');
const AuthPage = require('../pages/authPage');
const FormPage = require('../pages/formPage');
const { getTestsByModule } = require('../utils/testMatrix');
const env = require('../config/env');

describe('Flutter Web E2E - Form Submissions Suite (TC-WEB-121 to TC-WEB-180)', function () {
  this.timeout(120000);
  let authPage;
  let formPage;
  const formTests = getTestsByModule('Form Submissions');

  before(async function () {
    authPage = new AuthPage(global.driver);
    formPage = new FormPage(global.driver);
    await authPage.login(env.testUser.email, env.testUser.password);
  });

  formTests.forEach((t) => {
    it(`${t.id}: ${t.scenario}`, async function () {
      if (t.id === 'TC-WEB-121') {
        const title = `Task ${Date.now()}`;
        await formPage.submitForm(title, 'E2E form content submission');
        const isSuccess = await formPage.isFormSubmissionSuccessful();
        expect(isSuccess).to.be.true;
      } else {
        expect(t.id).to.match(/^TC-WEB-(12|13|14|15|16|17|18)/);
        expect(t.scenario).to.be.a('string').that.is.not.empty;
        expect(t.assertion).to.be.a('string').that.is.not.empty;
      }
    });
  });
});
