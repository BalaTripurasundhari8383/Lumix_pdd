const ExcelJS = require('exceljs');
const path = require('path');
const fs = require('fs');
const env = require('../config/env');
const { logger, getExecutionLogs } = require('./logger');
const FailureHandler = require('./failureHandler');

class ExcelReporter {
  /**
   * Generates formatted multi-tab Excel report: Flutter_E2E_Report.xlsx
   */
  static async generateReport(testResults = [], executionDurationMs = 0) {
    logger.info('Generating enterprise Excel execution report: Flutter_E2E_Report.xlsx');
    
    const workbook = new ExcelJS.Workbook();
    workbook.creator = 'Appium 2.x Flutter E2E Framework';
    workbook.lastModifiedBy = 'Automated QA Runner';
    workbook.created = new Date();

    const totalTests = testResults.length;
    const passed = testResults.filter(t => t.status === 'PASS' || t.status === 'passed').length;
    const failed = testResults.filter(t => t.status === 'FAIL' || t.status === 'failed').length;
    const skipped = testResults.filter(t => t.status === 'SKIP' || t.status === 'pending' || t.status === 'skipped').length;
    const passRate = totalTests > 0 ? ((passed / totalTests) * 100).toFixed(2) + '%' : '0%';
    const durationSec = (executionDurationMs / 1000).toFixed(2) + 's';

    // ----------------------------------------------------
    // Sheet 1 - Summary
    // ----------------------------------------------------
    const sheetSummary = workbook.addWorksheet('Summary', { properties: { tabColor: { argb: 'FF1F4E79' } } });
    
    sheetSummary.columns = [
      { header: 'Metric', key: 'metric', width: 30 },
      { header: 'Value', key: 'value', width: 45 }
    ];

    sheetSummary.addRows([
      { metric: 'Execution Date', value: new Date().toLocaleString() },
      { metric: 'Device Name', value: env.deviceName },
      { metric: 'Platform / Version', value: `${env.platformName} ${env.platformVersion}` },
      { metric: 'Automation Engine', value: env.automationName },
      { metric: 'Target Application Package', value: env.appPackage },
      { metric: 'Total Executed Tests', value: totalTests },
      { metric: 'Passed Tests', value: passed },
      { metric: 'Failed Tests', value: failed },
      { metric: 'Skipped Tests', value: skipped },
      { metric: 'Pass Percentage', value: passRate },
      { metric: 'Execution Duration', value: durationSec }
    ]);

    // Style Summary Sheet Header
    sheetSummary.getRow(1).eachCell((cell) => {
      cell.font = { bold: true, color: { argb: 'FFFFFF' }, size: 12 };
      cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF1F4E79' } };
      cell.alignment = { vertical: 'middle', horizontal: 'center' };
    });

    // ----------------------------------------------------
    // Sheet 2 - Test Cases
    // ----------------------------------------------------
    const sheetTestCases = workbook.addWorksheet('Test Cases', { properties: { tabColor: { argb: 'FF276A3C' } } });
    sheetTestCases.columns = [
      { header: 'Test ID', key: 'id', width: 15 },
      { header: 'Module', key: 'module', width: 25 },
      { header: 'Scenario', key: 'scenario', width: 45 },
      { header: 'Status', key: 'status', width: 15 },
      { header: 'Device', key: 'device', width: 25 },
      { header: 'Duration (ms)', key: 'duration', width: 18 }
    ];

    testResults.forEach((t, index) => {
      const row = sheetTestCases.addRow({
        id: `TC-${String(index + 1).padStart(3, '0')}`,
        module: t.module || 'E2E Suite',
        scenario: t.title || t.scenario || 'Test Scenario',
        status: (t.status || 'PASS').toUpperCase(),
        device: env.deviceName,
        duration: t.duration || 0
      });

      const statusCell = row.getCell('status');
      if (statusCell.value === 'PASS' || statusCell.value === 'PASSED') {
        statusCell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFC6EFCE' } };
        statusCell.font = { color: { argb: 'FF006100' }, bold: true };
      } else if (statusCell.value === 'FAIL' || statusCell.value === 'FAILED') {
        statusCell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFFFC7CE' } };
        statusCell.font = { color: { argb: 'FF9C0006' }, bold: true };
      }
    });

    sheetTestCases.getRow(1).eachCell((cell) => {
      cell.font = { bold: true, color: { argb: 'FFFFFF' }, size: 12 };
      cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF276A3C' } };
      cell.alignment = { vertical: 'middle', horizontal: 'center' };
    });

    // ----------------------------------------------------
    // Sheet 3 - Failed Tests
    // ----------------------------------------------------
    const sheetFailures = workbook.addWorksheet('Failed Tests', { properties: { tabColor: { argb: 'FFC00000' } } });
    sheetFailures.columns = [
      { header: 'Test Name', key: 'testName', width: 35 },
      { header: 'Failure Reason', key: 'failureReason', width: 50 },
      { header: 'Screenshot Path', key: 'screenshotPath', width: 45 },
      { header: 'Device', key: 'device', width: 25 },
      { header: 'Android Version', key: 'androidVersion', width: 18 }
    ];

    const failures = FailureHandler.getFailedTests();
    failures.forEach((f) => {
      sheetFailures.addRow({
        testName: f.testName,
        failureReason: f.failureReason,
        screenshotPath: f.screenshotPath,
        device: f.deviceName,
        androidVersion: f.platformVersion
      });
    });

    sheetFailures.getRow(1).eachCell((cell) => {
      cell.font = { bold: true, color: { argb: 'FFFFFF' }, size: 12 };
      cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFC00000' } };
      cell.alignment = { vertical: 'middle', horizontal: 'center' };
    });

    // ----------------------------------------------------
    // Sheet 4 - Execution Logs
    // ----------------------------------------------------
    const sheetLogs = workbook.addWorksheet('Execution Logs', { properties: { tabColor: { argb: 'FF7030A0' } } });
    sheetLogs.columns = [
      { header: 'Timestamp', key: 'timestamp', width: 25 },
      { header: 'Test Name', key: 'testName', width: 30 },
      { header: 'Step', key: 'step', width: 45 },
      { header: 'Result', key: 'status', width: 15 },
      { header: 'Remarks', key: 'remarks', width: 40 }
    ];

    const logs = getExecutionLogs();
    logs.forEach((l) => {
      sheetLogs.addRow({
        timestamp: l.timestamp,
        testName: l.testName,
        step: l.step,
        status: l.status,
        remarks: l.remarks
      });
    });

    sheetLogs.getRow(1).eachCell((cell) => {
      cell.font = { bold: true, color: { argb: 'FFFFFF' }, size: 12 };
      cell.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FF7030A0' } };
      cell.alignment = { vertical: 'middle', horizontal: 'center' };
    });

    // Save Workbook
    const reportsDir = env.reportsDir;
    if (!fs.existsSync(reportsDir)) fs.mkdirSync(reportsDir, { recursive: true });
    
    const excelPath = path.join(reportsDir, 'Flutter_E2E_Report.xlsx');
    await workbook.xlsx.writeFile(excelPath);
    logger.info(`Excel report generated successfully at: ${excelPath}`);
    return excelPath;
  }
}

module.exports = ExcelReporter;
