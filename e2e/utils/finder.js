const { byValueKey, byText, bySemanticsLabel, byType, byTooltip, pageBack } = require('appium-flutter-finder');
const DriverFactory = require('./driverFactory');

/**
 * Flutter Finder & Element Locator Strategy Utility.
 * Supports Flutter Driver finders with automatic fallback to UiAutomator2 selectors.
 */
class FlutterFinder {
  /**
   * Locate widget by ValueKey (find.byValueKey)
   * @param {string} key 
   */
  static byValueKey(key) {
    if (DriverFactory.getAutomationName() === 'Flutter') {
      return byValueKey(key);
    }
    return `//*[@content-desc="${key}" or @resource-id="${key}" or @text="${key}" or contains(@content-desc, "${key}") or contains(@resource-id, "${key}")]`;
  }

  /**
   * Locate widget by Text (find.byText)
   * @param {string} text 
   */
  static byText(text) {
    if (DriverFactory.getAutomationName() === 'Flutter') {
      return byText(text);
    }
    return `//*[@text="${text}" or @content-desc="${text}"]`;
  }

  /**
   * Locate widget by Semantics Label (find.bySemanticsLabel)
   * @param {string} label 
   */
  static bySemanticsLabel(label) {
    if (DriverFactory.getAutomationName() === 'Flutter') {
      return bySemanticsLabel(label);
    }
    return `~${label}`;
  }

  /**
   * Locate widget by Accessibility ID
   * @param {string} id 
   */
  static byAccessibilityId(id) {
    if (DriverFactory.getAutomationName() === 'Flutter') {
      return byValueKey(id);
    }
    return `~${id}`;
  }

  /**
   * Locate widget by Type (find.byType)
   * @param {string} type 
   */
  static byType(type) {
    if (DriverFactory.getAutomationName() === 'Flutter') {
      return byType(type);
    }
    return `//${type}`;
  }

  /**
   * Locate widget by Tooltip message
   * @param {string} message 
   */
  static byTooltip(message) {
    if (DriverFactory.getAutomationName() === 'Flutter') {
      return byTooltip(message);
    }
    return `//*[@content-desc="${message}" or @text="${message}"]`;
  }
}

// Export both Class and 'find' alias for standard Flutter Finder API usage: find.byValueKey()
module.exports = {
  FlutterFinder,
  find: FlutterFinder
};
