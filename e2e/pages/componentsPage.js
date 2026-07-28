const BasePage = require('./basePage');
const { logger } = require('../utils/logger');

class ComponentsPage extends BasePage {
  constructor(driver) {
    super(driver);

    // Buttons
    this.elevatedBtn = this.byValueKey('elevated_button_sample');
    this.textBtn = this.byValueKey('text_button_sample');
    this.iconBtn = this.byValueKey('icon_button_sample');

    // Dialog & Overlays
    this.showDialogBtn = this.byValueKey('show_dialog_trigger');
    this.dialogTitle = this.byValueKey('dialog_title_text');
    this.dialogConfirmBtn = this.byValueKey('dialog_confirm_btn');
    
    this.showBottomSheetBtn = this.byValueKey('show_bottom_sheet_trigger');
    this.bottomSheetContent = this.byValueKey('bottom_sheet_container');
    
    this.showSnackbarBtn = this.byValueKey('show_snackbar_trigger');
    this.snackbarText = this.byValueKey('snackbar_message');

    // Containers & Navigation Elements
    this.sampleCard = this.byValueKey('sample_card_container');
    this.listView = this.byValueKey('sample_list_view');
    this.gridView = this.byValueKey('sample_grid_view');
    this.tabBar = this.byValueKey('sample_tab_bar');
    this.tabOne = this.byText('Tab 1');
    this.tabTwo = this.byText('Tab 2');
    this.navDrawerTrigger = this.byValueKey('open_drawer_icon');
    this.drawerHeader = this.byValueKey('drawer_user_profile_header');
  }

  async clickElevatedButton() {
    await this.clickElement(this.elevatedBtn);
  }

  async clickIconButton() {
    await this.clickElement(this.iconBtn);
  }

  async triggerAlertDialog() {
    logger.info('Triggering AlertDialog...');
    await this.clickElement(this.showDialogBtn);
  }

  async confirmAlertDialog() {
    await this.clickElement(this.dialogConfirmBtn);
  }

  async triggerBottomSheet() {
    logger.info('Triggering Modal BottomSheet...');
    await this.clickElement(this.showBottomSheetBtn);
  }

  async triggerSnackbar() {
    logger.info('Triggering Snackbar notification...');
    await this.clickElement(this.showSnackbarBtn);
  }

  async getSnackbarMessage() {
    return await this.getElementText(this.snackbarText);
  }

  async openNavigationDrawer() {
    logger.info('Opening Navigation Drawer...');
    await this.clickElement(this.navDrawerTrigger);
  }

  async switchTab(tabName) {
    logger.info(`Switching to tab: ${tabName}`);
    const tabLoc = this.byText(tabName);
    await this.clickElement(tabLoc);
  }
}

module.exports = ComponentsPage;
