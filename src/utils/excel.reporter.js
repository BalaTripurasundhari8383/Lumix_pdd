const ExcelJS = require('exceljs');
const path = require('path');
const fs = require('fs-extra');
const logger = require('./logger');

class ExcelReporter {
    constructor() {
        this.workbook = new ExcelJS.Workbook();
        this.reportPath = path.join(__dirname, '../../reports/Flutter_E2E_Report.xlsx');
    }

    async generateSummary(data) {
        const sheet = this.workbook.addWorksheet('Summary');
        sheet.columns = [
            { header: 'Metric', key: 'metric', width: 25 },
            { header: 'Value', key: 'value', width: 25 }
        ];
        sheet.addRows([
            ['Execution Date', new Date().toLocaleString()],
            ['Device Name', data.deviceName],
            ['Android Version', data.androidVersion],
            ['Total Tests', data.total],
            ['Passed', data.passed],
            ['Failed', data.failed],
            ['Skipped', data.skipped],
            ['Pass Percentage', `${((data.passed / data.total) * 100).toFixed(2)}%`],
            ['Duration', data.duration]
        ]);
    }

    async generateTestCases(testCases) {
        const sheet = this.workbook.addWorksheet('Test Cases');
        sheet.columns = [
            { header: 'Test ID', key: 'id', width: 10 },
            { header: 'Module', key: 'module', width: 20 },
            { header: 'Scenario', key: 'scenario', width: 40 },
            { header: 'Status', key: 'status', width: 15 },
            { header: 'Device', key: 'device', width: 20 },
            { header: 'Duration', key: 'duration', width: 15 }
        ];
        sheet.addRows(testCases);
    }

    async generateFailedTests(failedTests) {
        const sheet = this.workbook.addWorksheet('Failed Tests');
        sheet.columns = [
            { header: 'Test Name', key: 'name', width: 30 },
            { header: 'Failure Reason', key: 'reason', width: 50 },
            { header: 'Screenshot Path', key: 'screenshot', width: 50 },
            { header: 'Device', key: 'device', width: 20 },
            { header: 'Android Version', key: 'version', width: 15 }
        ];
        sheet.addRows(failedTests);
    }

    async generateExecutionLogs(logs) {
        const sheet = this.workbook.addWorksheet('Execution Logs');
        sheet.columns = [
            { header: 'Timestamp', key: 'timestamp', width: 25 },
            { header: 'Test Name', key: 'testName', width: 30 },
            { header: 'Step', key: 'step', width: 30 },
            { header: 'Result', key: 'result', width: 15 },
            { header: 'Remarks', key: 'remarks', width: 40 }
        ];
        sheet.addRows(logs);
    }

    async save() {
        await fs.ensureDir(path.dirname(this.reportPath));
        await this.workbook.xlsx.writeFile(this.reportPath);
        logger.info(`Excel report generated at: ${this.reportPath}`);
    }
}

module.exports = new ExcelReporter();
