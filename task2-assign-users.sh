#!/bin/bash

# ======================================================================
# Task 2: Assign Users - AWS CLI Automation
# ======================================================================
# This script creates users, groups, and manages assignments
# Points: 20/90 total
# Replicates AWS Academy IAM guided lab user assignment tasks
# ======================================================================

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/outputs"
ASSIGNMENT_LOG="${OUTPUT_DIR}/assignment-log.txt"
LOG_FILE="${OUTPUT_DIR}/task2-assignment.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Lab configuration - typical IAM lab users and groups
LAB_USERS=("user-1" "user-2" "user-3")
LAB_GROUPS=("S3-Support" "EC2-Support" "EC2-Admin")

# Logging function
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp} [${level}] ${message}" | tee -a "${LOG_FILE}"
    echo "${timestamp} [${level}] ${message}" >> "${ASSIGNMENT_LOG}"
}

# Print task banner
print_banner() {
    echo -e "${BLUE}"
    echo "======================================================================="
    echo "                   Task 2: Assign Users to Groups"
    echo "======================================================================="
    echo -e "${NC}"
    echo "Creating users, groups, and managing IAM assignments"
    echo "Points: 20/90"
    echo ""
}

# Initialize task environment
initialize_task() {
    log "INFO" "Initializing Task 2: Assign Users"
    
    # Create output directory
    mkdir -p "${OUTPUT_DIR}"
    
    # Clear previous logs
    > "${LOG_FILE}"
    > "${ASSIGNMENT_LOG}"
    
    log "INFO" "Assignment task starting with users: ${LAB_USERS[*]}"
    log "INFO" "Groups to create: ${LAB_GROUPS[*]}"
    log "INFO" "Task 2 initialization completed"
}

# Check if user exists
user_exists() {
    local username=$1
    aws iam get-user --user-name "$username" &>/dev/null
}

# Check if group exists
group_exists() {
    local groupname=$1
    aws iam get-group --group-name "$groupname" &>/dev/null
}

# Create IAM users
create_users() {
    log "INFO" "Creating IAM users..."
    echo -e "${YELLOW}Creating lab users...${NC}"
    
    for user in "${LAB_USERS[@]}"; do
        if user_exists "$user"; then
            echo "  → User $user already exists, skipping creation"
            log "INFO" "User $user already exists"
        else
            echo "  → Creating user: $user"
            if aws iam create-user --user-name "$user" --path "/lab/" &>/dev/null; then
                log "INFO" "Successfully created user: $user"
                echo "    ✓ User $user created successfully"
            else
                log "ERROR" "Failed to create user: $user"
                echo "    ✗ Failed to create user $user"
                return 1
            fi
        fi
    done
    
    log "INFO" "User creation phase completed"
}

# Create IAM groups with policies
create_groups() {
    log "INFO" "Creating IAM groups with policies..."
    echo -e "${YELLOW}Creating lab groups...${NC}"
    
    # Create S3-Support group
    create_s3_support_group
    
    # Create EC2-Support group
    create_ec2_support_group
    
    # Create EC2-Admin group
    create_ec2_admin_group
    
    log "INFO" "Group creation phase completed"
}

# Create S3-Support group
create_s3_support_group() {
    local group="S3-Support"
    
    if group_exists "$group"; then
        echo "  → Group $group already exists, skipping creation"
        log "INFO" "Group $group already exists"
    else
        echo "  → Creating group: $group"
        if aws iam create-group --group-name "$group" --path "/lab/" &>/dev/null; then
            log "INFO" "Successfully created group: $group"
            echo "    ✓ Group $group created successfully"
        else
            log "ERROR" "Failed to create group: $group"
            return 1
        fi
    fi
    
    # Attach S3ReadOnlyAccess policy to S3-Support group
    echo "    → Attaching S3ReadOnlyAccess policy to $group"
    if aws iam attach-group-policy \
        --group-name "$group" \
        --policy-arn "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess" &>/dev/null; then
        log "INFO" "Attached S3ReadOnlyAccess policy to $group"
        echo "      ✓ S3ReadOnlyAccess policy attached"
    else
        log "ERROR" "Failed to attach S3ReadOnlyAccess policy to $group"
    fi
}

