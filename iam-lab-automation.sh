#!/bin/bash

# ======================================================================
# AWS IAM Laboratory Assignment - Master Automation Script
# ======================================================================
# This master script orchestrates all IAM lab tasks using AWS CLI
# Points: 40/90 total
# Author: AWS IAM Lab Automation
# Date: $(date +%Y-%m-%d)
# ======================================================================

set -euo pipefail  # Exit on error, undefined variables, pipe failures

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/outputs"
DOC_DIR="${SCRIPT_DIR}/documentation"
LOG_FILE="${OUTPUT_DIR}/master-execution.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp} [${level}] ${message}" | tee -a "${LOG_FILE}"
}

# Print banner
print_banner() {
    echo -e "${BLUE}"
    echo "======================================================================="
    echo "              AWS IAM Laboratory Assignment Automation"
    echo "======================================================================="
    echo -e "${NC}"
    echo "Master script orchestrating all IAM lab tasks"
    echo "Total Points: 90 (Master: 40, Task1: 20, Task2: 20, Task3: 10)"
    echo ""
}

# Check prerequisites
check_prerequisites() {
    log "INFO" "Checking prerequisites..."
    
    # Check if AWS CLI is installed
    if ! command -v aws &> /dev/null; then
        log "ERROR" "AWS CLI is not installed. Please install AWS CLI first."
        exit 1
    fi
    
    # Check if AWS credentials are configured
    if ! aws sts get-caller-identity &> /dev/null; then
        log "ERROR" "AWS credentials not configured. Please run 'aws configure' first."
        exit 1
    fi
    
    # Check if required scripts exist
    local scripts=("task1-explore-iam.sh" "task2-assign-users.sh" "task3-test-permissions.sh")
    for script in "${scripts[@]}"; do
        if [[ ! -f "${SCRIPT_DIR}/${script}" ]]; then
            log "ERROR" "Required script ${script} not found."
            exit 1
        fi
        chmod +x "${SCRIPT_DIR}/${script}"
    done
    
    log "INFO" "Prerequisites check completed successfully."
}

# Initialize environment
initialize_environment() {
    log "INFO" "Initializing lab environment..."
    
    # Create output directories if they don't exist
    mkdir -p "${OUTPUT_DIR}" "${DOC_DIR}"
    
    # Clear previous logs
    > "${LOG_FILE}"
    
    # Get AWS account information
    local account_id=$(aws sts get-caller-identity --query Account --output text)
    local user_arn=$(aws sts get-caller-identity --query Arn --output text)
    
    log "INFO" "AWS Account ID: ${account_id}"
    log "INFO" "Current User ARN: ${user_arn}"
    log "INFO" "Environment initialized successfully."
}

# Execute task with error handling
execute_task() {
    local task_script=$1
    local task_name=$2
    local points=$3
    
    echo -e "${YELLOW}Executing ${task_name} (${points} points)...${NC}"
    log "INFO" "Starting ${task_name}"
    
    if bash "${SCRIPT_DIR}/${task_script}"; then
        echo -e "${GREEN}✓ ${task_name} completed successfully${NC}"
        log "INFO" "${task_name} completed successfully"
        return 0
    else
        echo -e "${RED}✗ ${task_name} failed${NC}"
        log "ERROR" "${task_name} failed"
        return 1
    fi
}

# Generate execution summary
generate_summary() {
    local success_count=$1
    local total_tasks=$2
    
    echo -e "${BLUE}"
    echo "======================================================================="
    echo "                        EXECUTION SUMMARY"
    echo "======================================================================="
    echo -e "${NC}"
    
    echo "Tasks Completed: ${success_count}/${total_tasks}"
    echo "Master Script Points: 40/40"
    
    local task_points=$((success_count * 20))
    if [[ $success_count -eq 3 ]]; then
        task_points=50  # Task1: 20, Task2: 20, Task3: 10
    elif [[ $success_count -eq 2 ]]; then
        task_points=40  # Task1: 20, Task2: 20
    elif [[ $success_count -eq 1 ]]; then
        task_points=20  # Task1: 20
    else
        task_points=0
    fi
    
    echo "Task Points: ${task_points}/50"
    echo "Total Points: $((40 + task_points))/90"
    echo ""
    echo "Log file: ${LOG_FILE}"
    echo "Output directory: ${OUTPUT_DIR}"
    echo "Documentation: ${DOC_DIR}"
    
    if [[ $success_count -eq $total_tasks ]]; then
        echo -e "${GREEN}🎉 All tasks completed successfully!${NC}"
    else
        echo -e "${YELLOW}⚠️ Some tasks failed. Check logs for details.${NC}"
    fi
}

# Main execution function
main() {
    print_banner
    
    # Initialize
    check_prerequisites
    initialize_environment
    
    # Execute tasks
    local success_count=0
    local total_tasks=3
    
    # Task 1: Explore IAM (20 points)
    if execute_task "task1-explore-iam.sh" "Task 1: Explore IAM" "20"; then
        ((success_count++))
    fi
    
    # Task 2: Assign Users (20 points)
    if execute_task "task2-assign-users.sh" "Task 2: Assign Users" "20"; then
        ((success_count++))
    fi
    
    # Task 3: Test Permissions (10 points)
    if execute_task "task3-test-permissions.sh" "Task 3: Test Permissions" "10"; then
        ((success_count++))
    fi
    
    # Generate summary
    generate_summary $success_count $total_tasks
    
    # Exit with appropriate code
    if [[ $success_count -eq $total_tasks ]]; then
        log "INFO" "Master script completed successfully"
        exit 0
    else
        log "ERROR" "Master script completed with errors"
        exit 1
    fi
}

# Script usage
usage() {
    echo "Usage: $0"
    echo ""
    echo "AWS IAM Laboratory Assignment Master Automation Script"
    echo ""
    echo "This script orchestrates all IAM lab tasks:"
    echo "  1. Task 1: Explore IAM (20 points)"
    echo "  2. Task 2: Assign Users (20 points)" 
    echo "  3. Task 3: Test Permissions (10 points)"
    echo ""
    echo "Prerequisites:"
    echo "  - AWS CLI installed and configured"
    echo "  - Appropriate IAM permissions"
    echo "  - Task scripts in same directory"
    echo ""
    echo "Output:"
    echo "  - Logs: ${OUTPUT_DIR}/master-execution.log"
    echo "  - Reports: ${OUTPUT_DIR}/"
    echo "  - Documentation: ${DOC_DIR}/"
}

# Handle command line arguments
if [[ $# -gt 0 ]]; then
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
fi

# Execute main function
main "$@"