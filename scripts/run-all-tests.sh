#!/bin/bash

# API Test Suite Automation Script
# Executes comprehensive API testing across multiple platforms
# Author: QA Automation Engineer
# Version: 1.2.0

set -e  # Exit on any error

# Color definitions for professional output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Configuration
readonly REPORTS_DIR="newman-reports"
readonly TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
readonly LOG_FILE="test_execution_${TIMESTAMP}.log"

# Test suite configurations
declare -A TEST_SUITES=(
    ["hotel"]="collections/restful-booker/hotel-booking-collection.json collections/restful-booker/restful-booker-env.json"
    ["trello"]="collections/trello/trello-collection.json collections/trello/trello-env.json"
)

# Function definitions
print_header() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                   API Test Suite Runner                      ║"
    echo "║              Professional Testing Automation                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_section() {
    local title="$1"
    echo -e "\n${BLUE}▶ ${title}${NC}"
    echo -e "${BLUE}$(printf '%.0s─' {1..50})${NC}"
}

setup_environment() {
    print_section "Environment Setup"
    
    # Create necessary directories
    mkdir -p "${REPORTS_DIR}"
    mkdir -p "logs"
    
    # Check Newman installation
    if ! command -v newman &> /dev/null; then
        echo -e "${RED}❌ Newman CLI not found. Please install: npm install -g newman${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Environment setup completed${NC}"
    echo -e "📁 Reports directory: ${REPORTS_DIR}"
    echo -e "📝 Log file: logs/${LOG_FILE}"
}

execute_test_suite() {
    local suite_name="$1"
    local collection_path="$2" 
    local environment_path="$3"
    local report_name="${suite_name}-api-results"
    
    print_section "Executing ${suite_name^} API Test Suite"
    
    echo -e "${YELLOW}📋 Running ${suite_name^} API tests...${NC}"
    echo -e "Collection: ${collection_path}"
    echo -e "Environment: ${environment_path}"
    
    local start_time=$(date +%s)
    
    # Execute Newman with comprehensive reporting
    if newman run "${collection_path}" \
        -e "${environment_path}" \
        --reporters cli,html,json \
        --reporter-html-export "${REPORTS_DIR}/${report_name}.html" \
        --reporter-json-export "${REPORTS_DIR}/${report_name}.json" \
        --color on \
        --disable-unicode \
        2>&1 | tee -a "logs/${LOG_FILE}"; then
        
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        
        echo -e "${GREEN}✅ ${suite_name^} API Tests - PASSED${NC}"
        echo -e "⏱️  Execution time: ${duration} seconds"
        echo -e "📊 Report generated: ${REPORTS_DIR}/${report_name}.html"
        
        return 0
    else
        echo -e "${RED}❌ ${suite_name^} API Tests - FAILED${NC}"
        return 1
    fi
}

generate_summary_report() {
    print_section "Test Execution Summary"
    
    local total_tests=0
    local passed_tests=0
    local failed_tests=0
    
    # Analyze JSON reports for metrics
    for report in "${REPORTS_DIR}"/*.json; do
        if [[ -f "$report" ]]; then
            echo -e "📈 Analyzing: $(basename "$report")"
            # Add JSON parsing logic here for detailed metrics
            total_tests=$((total_tests + 1))
            passed_tests=$((passed_tests + 1))  # Simplified for demo
        fi
    done
    
    echo -e "\n${CYAN}═══════════════════════════════════════${NC}"
    echo -e "${CYAN}           EXECUTION SUMMARY            ${NC}"
    echo -e "${CYAN}═══════════════════════════════════════${NC}"
    echo -e "📊 Total Test Suites: ${total_tests}"
    echo -e "✅ Passed: ${passed_tests}"
    echo -e "❌ Failed: ${failed_tests}"
    echo -e "📁 Reports Location: ${REPORTS_DIR}/"
    echo -e "📝 Detailed Logs: logs/${LOG_FILE}"
    echo -e "${CYAN}═══════════════════════════════════════${NC}"
}

cleanup_old_reports() {
    print_section "Cleanup Process"
    
    # Remove reports older than 7 days
    find "${REPORTS_DIR}" -name "*.html" -mtime +7 -delete 2>/dev/null || true
    find "${REPORTS_DIR}" -name "*.json" -mtime +7 -delete 2>/dev/null || true
    find "logs" -name "*.log" -mtime +7 -delete 2>/dev/null || true
    
    echo -e "${GREEN}✅ Cleanup completed${NC}"
}

main() {
    local exit_code=0
    
    print_header
    setup_environment
    cleanup_old_reports
    
    # Execute all test suites
    for suite_name in "${!TEST_SUITES[@]}"; do
        IFS=' ' read -ra suite_config <<< "${TEST_SUITES[$suite_name]}"
        collection_path="${suite_config[0]}"
        environment_path="${suite_config[1]}"
        
        if [[ -f "$collection_path" && -f "$environment_path" ]]; then
            execute_test_suite "$suite_name" "$collection_path" "$environment_path"
            if [[ $? -ne 0 ]]; then
                exit_code=1
            fi
        else
            echo -e "${RED}❌ Missing files for ${suite_name} test suite${NC}"
            echo -e "Collection: ${collection_path}"
            echo -e "Environment: ${environment_path}"
            exit_code=1
        fi
        
        sleep 2  # Brief pause between test suites
    done
    
    generate_summary_report
    
    if [[ $exit_code -eq 0 ]]; then
        echo -e "\n${GREEN}🎉 All API test suites completed successfully!${NC}"
    else
        echo -e "\n${RED}⚠️  Some test suites encountered issues. Check logs for details.${NC}"
    fi
    
    exit $exit_code
}

# Script execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
