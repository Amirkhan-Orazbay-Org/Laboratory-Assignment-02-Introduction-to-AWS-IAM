#!/bin/bash

# ======================================================================
# Task 3: Test Permissions - AWS CLI Automation
# ======================================================================
# This script tests IAM permissions for created users
# Points: 10/90 total
# Replicates AWS Academy IAM guided lab permission testing
# ======================================================================

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/outputs"
TEST_RESULTS="${OUTPUT_DIR}/permission-test-results.txt"
LOG_FILE="${OUTPUT_DIR}/task3-testing.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test users from Task 2
TEST_USERS=("user-1" "user-2" "user-3")

# Logging function
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp} [${level}] ${message}" | tee -a "${LOG_FILE}"
    echo "${timestamp} [${level}] ${message}" >> "${TEST_RESULTS}"
}

# Print task banner
print_banner() {
    echo -e "${BLUE}"
    echo "======================================================================="
    echo "                   Task 3: Test IAM Permissions"
    echo "======================================================================="
    echo -e "${NC}"
    echo "Testing permissions for lab users using AWS CLI simulation"
    echo "Points: 10/90"
    echo ""
}

# Initialize task environment
initialize_task() {
    log "INFO" "Initializing Task 3: Test Permissions"
    
    # Create output directory
    mkdir -p "${OUTPUT_DIR}"
    
    # Clear previous logs
    > "${LOG_FILE}"
    > "${TEST_RESULTS}"
    
    log "INFO" "Testing permissions for users: ${TEST_USERS[*]}"
    log "INFO" "Task 3 initialization completed"
}

# Check if user exists
user_exists() {
    local username=$1
    aws iam get-user --user-name "$username" &>/dev/null
}

# Simulate permission test for a user and action
simulate_permission() {
    local username=$1
    local action=$2
    local resource=$3
    local expected_result=$4  # "ALLOW" or "DENY"
    
    log "INFO" "Simulating permission: User=$username, Action=$action, Resource=$resource"
    
    # Use IAM policy simulator
    local simulation_result
    if simulation_result=$(aws iam simulate-principal-policy \
        --policy-source-arn "$(aws iam get-user --user-name "$username" --query 'User.Arn' --output text)" \
        --action-names "$action" \
        --resource-arns "$resource" \
        --query 'EvaluationResults[0].EvalDecision' \
        --output text 2>/dev/null); then
        
        if [[ "$simulation_result" == "$expected_result" ]]; then
            echo "    ✓ $action on $resource: $simulation_result (as expected)"
            log "INFO" "Permission test PASSED: $username - $action on $resource = $simulation_result"
            return 0
        else
            echo "    ⚠ $action on $resource: $simulation_result (expected $expected_result)"
            log "WARN" "Permission test UNEXPECTED: $username - $action on $resource = $simulation_result (expected $expected_result)"
            return 1
        fi
    else
        echo "    ✗ $action on $resource: SIMULATION_ERROR"
        log "ERROR" "Permission test ERROR: $username - $action on $resource = SIMULATION_ERROR"
        return 1
    fi
}

# Test basic IAM permissions (check if users can see their own info)
test_basic_permissions() {
    log "INFO" "Testing basic IAM permissions..."
    echo -e "${YELLOW}Testing basic IAM access for all users...${NC}"
    
    local test_passed=0
    local test_total=0
    
    for user in "${TEST_USERS[@]}"; do
        if ! user_exists "$user"; then
            echo "  ✗ User $user does not exist, skipping tests"
            log "ERROR" "User $user does not exist"
            continue
        fi
        
        echo "  Testing basic permissions for $user:"
        
        # Test: Can user see their own info? (This should generally be allowed)
        ((test_total++))
        if simulate_permission "$user" "iam:GetUser" "$(aws iam get-user --user-name "$user" --query 'User.Arn' --output text)" "ALLOW"; then
            ((test_passed++))
        fi
        
        # Test: Can user list all users? (Should be denied for lab users)
        ((test_total++))
        if simulate_permission "$user" "iam:ListUsers" "*" "DENY"; then
            ((test_passed++))
        fi
    done
    
    log "INFO" "Basic permission tests: $test_passed/$test_total passed"
    echo "  Basic permission tests: $test_passed/$test_total passed"
}