# Create EC2-Support group
create_ec2_support_group() {
    local group="EC2-Support"
    
    if group_exists "$group"; then
        echo "  → Group $group already exists, skipping creation"
        log "INFO" "Group $group already exists"
    else
        echo "  → Creating group: $group"
        if aws iam create-group --group-name "$group" --path "/lab/" &>/dev/null; then
            log "INFO" "Successfully created group: $group"
            echo "    ✓ Group $group created successfully"
        else
            log "ERROR" "Failed to create group: $group"
            return 1
        fi
    fi
    
    # Attach EC2ReadOnlyAccess policy to EC2-Support group
    echo "    → Attaching EC2ReadOnlyAccess policy to $group"
    if aws iam attach-group-policy \
        --group-name "$group" \
        --policy-arn "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess" &>/dev/null; then
        log "INFO" "Attached EC2ReadOnlyAccess policy to $group"
        echo "      ✓ EC2ReadOnlyAccess policy attached"
    else
        log "ERROR" "Failed to attach EC2ReadOnlyAccess policy to $group"
    fi
}

# Create EC2-Admin group
create_ec2_admin_group() {
    local group="EC2-Admin"
    
    if group_exists "$group"; then
        echo "  → Group $group already exists, skipping creation"
        log "INFO" "Group $group already exists"
    else
        echo "  → Creating group: $group"
        if aws iam create-group --group-name "$group" --path "/lab/" &>/dev/null; then
            log "INFO" "Successfully created group: $group"
            echo "    ✓ Group $group created successfully"
        else
            log "ERROR" "Failed to create group: $group"
            return 1
        fi
    fi
    
    # Create custom policy for EC2-Admin
    create_ec2_admin_policy "$group"
}

# Create custom EC2-Admin policy
create_ec2_admin_policy() {
    local group=$1
    local policy_name="EC2-Admin-Policy"
    
    # Define EC2 Admin policy document
    local policy_document='{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ec2:Describe*",
                    "ec2:StartInstances",
                    "ec2:StopInstances",
                    "ec2:RebootInstances",
                    "ec2:TerminateInstances",
                    "ec2:CreateTags",
                    "ec2:DeleteTags"
                ],
                "Resource": "*"
            }
        ]
    }'
    
    echo "    → Creating custom EC2-Admin policy"
    
    # Check if policy already exists
    local account_id=$(aws sts get-caller-identity --query Account --output text)
    local policy_arn="arn:aws:iam::${account_id}:policy/${policy_name}"
    
    if aws iam get-policy --policy-arn "$policy_arn" &>/dev/null; then
        echo "      → Policy $policy_name already exists"
        log "INFO" "Policy $policy_name already exists"
    else
        if aws iam create-policy \
            --policy-name "$policy_name" \
            --policy-document "$policy_document" \
            --description "Custom policy for EC2 administration in lab environment" &>/dev/null; then
            log "INFO" "Created custom policy: $policy_name"
            echo "      ✓ Custom EC2-Admin policy created"
        else
            log "ERROR" "Failed to create custom policy: $policy_name"
            return 1
        fi
    fi
    
    # Attach custom policy to EC2-Admin group
    echo "    → Attaching custom EC2-Admin policy to $group"
    if aws iam attach-group-policy \
        --group-name "$group" \
        --policy-arn "$policy_arn" &>/dev/null; then
        log "INFO" "Attached custom EC2-Admin policy to $group"
        echo "      ✓ Custom EC2-Admin policy attached"
    else
        log "ERROR" "Failed to attach custom EC2-Admin policy to $group"
    fi
}

