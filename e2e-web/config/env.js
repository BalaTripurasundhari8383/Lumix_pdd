const path = require('path');
const dotenv = require('dotenv');

// Load environment variables from .env file
const envPath = path.resolve(__dirname, '../.env');
dotenv.config({ path: envPath });

module.exports = {
  baseUrl: process.env.BASE_URL || 'http://localhost:8080',
  browser: process.env.BROWSER || 'chrome',
  headless: process.env.HEADLESS === 'true',
  implicitWaitMs: parseInt(process.env.IMPLICIT_WAIT_MS || '5000', 10),
  explicitWaitMs: parseInt(process.env.EXPLICIT_WAIT_MS || '15000', 10),
  reportsDir: path.resolve(__dirname, '../', process.env.REPORTS_DIR || './reports'),
  screenshotsDir: path.resolve(__dirname, '../', process.env.SCREENSHOTS_DIR || './reports/screenshots'),
  
  testUser: {
    email: process.env.TEST_USER_EMAIL || 'e2e_student@lumix.app',
    password: process.env.TEST_USER_PASSWORD || 'TestPassword123!'
  },
  testTeacher: {
    email: process.env.TEST_TEACHER_EMAIL || 'e2e_teacher@lumix.app',
    password: process.env.TEST_TEACHER_PASSWORD || 'TestPassword123!'
  },
  testParent: {
    email: process.env.TEST_PARENT_EMAIL || 'e2e_parent@lumix.app',
    password: process.env.TEST_PARENT_PASSWORD || 'TestPassword123!'
  }
};