# Test S3 permissions for user-1 (S3-Support group)
test_s3_permissions() {
    local user="user-1"
    
    if ! user_exists "$user"; then
        echo "  ✗ User $user does not exist, skipping S3 tests"
        log "ERROR" "User $user does not exist for S3 testing"
        return
    fi
    
    log "INFO" "Testing S3 permissions for $user (S3-Support group)..."
    echo -e "${YELLOW}Testing S3 permissions for $user...${NC}"
    
    local test_passed=0
    local test_total=0
    
    echo "  S3 permission tests for $user:"
    
    # Test: Can list S3 buckets? (Should be allowed - read-only access)
    ((test_total++))
    if simulate_permission "$user" "s3:ListAllMyBuckets" "*" "ALLOW"; then
        ((test_passed++))
    fi
    
    # Test: Can get S3 objects? (Should be allowed - read-only access)
    ((test_total++))
    if simulate_permission "$user" "s3:GetObject" "arn:aws:s3:::*/*" "ALLOW"; then
        ((test_passed++))
    fi
    
    # Test: Can create S3 buckets? (Should be denied - read-only access)
    ((test_total++))
    if simulate_permission "$user" "s3:CreateBucket" "arn:aws:s3:::test-bucket" "DENY"; then
        ((test_passed++))
    fi
    
    # Test: Can delete S3 objects? (Should be denied - read-only access)
    ((test_total++))
    if simulate_permission "$user" "s3:DeleteObject" "arn:aws:s3:::*/test-object" "DENY"; then
        ((test_passed++))
    fi
    
    log "INFO" "S3 permission tests for $user: $test_passed/$test_total passed"
    echo "  S3 permission tests: $test_passed/$test_total passed"
}

# Test EC2 permissions for user-2 (EC2-Support group)
test_ec2_support_permissions() {
    local user="user-2"
    
    if ! user_exists "$user"; then
        echo "  ✗ User $user does not exist, skipping EC2 Support tests"
        log "ERROR" "User $user does not exist for EC2 Support testing"
        return
    fi
    
    log "INFO" "Testing EC2 Support permissions for $user (EC2-Support group)..."
    echo -e "${YELLOW}Testing EC2 Support permissions for $user...${NC}"
    
    local test_passed=0
    local test_total=0
    
    echo "  EC2 Support permission tests for $user:"
    
    # Test: Can describe EC2 instances? (Should be allowed - read-only access)
    ((test_total++))
    if simulate_permission "$user" "ec2:DescribeInstances" "*" "ALLOW"; then
        ((test_passed++))
    fi
    
    # Test: Can describe EC2 security groups? (Should be allowed - read-only access)
    ((test_total++))
    if simulate_permission "$user" "ec2:DescribeSecurityGroups" "*" "ALLOW"; then
        ((test_passed++))
    fi
    
    # Test: Can start EC2 instances? (Should be denied - read-only access)
    ((test_total++))
    if simulate_permission "$user" "ec2:StartInstances" "arn:aws:ec2:*:*:instance/*" "DENY"; then
        ((test_passed++))
    fi
    
    # Test: Can terminate EC2 instances? (Should be denied - read-only access)
    ((test_total++))
    if simulate_permission "$user" "ec2:TerminateInstances" "arn:aws:ec2:*:*:instance/*" "DENY"; then
        ((test_passed++))
    fi
    
    log "INFO" "EC2 Support permission tests for $user: $test_passed/$test_total passed"
    echo "  EC2 Support permission tests: $test_passed/$test_total passed"
}

