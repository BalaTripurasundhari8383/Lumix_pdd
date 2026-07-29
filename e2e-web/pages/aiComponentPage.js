const { By } = require('selenium-webdriver');
const BasePage = require('./basePage');
const FlutterWebHelper = require('../utils/flutterWebHelper');
const { recordLog } = require('../utils/logger');

class AiComponentPage extends BasePage {
  constructor(driver) {
    super(driver);
    this.promptInput = 'textarea[placeholder*="Ask"], input[placeholder*="Ask"], [aria-label*="Ask AI"]';
    this.sendButton = 'button[aria-label="Send"], [aria-label="Submit Prompt"]';
  }

  /**
   * Submits a query prompt to AI Assistant
   */
  async sendPrompt(promptText) {
    recordLog('AI Component', `Sending AI prompt: "${promptText}"`, 'STARTED');
    await this.type(this.promptInput, promptText);
    await FlutterWebHelper.clickElement(this.driver, By.xpath("//*[contains(@aria-label, 'Send') or contains(text(), 'Ask')]"));
    recordLog('AI Component', `AI prompt sent`, 'SUCCESS');
  }

  /**
   * Verifies AI response generation and presence
   */
  async verifyAiResponseReceived(expectedKeywords, timeoutMs = 20000) {
    recordLog('AI Component', `Waiting for AI response containing "${expectedKeywords}"`, 'STARTED');
    const received = await this.verifyTextPresent(expectedKeywords, timeoutMs);
    recordLog('AI Component', `AI response received verification`, received ? 'PASS' : 'FAIL');
    return received;
  }
}

module.exports = AiComponentPage;
