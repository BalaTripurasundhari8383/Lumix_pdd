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
}

module.exports = Gestures;