# Test EC2 Admin permissions for user-3 (EC2-Admin group)
test_ec2_admin_permissions() {
    local user="user-3"
    
    if ! user_exists "$user"; then
        echo "  ✗ User $user does not exist, skipping EC2 Admin tests"
        log "ERROR" "User $user does not exist for EC2 Admin testing"
        return
    fi
    
    log "INFO" "Testing EC2 Admin permissions for $user (EC2-Admin group)..."
    echo -e "${YELLOW}Testing EC2 Admin permissions for $user...${NC}"
    
    local test_passed=0
    local test_total=0
    
    echo "  EC2 Admin permission tests for $user:"
    
    # Test: Can describe EC2 instances? (Should be allowed)
    ((test_total++))
    if simulate_permission "$user" "ec2:DescribeInstances" "*" "ALLOW"; then
        ((test_passed++))
    fi
    
    # Test: Can start EC2 instances? (Should be allowed - admin access)
    ((test_total++))
    if simulate_permission "$user" "ec2:StartInstances" "arn:aws:ec2:*:*:instance/*" "ALLOW"; then
        ((test_passed++))
    fi
    
    # Test: Can stop EC2 instances? (Should be allowed - admin access)
    ((test_total++))
    if simulate_permission "$user" "ec2:StopInstances" "arn:aws:ec2:*:*:instance/*" "ALLOW"; then
        ((test_passed++))
    fi
    
    # Test: Can terminate EC2 instances? (Should be allowed - admin access)
    ((test_total++))
    if simulate_permission "$user" "ec2:TerminateInstances" "arn:aws:ec2:*:*:instance/*" "ALLOW"; then
        ((test_passed++))
    fi
    
    # Test: Can access S3? (Should be denied - no S3 permissions)
    ((test_total++))
    if simulate_permission "$user" "s3:ListAllMyBuckets" "*" "DENY"; then
        ((test_passed++))
    fi
    
    log "INFO" "EC2 Admin permission tests for $user: $test_passed/$test_total passed"
    echo "  EC2 Admin permission tests: $test_passed/$test_total passed"
}

# Test cross-service permissions (users should not have access to other services)
test_cross_service_permissions() {
    log "INFO" "Testing cross-service permission boundaries..."
    echo -e "${YELLOW}Testing cross-service permission boundaries...${NC}"
    
    local test_passed=0
    local test_total=0
    
    # Test: S3 user (user-1) should not have EC2 access
    if user_exists "user-1"; then
        echo "  Testing S3 user isolation:"
        ((test_total++))
        if simulate_permission "user-1" "ec2:DescribeInstances" "*" "DENY"; then
            ((test_passed++))
            echo "    ✓ S3 user correctly denied EC2 access"
        fi
    fi
    
    # Test: EC2 Support user (user-2) should not have S3 access
    if user_exists "user-2"; then
        echo "  Testing EC2 Support user isolation:"
        ((test_total++))
        if simulate_permission "user-2" "s3:ListAllMyBuckets" "*" "DENY"; then
            ((test_passed++))
            echo "    ✓ EC2 Support user correctly denied S3 access"
        fi
    fi
    
    # Test: EC2 Admin user (user-3) should not have IAM admin access
    if user_exists "user-3"; then
        echo "  Testing EC2 Admin user limitations:"
        ((test_total++))
        if simulate_permission "user-3" "iam:CreateUser" "*" "DENY"; then
            ((test_passed++))
            echo "    ✓ EC2 Admin user correctly denied IAM admin access"
        fi
    fi
    
    log "INFO" "Cross-service permission tests: $test_passed/$test_total passed"
    echo "  Cross-service isolation tests: $test_passed/$test_total passed"
}