# Assign users to groups
assign_users_to_groups() {
    log "INFO" "Assigning users to groups..."
    echo -e "${YELLOW}Assigning users to groups...${NC}"
    
    # Assignment strategy for typical IAM lab
    local assignments=(
        "user-1:S3-Support"
        "user-2:EC2-Support"
        "user-3:EC2-Admin"
    )
    
    for assignment in "${assignments[@]}"; do
        local user=$(echo "$assignment" | cut -d: -f1)
        local group=$(echo "$assignment" | cut -d: -f2)
        
        echo "  → Assigning $user to $group"
        
        # Check if user is already in group
        if aws iam get-groups-for-user --user-name "$user" --output text --query "Groups[?GroupName=='$group'].GroupName" | grep -q "$group"; then
            echo "    → User $user already in group $group"
            log "INFO" "User $user already assigned to group $group"
        else
            if aws iam add-user-to-group --group-name "$group" --user-name "$user" &>/dev/null; then
                log "INFO" "Successfully assigned $user to $group"
                echo "    ✓ User $user assigned to $group"
            else
                log "ERROR" "Failed to assign $user to $group"
                echo "    ✗ Failed to assign $user to $group"
                return 1
            fi
        fi
    done
    
    log "INFO" "User assignment phase completed"
}

# Generate assignment report
generate_assignment_report() {
    log "INFO" "Generating assignment report..."
    echo -e "${YELLOW}Generating assignment report...${NC}"
    
    # Create detailed assignment report
    {
        echo "=========================================="
        echo "IAM User and Group Assignment Report"
        echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "=========================================="
        echo ""
        
        echo "CREATED USERS:"
        for user in "${LAB_USERS[@]}"; do
            if user_exists "$user"; then
                echo "  ✓ $user (exists)"
                # Get user's groups
                local user_groups=$(aws iam get-groups-for-user --user-name "$user" --query "Groups[].GroupName" --output text 2>/dev/null || echo "None")
                echo "    Groups: $user_groups"
            else
                echo "  ✗ $user (missing)"
            fi
        done
        echo ""
        
        echo "CREATED GROUPS:"
        for group in "${LAB_GROUPS[@]}"; do
            if group_exists "$group"; then
                echo "  ✓ $group (exists)"
                # Get group's attached policies
                local group_policies=$(aws iam list-attached-group-policies --group-name "$group" --query "AttachedPolicies[].PolicyName" --output text 2>/dev/null || echo "None")
                echo "    Policies: $group_policies"
                # Get group members
                local group_members=$(aws iam get-group --group-name "$group" --query "Users[].UserName" --output text 2>/dev/null || echo "None")
                echo "    Members: $group_members"
            else
                echo "  ✗ $group (missing)"
            fi
        done
        echo ""
        
        echo "ASSIGNMENT SUMMARY:"
        echo "  • user-1 → S3-Support (S3 read-only access)"
        echo "  • user-2 → EC2-Support (EC2 read-only access)"
        echo "  • user-3 → EC2-Admin (EC2 admin access)"
        echo ""
        
        echo "POLICIES ATTACHED:"
        echo "  • S3-Support: AmazonS3ReadOnlyAccess"
        echo "  • EC2-Support: AmazonEC2ReadOnlyAccess"
        echo "  • EC2-Admin: Custom EC2-Admin-Policy"
        echo ""
        
    } >> "${ASSIGNMENT_LOG}"
    
    log "INFO" "Assignment report generated: ${ASSIGNMENT_LOG}"
}

