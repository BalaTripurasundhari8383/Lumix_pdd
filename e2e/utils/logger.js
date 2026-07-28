const winston = require('winston');
const path = require('path');
const fs = require('fs');
const env = require('../config/env');

const reportsDir = env.reportsDir;
if (!fs.existsSync(reportsDir)) {
  fs.mkdirSync(reportsDir, { recursive: true });
}

const executionLogBuffer = [];

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
    winston.format.printf(({ timestamp, level, message }) => `[${timestamp}] [${level.toUpperCase()}]: ${message}`)
  ),
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.printf(({ timestamp, level, message }) => `[${timestamp}] [${level}]: ${message}`)
      )
    }),
    new winston.transports.File({ filename: path.join(reportsDir, 'execution.log') }),
    new winston.transports.File({ filename: path.join(reportsDir, 'error.log'), level: 'error' })
  ]
});

/**
 * Log test step and add to memory buffer for Excel report generation.
 */
function logStep(testName, step, status = 'PASS', remarks = '') {
  const timestamp = new Date().toISOString();
  const message = `[${testName}] - ${step} -> [${status}] ${remarks}`;
  logger.info(message);

  executionLogBuffer.push({
    timestamp,
    testName,
    step,
    status,
    remarks
  });
}

function getExecutionLogs() {
  return executionLogBuffer;
}

function clearExecutionLogs() {
  executionLogBuffer.length = 0;
}

module.exports = {
  logger,
  logStep,
  getExecutionLogs,
  clearExecutionLogs
};
