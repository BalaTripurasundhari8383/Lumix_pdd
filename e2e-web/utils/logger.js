const winston = require('winston');
const path = require('path');
const fs = require('fs');
const env = require('../config/env');

if (!fs.existsSync(env.reportsDir)) {
  fs.mkdirSync(env.reportsDir, { recursive: true });
}

const executionLogs = [];

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
    winston.format.printf(({ timestamp, level, message }) => {
      return `[${timestamp}] [${level.toUpperCase()}]: ${message}`;
    })
  ),
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.printf(({ timestamp, level, message }) => `[${timestamp}] ${level}: ${message}`)
      )
    }),
    new winston.transports.File({ filename: path.join(env.reportsDir, 'e2e-web.log') })
  ]
});

function recordLog(testName, step, status, remarks = '') {
  const logEntry = {
    timestamp: new Date().toISOString(),
    testName,
    step,
    status,
    remarks
  };
  executionLogs.push(logEntry);
  logger.info(`[${testName}] ${step} -> ${status} ${remarks ? '(' + remarks + ')' : ''}`);
}

function getExecutionLogs() {
  return executionLogs;
}

module.exports = {
  logger,
  recordLog,
  getExecutionLogs
};
