# Security Assessment Framework Guide

This framework is designed for comprehensive security testing of backend and mobile applications.

## Technology Stack Detection
The framework automatically detects:
- **Flutter/Supabase** (Current Stack)
- **Node.js/Express**
- **Java Spring Boot**
- **Python Django/Flask**

## Security Phases
1. **Backend Discovery**: Identifies framework, language, and architecture.
2. **API Discovery**: Maps all endpoints from route definitions and code.
3. **SAST**: Static analysis for Auth, Injection, and Sensitive Data risks.
4. **DAST**: Dynamic testing for running environments (Non-destructive).
5. **Dependency Scanning**: Checks for CVEs in third-party libraries.
6. **Reporting**: Generates Markdown and Excel reports.

## Setup Instructions

### 1. Local Execution
Requires Node.js installed.
```bash
npm install exceljs fs-extra
node src/security/security_scanner.js
```

### 2. GitHub Actions
The workflows are located in `.github/workflows/`:
- `security-review.yml`: Full SAST and security assessment.
- `vulnerability-test.yml`: Specialized workflow for generating 300+ test scenarios.

## Deliverables
- `Vulnerability Test Results/security-review.md`: Detailed finding list.
- `Vulnerability Test Results/executive-summary.md`: Risk overview.
- `Vulnerability Test Results/dependency-report.md`: Package vulnerability scan.
- `Vulnerability Test Results/security-report.xlsx`: Multi-tab report including 300+ unique test cases.