# Verify assignments
verify_assignments() {
    log "INFO" "Verifying user and group assignments..."
    echo -e "${YELLOW}Verifying assignments...${NC}"
    
    local verification_passed=true
    
    # Verify each user exists and is in correct group
    local expected_assignments=(
        "user-1:S3-Support"
        "user-2:EC2-Support" 
        "user-3:EC2-Admin"
    )
    
    for assignment in "${expected_assignments[@]}"; do
        local user=$(echo "$assignment" | cut -d: -f1)
        local expected_group=$(echo "$assignment" | cut -d: -f2)
        
        # Check if user exists
        if ! user_exists "$user"; then
            echo "  ✗ User $user does not exist"
            verification_passed=false
            continue
        fi
        
        # Check if user is in expected group
        if aws iam get-groups-for-user --user-name "$user" --output text --query "Groups[?GroupName=='$expected_group'].GroupName" | grep -q "$expected_group"; then
            echo "  ✓ $user correctly assigned to $expected_group"
        else
            echo "  ✗ $user not assigned to $expected_group"
            verification_passed=false
        fi
    done
    
    # Verify groups have correct policies
    if group_exists "S3-Support" && aws iam list-attached-group-policies --group-name "S3-Support" --query "AttachedPolicies[?PolicyName=='AmazonS3ReadOnlyAccess']" --output text | grep -q "AmazonS3ReadOnlyAccess"; then
        echo "  ✓ S3-Support has correct policy"
    else
        echo "  ✗ S3-Support missing correct policy"
        verification_passed=false
    fi
    
    if group_exists "EC2-Support" && aws iam list-attached-group-policies --group-name "EC2-Support" --query "AttachedPolicies[?PolicyName=='AmazonEC2ReadOnlyAccess']" --output text | grep -q "AmazonEC2ReadOnlyAccess"; then
        echo "  ✓ EC2-Support has correct policy"
    else
        echo "  ✗ EC2-Support missing correct policy"
        verification_passed=false
    fi
    
    if group_exists "EC2-Admin" && aws iam list-attached-group-policies --group-name "EC2-Admin" --query "AttachedPolicies[?PolicyName=='EC2-Admin-Policy']" --output text | grep -q "EC2-Admin-Policy"; then
        echo "  ✓ EC2-Admin has correct policy"
    else
        echo "  ✗ EC2-Admin missing correct policy"
        verification_passed=false
    fi
    
    if $verification_passed; then
        log "INFO" "All assignments verified successfully"
        return 0
    else
        log "ERROR" "Assignment verification failed"
        return 1
    fi
}

# Display assignment summary
display_summary() {
    echo -e "${GREEN}"
    echo "======================================================================="
    echo "                    Task 2: Assignment Summary"
    echo "======================================================================="
    echo -e "${NC}"
    
    echo "IAM Users and Groups Created:"
    echo "  Users: ${LAB_USERS[*]}"
    echo "  Groups: ${LAB_GROUPS[*]}"
    echo ""
    echo "Assignments:"
    echo "  • user-1 → S3-Support (S3 read-only)"
    echo "  • user-2 → EC2-Support (EC2 read-only)"
    echo "  • user-3 → EC2-Admin (EC2 admin)"
    echo ""
    echo "Assignment log: ${ASSIGNMENT_LOG}"
    echo "Task log: ${LOG_FILE}"
    echo -e "${GREEN}✓ Task 2 completed successfully (20 points)${NC}"
}

# Main execution function
main() {
    print_banner
    
    # Execute assignment tasks
    initialize_task
    create_users
    create_groups
    assign_users_to_groups
    generate_assignment_report
    
    if verify_assignments; then
        display_summary
        log "INFO" "Task 2: Assign Users completed successfully"
        return 0
    else
        echo -e "${RED}✗ Task 2 failed verification${NC}"
        log "ERROR" "Task 2: Assign Users failed verification"
        return 1
    fi
}

# Script usage
usage() {
    echo "Usage: $0"
    echo ""
    echo "Task 2: Assign Users to Groups (20 points)"
    echo ""
    echo "This script creates and manages IAM user assignments:"
    echo "  - Creates lab users: ${LAB_USERS[*]}"
    echo "  - Creates lab groups: ${LAB_GROUPS[*]}"
    echo "  - Assigns appropriate policies to groups"
    echo "  - Assigns users to groups based on lab requirements"
    echo ""
    echo "Output:"
    echo "  - Assignment log: ${OUTPUT_DIR}/assignment-log.txt"
    echo "  - Task log: ${OUTPUT_DIR}/task2-assignment.log"
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