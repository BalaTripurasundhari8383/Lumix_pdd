const { By, until, WebElement } = require('selenium-webdriver');
const { logger } = require('./logger');
const env = require('../config/env');

class FlutterWebHelper {
  /**
   * Enables Flutter Web Semantics tree for accessibility/automation element discovery
   */
  static async enableFlutterSemantics(driver) {
    try {
      logger.info('Activating Flutter Web Semantics tree...');
      await driver.executeScript(() => {
        // Attempt to find and click flt-semantics-placeholder if present
        const placeholder = document.querySelector('flt-semantics-placeholder');
        if (placeholder) {
          placeholder.click();
          return true;
        }
        // Fallback: programmatically toggle semantics on flt-glass-pane
        const glassPane = document.querySelector('flt-glass-pane') || document.querySelector('flutter-view');
        if (glassPane && glassPane.shadowRoot) {
          const semHost = glassPane.shadowRoot.querySelector('flt-semantics-host');
          if (semHost) semHost.click();
        }
        return true;
      });
      await driver.sleep(500);
    } catch (err) {
      logger.warn(`Flutter Semantics initialization warning: ${err.message}`);
    }
  }

  /**
   * Explicit Wait for Flutter App Initialization & Canvas Rendering
   */
  static async waitForFlutterReady(driver, timeoutMs = env.explicitWaitMs) {
    logger.info('Waiting for Flutter Web engine initialization...');
    await driver.wait(async () => {
      return await driver.executeScript(() => {
        const glassPane = document.querySelector('flt-glass-pane') || document.querySelector('flutter-view');
        const isLoaded = document.readyState === 'complete';
        return isLoaded && (glassPane !== null || document.body.children.length > 0);
      });
    }, timeoutMs, 'Flutter Web engine failed to initialize within timeout');
    
    await this.enableFlutterSemantics(driver);
  }

  /**
   * Explicit Wait for Element Presence and Visibility
   */
  static async waitForElement(driver, locator, timeoutMs = env.explicitWaitMs) {
    const el = await driver.wait(until.elementLocated(locator), timeoutMs, `Element located by ${locator} not found within ${timeoutMs}ms`);
    await driver.wait(until.elementIsVisible(el), timeoutMs, `Element located by ${locator} not visible within ${timeoutMs}ms`);
    return el;
  }

  /**
   * Explicit Wait for Element Clickability
   */
  static async waitForClickable(driver, locator, timeoutMs = env.explicitWaitMs) {
    const el = await this.waitForElement(driver, locator, timeoutMs);
    await driver.wait(until.elementIsEnabled(el), timeoutMs, `Element located by ${locator} not enabled within ${timeoutMs}ms`);
    return el;
  }

  /**
   * Locates an element inside Flutter Web Shadow DOM host (`flt-glass-pane` or `<flutter-view>`)
   */
  static async findElementInShadowDom(driver, selector) {
    const element = await driver.executeScript((sel) => {
      const host = document.querySelector('flt-glass-pane') || document.querySelector('flutter-view') || document.body;
      if (host && host.shadowRoot) {
        return host.shadowRoot.querySelector(sel);
      }
      return document.querySelector(sel);
    }, selector);

    return element;
  }

  /**
   * Safely inputs text into Flutter input / textarea element (handles both standard DOM & Shadow DOM inputs)
   */
  static async fillInput(driver, locatorOrSelector, text) {
    let inputEl;
    if (typeof locatorOrSelector === 'string') {
      inputEl = await driver.wait(async () => {
        const el = await this.findElementInShadowDom(driver, locatorOrSelector);
        if (!el) {
          // Try standard DOM element lookup
          try {
            return await driver.findElement(By.css(locatorOrSelector));
          } catch (e) {
            return null;
          }
        }
        return el;
      }, env.explicitWaitMs, `Input element ${locatorOrSelector} not found`);
    } else {
      inputEl = await this.waitForElement(driver, locatorOrSelector);
    }

    try {
      await inputEl.clear();
    } catch (e) {
      // If clear fails on canvas wrapper, send Backspace keys
      await inputEl.sendKeys('\u0008'.repeat(30));
    }
    
    await inputEl.sendKeys(text);
  }

  /**
   * Robust click action supporting normal click, Shadow DOM click, and JS fallback click
   */
  static async clickElement(driver, locatorOrSelector) {
    try {
      if (typeof locatorOrSelector === 'string') {
        await driver.executeScript((sel) => {
          const host = document.querySelector('flt-glass-pane') || document.querySelector('flutter-view') || document.body;
          let el = null;
          if (host && host.shadowRoot) {
            el = host.shadowRoot.querySelector(sel);
          }
          if (!el) el = document.querySelector(sel);
          if (el) {
            el.click();
            return true;
          }
          throw new Error(`Element ${sel} not found in DOM or Shadow DOM`);
        }, locatorOrSelector);
      } else {
        const el = await this.waitForClickable(driver, locatorOrSelector);
        await el.click();
      }
    } catch (err) {
      logger.warn(`Standard click failed on ${locatorOrSelector}, trying JavaScript click fallback: ${err.message}`);
      await driver.executeScript((loc) => {
        let target = loc;
        if (typeof loc === 'string') target = document.querySelector(loc);
        if (target) target.click();
      }, locatorOrSelector);
    }
  }

  /**
   * Waits for text content inside an element or whole page
   */
  static async waitForText(driver, expectedText, timeoutMs = env.explicitWaitMs) {
    return await driver.wait(async () => {
      const pageText = await driver.executeScript(() => {
        return document.body.innerText || document.body.textContent || '';
      });
      return pageText.includes(expectedText);
    }, timeoutMs, `Text "${expectedText}" not found on page within ${timeoutMs}ms`);
  }

  /**
   * Waits for element by aria-label or title (Flutter Semantics attribute)
   */
  static async waitForSemanticsLabel(driver, labelText, timeoutMs = env.explicitWaitMs) {
    return await driver.wait(until.elementLocated(By.css(`[aria-label="${labelText}"], [title="${labelText}"]`)), timeoutMs);
  }
}

module.exports = FlutterWebHelper;