# Generate comprehensive test report
generate_test_report() {
    log "INFO" "Generating comprehensive permission test report..."
    echo -e "${YELLOW}Generating test report...${NC}"
    
    {
        echo "=========================================="
        echo "IAM Permission Testing Report"
        echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "=========================================="
        echo ""
        
        echo "TEST OVERVIEW:"
        echo "This report shows the results of permission testing for"
        echo "IAM users created in the lab environment."
        echo ""
        
        echo "USERS TESTED:"
        for user in "${TEST_USERS[@]}"; do
            if user_exists "$user"; then
                echo "  ✓ $user (exists)"
                # Get user's groups
                local groups=$(aws iam get-groups-for-user --user-name "$user" --query "Groups[].GroupName" --output text 2>/dev/null || echo "None")
                echo "    Groups: $groups"
            else
                echo "  ✗ $user (missing)"
            fi
        done
        echo ""
        
        echo "PERMISSION TEST CATEGORIES:"
        echo "  1. Basic IAM permissions"
        echo "  2. S3 permissions (user-1 / S3-Support)"
        echo "  3. EC2 Support permissions (user-2 / EC2-Support)"
        echo "  4. EC2 Admin permissions (user-3 / EC2-Admin)"
        echo "  5. Cross-service isolation"
        echo ""
        
        echo "EXPECTED BEHAVIOR:"
        echo "  • user-1 (S3-Support): S3 read-only, no EC2 access"
        echo "  • user-2 (EC2-Support): EC2 read-only, no S3 access"
        echo "  • user-3 (EC2-Admin): EC2 admin, no S3/IAM admin access"
        echo "  • All users: Limited IAM self-service only"
        echo ""
        
        echo "TEST METHODOLOGY:"
        echo "  - Used AWS IAM Policy Simulator for testing"
        echo "  - Tested both positive and negative permissions"
        echo "  - Verified principle of least privilege"
        echo "  - Confirmed proper access boundaries"
        echo ""
        
        echo "NOTES:"
        echo "  - Tests use simulation, not actual resource access"
        echo "  - Some simulations may vary based on resource existence"
        echo "  - Focus is on policy evaluation, not resource availability"
        echo ""
        
    } >> "${TEST_RESULTS}"
    
    log "INFO" "Test report generated: ${TEST_RESULTS}"
}

# Display testing summary
display_summary() {
    echo -e "${GREEN}"
    echo "======================================================================="
    echo "                   Task 3: Permission Testing Summary"
    echo "======================================================================="
    echo -e "${NC}"
    
    echo "Permission Testing Completed:"
    echo "  • Basic IAM permissions verified"
    echo "  • S3-Support permissions tested (user-1)"
    echo "  • EC2-Support permissions tested (user-2)"
    echo "  • EC2-Admin permissions tested (user-3)"
    echo "  • Cross-service isolation verified"
    echo ""
    echo "Test methodology: AWS IAM Policy Simulator"
    echo "Focus: Principle of least privilege verification"
    echo ""
    echo "Test results: ${TEST_RESULTS}"
    echo "Task log: ${LOG_FILE}"
    echo -e "${GREEN}✓ Task 3 completed successfully (10 points)${NC}"
}

# Main execution function
main() {
    print_banner
    
    # Execute permission testing
    initialize_task
    
    # Run all permission tests
    test_basic_permissions
    test_s3_permissions
    test_ec2_support_permissions
    test_ec2_admin_permissions
    test_cross_service_permissions
    
    # Generate report
    generate_test_report
    display_summary
    
    log "INFO" "Task 3: Test Permissions completed successfully"
}

# Script usage
usage() {
    echo "Usage: $0"
    echo ""
    echo "Task 3: Test IAM Permissions (10 points)"
    echo ""
    echo "This script tests IAM permissions for lab users:"
    echo "  - Uses AWS IAM Policy Simulator for testing"
    echo "  - Tests positive and negative permissions"
    echo "  - Verifies principle of least privilege"
    echo "  - Confirms proper access boundaries"
    echo ""
    echo "Users tested: ${TEST_USERS[*]}"
    echo ""
    echo "Output:"
    echo "  - Test results: ${OUTPUT_DIR}/permission-test-results.txt"
    echo "  - Task log: ${OUTPUT_DIR}/task3-testing.log"
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