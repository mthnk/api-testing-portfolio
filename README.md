# API Testing Portfolio

A comprehensive API testing suite demonstrating REST API automation capabilities using Postman and Newman. This repository showcases professional API testing methodologies, automation frameworks, and continuous integration practices.

## 🎯 Overview

This portfolio demonstrates expertise in API testing automation across multiple platforms and authentication methods. The test suites cover real-world scenarios including CRUD operations, authentication workflows, error handling, and performance validation.

## 📋 Tested APIs

### 1. Restful Booker API
A hotel reservation management system testing complete booking lifecycle:
- **Endpoint**: `https://restful-booker.herokuapp.com`
- **Authentication**: JWT Token-based
- **Operations**: Create, Read, Update, Delete bookings
- **Features**: Dynamic data generation, response chaining

### 2. Trello API  
Project management system testing board and card operations:
- **Endpoint**: `https://api.trello.com/1`
- **Authentication**: API Key + Token
- **Operations**: Board, List, and Card management
- **Features**: Error scenario validation, performance monitoring

## 🚀 Key Features

- **Multi-API Testing**: Comprehensive test coverage across different API architectures
- **Authentication Methods**: JWT tokens and API key implementations
- **Dynamic Test Data**: Runtime data generation and variable chaining
- **Error Scenario Testing**: Intentional failure cases and edge condition handling
- **Performance Monitoring**: Response time tracking and optimization
- **CI/CD Integration**: Automated test execution via GitHub Actions
- **Professional Reporting**: HTML reports with detailed test metrics

## 📁 Project Structure

```
api-testing-portfolio/
├── collections/
│   ├── restful-booker/
│   │   ├── hotel-booking-collection.json
│   │   └── restful-booker-env.json
│   └── trello/
│       ├── trello-collection.json
│       ├── trello-env.json
│       └── test-results/
│           └── execution-report.json
├── newman-reports/
│   ├── hotel-booking-results.html
│   └── trello-api-results.html
├── scripts/
│   ├── run-all-tests.sh
│   ├── run-hotel-tests.sh
│   └── run-trello-tests.sh
├── .github/workflows/
│   └── api-tests.yml
└── README.md
```

## 🧪 Test Scenarios

### Restful Booker API Test Suite
- **Authentication Flow**: Token generation and validation
- **Booking Creation**: Dynamic booking data with random pricing
- **Data Retrieval**: Individual and bulk booking queries  
- **Update Operations**: Full and partial booking modifications
- **Deletion Workflow**: Booking removal and cleanup
- **Data Validation**: Response integrity and business logic verification

### Trello API Test Suite
- **Board Management**: Board creation and configuration
- **List Operations**: List creation within boards
- **Card CRUD**: Complete card lifecycle management
- **Error Handling**: 404 Not Found and authentication failures
- **Performance Testing**: Response time optimization

## 🔧 Getting Started

### Prerequisites
```bash
# Install Node.js (v14 or higher)
# Install Newman globally
npm install -g newman
```

### Running Tests

#### Individual Test Suites
```bash
# Run Hotel Booking API tests
newman run collections/restful-booker/hotel-booking-collection.json \
  -e collections/restful-booker/restful-booker-env.json

# Run Trello API tests  
newman run collections/trello/trello-collection.json \
  -e collections/trello/trello-env.json
```

#### All Tests with Reporting
```bash
# Execute all test suites
chmod +x scripts/run-all-tests.sh
./scripts/run-all-tests.sh

# Generate HTML reports
newman run collections/restful-booker/hotel-booking-collection.json \
  -e collections/restful-booker/restful-booker-env.json \
  --reporters html \
  --reporter-html-export newman-reports/hotel-booking-results.html
```

## 🤖 Continuous Integration

Automated testing pipeline using GitHub Actions for consistent quality assurance:

```yaml
name: API Test Automation
on: [push, pull_request]
jobs:
  api-testing:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3
      
      - name: Setup Node.js Environment
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install Newman
        run: npm install -g newman
      
      - name: Execute Hotel Booking Tests
        run: newman run collections/restful-booker/hotel-booking-collection.json -e collections/restful-booker/restful-booker-env.json --reporters cli,json --reporter-json-export hotel-test-results.json
        
      - name: Execute Trello API Tests
        run: newman run collections/trello/trello-collection.json -e collections/trello/trello-env.json --reporters cli,json --reporter-json-export trello-test-results.json
      
      - name: Archive Test Results
        uses: actions/upload-artifact@v3
        with:
          name: api-test-results
          path: |
            hotel-test-results.json
            trello-test-results.json
```

## 📊 Test Metrics & Results

### Performance Benchmarks
- **Average Response Time**: <1000ms across all endpoints
- **Success Rate**: 95%+ (including intentional error scenarios)
- **Test Coverage**: 15+ unique API endpoints
- **Execution Time**: <30 seconds for complete test suite

### Latest Test Execution Results
```
Trello API Test Results:
✅ Create Board - 200 OK (835ms)
✅ Create List - 200 OK (633ms)  
✅ Create Card - 200 OK (592ms)
🔍 Delete Card - 404 Not Found (284ms) [Expected Error]
✅ Update Card - 200 OK (381ms)

Total Execution Time: 2.7 seconds
Pass Rate: 100% (including error scenarios)
```

## 💡 Technical Implementation

### Authentication Strategies
- **JWT Token Management**: Automated token generation and environment persistence
- **API Key Authentication**: Secure credential management with environment variables
- **Session Handling**: Token refresh and expiration management

### Advanced Testing Features
- **Pre-request Scripts**: Dynamic data generation using JavaScript
- **Response Validation**: Comprehensive assertion frameworks
- **Environment Chaining**: Cross-test data persistence and reuse
- **Error Scenario Coverage**: Negative testing and edge case validation

### Test Data Management
```javascript
// Dynamic pricing generation
pm.environment.set("totalprice", parseInt(Math.random() * 1000));

// Token extraction and persistence  
let response = pm.response.json();
pm.environment.set("token", response.token);

// Cross-request data validation
pm.test("Price validation", function() {
    pm.expect(response.totalprice).to.eql(pm.environment.get("totalprice"));
});
```

## 🎯 Skills Demonstrated

- **API Testing Expertise**: REST API validation and automation
- **Test Automation**: End-to-end automated testing workflows  
- **Performance Testing**: Response time monitoring and optimization
- **Error Handling**: Comprehensive negative testing scenarios
- **CI/CD Integration**: Automated testing in development workflows
- **Documentation**: Professional test documentation and reporting
- **Tool Proficiency**: Advanced Postman and Newman usage

## 🔗 API Documentation

- [Restful Booker API Documentation](https://restful-booker.herokuapp.com/apidoc/index.html)
- [Trello API Documentation](https://developer.atlassian.com/cloud/trello/rest/api-group-actions/)

## 📈 Future Enhancements

- Integration with additional API platforms
- Database validation testing
- Load testing implementation  
- API contract testing
- Mobile API testing scenarios
- GraphQL API testing coverage

---

*This portfolio demonstrates professional API testing capabilities suitable for QA automation roles in software development, gaming, and technology industries.*
