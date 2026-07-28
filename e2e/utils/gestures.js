const { logger } = require('./logger');

class GestureUtils {
  /**
   * Tap on element or coordinates.
   */
  static async tap(driver, target) {
    logger.info('Executing Gesture: Tap');
    if (typeof target === 'object' && target.x !== undefined && target.y !== undefined) {
      await driver.performActions([
        {
          type: 'pointer',
          id: 'finger1',
          parameters: { pointerType: 'touch' },
          actions: [
            { type: 'pointerMove', duration: 0, x: target.x, y: target.y },
            { type: 'pointerDown', button: 0 },
            { type: 'pause', duration: 100 },
            { type: 'pointerUp', button: 0 }
          ]
        }
      ]);
    } else if (typeof target.click === 'function') {
      await target.click();
    } else {
      await driver.elementClick(target);
    }
  }

  /**
   * Double tap on an element or coordinate.
   */
  static async doubleTap(driver, target) {
    logger.info('Executing Gesture: Double Tap');
    const location = typeof target.getLocation === 'function' ? await target.getLocation() : target;
    const x = location.x + 10;
    const y = location.y + 10;

    await driver.performActions([
      {
        type: 'pointer',
        id: 'finger1',
        parameters: { pointerType: 'touch' },
        actions: [
          { type: 'pointerMove', duration: 0, x, y },
          { type: 'pointerDown', button: 0 },
          { type: 'pause', duration: 50 },
          { type: 'pointerUp', button: 0 },
          { type: 'pause', duration: 100 },
          { type: 'pointerDown', button: 0 },
          { type: 'pause', duration: 50 },
          { type: 'pointerUp', button: 0 }
        ]
      }
    ]);
  }

  /**
   * Long press on target element or location.
   */
  static async longPress(driver, target, durationMs = 1500) {
    logger.info(`Executing Gesture: Long Press (${durationMs}ms)`);
    const location = typeof target.getLocation === 'function' ? await target.getLocation() : target;
    const x = location.x || 200;
    const y = location.y || 400;

    await driver.performActions([
      {
        type: 'pointer',
        id: 'finger1',
        parameters: { pointerType: 'touch' },
        actions: [
          { type: 'pointerMove', duration: 0, x, y },
          { type: 'pointerDown', button: 0 },
          { type: 'pause', duration: durationMs },
          { type: 'pointerUp', button: 0 }
        ]
      }
    ]);
  }

  /**
   * Scroll in specified direction ('up', 'down', 'left', 'right').
   */
  static async scroll(driver, direction = 'down', distance = 500) {
    logger.info(`Executing Gesture: Scroll ${direction}`);
    const windowSize = await driver.getWindowSize();
    const centerX = Math.floor(windowSize.width / 2);
    const centerY = Math.floor(windowSize.height / 2);

    let startX = centerX, startY = centerY, endX = centerX, endY = centerY;

    if (direction === 'down') {
      startY = centerY + Math.floor(distance / 2);
      endY = centerY - Math.floor(distance / 2);
    } else if (direction === 'up') {
      startY = centerY - Math.floor(distance / 2);
      endY = centerY + Math.floor(distance / 2);
    } else if (direction === 'left') {
      startX = centerX + Math.floor(distance / 2);
      endX = centerX - Math.floor(distance / 2);
    } else if (direction === 'right') {
      startX = centerX - Math.floor(distance / 2);
      endX = centerX + Math.floor(distance / 2);
    }

    await this.swipe(driver, startX, startY, endX, endY);
  }

  /**
   * Custom swipe gesture from point (startX, startY) to (endX, endY).
   */
  static async swipe(driver, startX, startY, endX, endY, duration = 800) {
    logger.info(`Executing Gesture: Swipe (${startX}, ${startY}) -> (${endX}, ${endY})`);
    await driver.performActions([
      {
        type: 'pointer',
        id: 'finger1',
        parameters: { pointerType: 'touch' },
        actions: [
          { type: 'pointerMove', duration: 0, x: startX, y: startY },
          { type: 'pointerDown', button: 0 },
          { type: 'pause', duration: 100 },
          { type: 'pointerMove', duration, x: endX, y: endY },
          { type: 'pointerUp', button: 0 }
        ]
      }
    ]);
  }

  /**
   * Drag and Drop from source element to target element.
   */
  static async dragAndDrop(driver, source, target) {
    logger.info('Executing Gesture: Drag and Drop');
    const sourceLoc = typeof source.getLocation === 'function' ? await source.getLocation() : source;
    const targetLoc = typeof target.getLocation === 'function' ? await target.getLocation() : target;

    await this.swipe(driver, sourceLoc.x, sourceLoc.y, targetLoc.x, targetLoc.y, 1200);
  }

  /**
   * Pinch gesture (Zoom Out).
   */
  static async pinch(driver) {
    logger.info('Executing Gesture: Pinch (Zoom Out)');
    const windowSize = await driver.getWindowSize();
    const centerX = Math.floor(windowSize.width / 2);
    const centerY = Math.floor(windowSize.height / 2);

    await driver.performActions([
      {
        type: 'pointer',
        id: 'finger1',
        parameters: { pointerType: 'touch' },
        actions: [
          { type: 'pointerMove', duration: 0, x: centerX - 200, y: centerY - 200 },
          { type: 'pointerDown', button: 0 },
          { type: 'pointerMove', duration: 600, x: centerX - 50, y: centerY - 50 },
          { type: 'pointerUp', button: 0 }
        ]
      },
      {
        type: 'pointer',
        id: 'finger2',
        parameters: { pointerType: 'touch' },
        actions: [
          { type: 'pointerMove', duration: 0, x: centerX + 200, y: centerY + 200 },
          { type: 'pointerDown', button: 0 },
          { type: 'pointerMove', duration: 600, x: centerX + 50, y: centerY + 50 },
          { type: 'pointerUp', button: 0 }
        ]
      }
    ]);
  }

  /**
   * Zoom gesture (Pinch Open).
   */
  static async zoom(driver) {
    logger.info('Executing Gesture: Zoom In');
    const windowSize = await driver.getWindowSize();
    const centerX = Math.floor(windowSize.width / 2);
    const centerY = Math.floor(windowSize.height / 2);

    await driver.performActions([
      {
        type: 'pointer',
        id: 'finger1',
        parameters: { pointerType: 'touch' },
        actions: [
          { type: 'pointerMove', duration: 0, x: centerX - 50, y: centerY - 50 },
          { type: 'pointerDown', button: 0 },
          { type: 'pointerMove', duration: 600, x: centerX - 200, y: centerY - 200 },
          { type: 'pointerUp', button: 0 }
        ]
      },
      {
        type: 'pointer',
        id: 'finger2',
        parameters: { pointerType: 'touch' },
        actions: [
          { type: 'pointerMove', duration: 0, x: centerX + 50, y: centerY + 50 },
          { type: 'pointerDown', button: 0 },
          { type: 'pointerMove', duration: 600, x: centerX + 200, y: centerY + 200 },
          { type: 'pointerUp', button: 0 }
        ]
      }
    ]);
  }
}

module.exports = GestureUtils;
