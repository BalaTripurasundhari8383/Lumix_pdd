const BasePage = require('./basePage');
const { logger } = require('../utils/logger');

class ComponentsPage extends BasePage {
  constructor(driver) {
    super(driver);

    // Button Locators (ElevatedButton, TextButton, IconButton)
    this.elevatedBtn = this.byValueKey('elevated_button_sample');
    this.textBtn = this.byValueKey('text_button_sample');
    this.iconBtn = this.byValueKey('icon_button_sample');

    // Input & Selector Locators (TextField, DropdownButton, Checkbox, Radio, Switch)
    this.sampleTextField = this.byValueKey('sample_text_field');
    this.sampleDropdown = this.byValueKey('sample_dropdown_button');
    this.sampleCheckbox = this.byValueKey('sample_checkbox');
    this.sampleRadio = this.byValueKey('sample_radio_button');
    this.sampleSwitch = this.byValueKey('sample_switch');

    // Dialog & Overlays (Dialog, BottomSheet, Snackbar)
    this.showDialogBtn = this.byValueKey('show_dialog_trigger');
    this.dialogTitle = this.byValueKey('dialog_title_text');
    this.dialogConfirmBtn = this.byValueKey('dialog_confirm_btn');
    
    this.showBottomSheetBtn = this.byValueKey('show_bottom_sheet_trigger');
    this.bottomSheetContent = this.byValueKey('bottom_sheet_container');
    
    this.showSnackbarBtn = this.byValueKey('show_snackbar_trigger');
    this.snackbarText = this.byValueKey('snackbar_message');

    // Layout Containers & Structure (ListView, GridView, Card, TabBar, Navigation Drawer)
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
    logger.info('Clicking ElevatedButton...');
    await this.clickElement(this.elevatedBtn);
  }

  async clickTextButton() {
    logger.info('Clicking TextButton...');
    await this.clickElement(this.textBtn);
  }

  async clickIconButton() {
    logger.info('Clicking IconButton...');
    await this.clickElement(this.iconBtn);
  }

  async enterSampleTextField(text) {
    logger.info(`Entering text in sample TextField: ${text}`);
    await this.typeInput(this.sampleTextField, text);
  }

  async toggleSampleCheckbox() {
    logger.info('Toggling Checkbox component...');
    await this.clickElement(this.sampleCheckbox);
  }

  async toggleSampleSwitch() {
    logger.info('Toggling Switch component...');
    await this.clickElement(this.sampleSwitch);
  }

  async selectSampleRadio() {
    logger.info('Selecting Radio component...');
    await this.clickElement(this.sampleRadio);
  }

  async triggerAlertDialog() {
    logger.info('Triggering AlertDialog overlay...');
    await this.clickElement(this.showDialogBtn);
  }

  async confirmAlertDialog() {
    logger.info('Confirming AlertDialog...');
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

  async isListViewVisible() {
    return await this.isElementDisplayed(this.listView);
  }

  async isGridViewVisible() {
    return await this.isElementDisplayed(this.gridView);
  }

  async isCardVisible() {
    return await this.isElementDisplayed(this.sampleCard);
  }
}

module.exports = ComponentsPage;
