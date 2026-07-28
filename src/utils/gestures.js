class Gestures {
    constructor(driver) {
        this.driver = driver;
    }

    async tap(element) {
        await element.click();
    }

    async longPress(element) {
        await this.driver.action('pointer')
            .move({ duration: 0, origin: element, x: 0, y: 0 })
            .down({ button: 0 })
            .pause(2000)
            .up({ button: 0 })
            .perform();
    }

    async swipe(fromX, fromY, toX, toY) {
        await this.driver.action('pointer')
            .move({ duration: 0, x: fromX, y: fromY })
            .down({ button: 0 })
            .move({ duration: 1000, x: toX, y: toY })
            .up({ button: 0 })
            .perform();
    }

    async scrollDown() {
        const { width, height } = await this.driver.getWindowSize();
        await this.swipe(width / 2, height * 0.8, width / 2, height * 0.2);
    }

    async scrollUp() {
        const { width, height } = await this.driver.getWindowSize();
        await this.swipe(width / 2, height * 0.2, width / 2, height * 0.8);
    }
    async dragAndDrop(source, target) {
        const sourceLoc = await source.getLocation();
        const targetLoc = await target.getLocation();
        await this.driver.action('pointer')
            .move({ duration: 0, x: sourceLoc.x, y: sourceLoc.y })
            .down({ button: 0 })
            .pause(500)
            .move({ duration: 1000, x: targetLoc.x, y: targetLoc.y })
            .up({ button: 0 })
            .perform();
    }

    async pinch(element) {
        // Conceptual pinch: two fingers moving toward each other
        const { x, y, width, height } = await this.driver.getElementRect(element.elementId);
        const centerX = x + width / 2;
        const centerY = y + height / 2;

        await this.driver.performActions([
            {
                type: 'pointer',
                id: 'finger1',
                parameters: { pointerType: 'touch' },
                actions: [
                    { type: 'pointerMove', duration: 0, x: centerX - 50, y: centerY },
                    { type: 'pointerDown', button: 0 },
                    { type: 'pointerMove', duration: 1000, x: centerX - 10, y: centerY },
                    { type: 'pointerUp', button: 0 },
                ],
            },
            {
                type: 'pointer',
                id: 'finger2',
                parameters: { pointerType: 'touch' },
                actions: [
                    { type: 'pointerMove', duration: 0, x: centerX + 50, y: centerY },
                    { type: 'pointerDown', button: 0 },
                    { type: 'pointerMove', duration: 1000, x: centerX + 10, y: centerY },
                    { type: 'pointerUp', button: 0 },
                ],
            },
        ]);
    }
}

module.exports = Gestures;
