#!/bin/bash

# ======================================================================
# Task 1: Explore IAM - AWS CLI Automation
# ======================================================================
# This script explores existing IAM resources and generates reports
# Points: 20/90 total
# Replicates AWS Academy IAM guided lab exploration tasks
# ======================================================================

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/outputs"
REPORT_FILE="${OUTPUT_DIR}/user-groups-report.json"
LOG_FILE="${OUTPUT_DIR}/task1-exploration.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging function
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp} [${level}] ${message}" | tee -a "${LOG_FILE}"
}

# Print task banner
print_banner() {
    echo -e "${BLUE}"
    echo "======================================================================="
    echo "                     Task 1: Explore IAM Resources"
    echo "======================================================================="
    echo -e "${NC}"
    echo "Exploring existing IAM users, groups, policies, and roles"
    echo "Points: 20/90"
    echo ""
}

# Initialize task environment
initialize_task() {
    log "INFO" "Initializing Task 1: Explore IAM"
    
    # Create output directory
    mkdir -p "${OUTPUT_DIR}"
    
    # Clear previous logs and reports
    > "${LOG_FILE}"
    > "${REPORT_FILE}"
    
    log "INFO" "Task 1 initialization completed"
}

# Explore IAM users
explore_users() {
    log "INFO" "Exploring IAM users..."
    echo -e "${YELLOW}Discovering IAM users...${NC}"
    
    # Get all IAM users
    local users_json=$(aws iam list-users --output json)
    local user_count=$(echo "$users_json" | jq '.Users | length')
    
    echo "Found ${user_count} IAM users"
    
    # Store users data
    echo "$users_json" | jq '{
        "discovery_timestamp": now | strftime("%Y-%m-%d %H:%M:%S"),
        "user_count": (.Users | length),
        "users": [
            .Users[] | {
                "username": .UserName,
                "user_id": .UserId,
                "arn": .Arn,
                "created_date": .CreateDate,
                "path": .Path,
                "password_last_used": (.PasswordLastUsed // "Never")
            }
        ]
    }' > /tmp/users_data.json
    
    # Get attached policies for each user
    if [[ $user_count -gt 0 ]]; then
        echo "Getting user policies and groups..."
        local users_with_details='[]'
        
        while IFS= read -r username; do
            log "INFO" "Processing user: $username"
            
            # Get user's groups
            local user_groups=$(aws iam get-groups-for-user --user-name "$username" --output json 2>/dev/null || echo '{"Groups":[]}')
            
            # Get user's attached policies
            local user_policies=$(aws iam list-attached-user-policies --user-name "$username" --output json 2>/dev/null || echo '{"AttachedPolicies":[]}')
            
            # Get user's inline policies
            local inline_policies=$(aws iam list-user-policies --user-name "$username" --output json 2>/dev/null || echo '{"PolicyNames":[]}')
            
            # Combine data
            users_with_details=$(echo "$users_with_details" | jq --arg username "$username" \
                --argjson groups "$user_groups" \
                --argjson policies "$user_policies" \
                --argjson inline "$inline_policies" \
                '. + [{
                    "username": $username,
                    "groups": $groups.Groups,
                    "attached_policies": $policies.AttachedPolicies,
                    "inline_policies": $inline.PolicyNames
                }]')
                
        done < <(echo "$users_json" | jq -r '.Users[].UserName')
        
        echo "$users_with_details" > /tmp/users_with_details.json
    fi
    
    log "INFO" "IAM users exploration completed"
}

# Explore IAM groups
explore_groups() {
    log "INFO" "Exploring IAM groups..."
    echo -e "${YELLOW}Discovering IAM groups...${NC}"
    
    # Get all IAM groups
    local groups_json=$(aws iam list-groups --output json)
    local group_count=$(echo "$groups_json" | jq '.Groups | length')
    
    echo "Found ${group_count} IAM groups"
    
    # Store groups data with policies
    local groups_with_details='[]'
    
    if [[ $group_count -gt 0 ]]; then
        while IFS= read -r groupname; do
            log "INFO" "Processing group: $groupname"
            
            # Get group's attached policies
            local group_policies=$(aws iam list-attached-group-policies --group-name "$groupname" --output json 2>/dev/null || echo '{"AttachedPolicies":[]}')
            
            # Get group's inline policies
            local inline_policies=$(aws iam list-group-policies --group-name "$groupname" --output json 2>/dev/null || echo '{"PolicyNames":[]}')
            
            # Get group members
            local group_users=$(aws iam get-group --group-name "$groupname" --output json 2>/dev/null || echo '{"Users":[]}')
            
            groups_with_details=$(echo "$groups_with_details" | jq --arg groupname "$groupname" \
                --argjson policies "$group_policies" \
                --argjson inline "$inline_policies" \
                --argjson users "$group_users" \
                '. + [{
                    "group_name": $groupname,
                    "attached_policies": $policies.AttachedPolicies,
                    "inline_policies": $inline.PolicyNames,
                    "members": $users.Users
                }]')
                
        done < <(echo "$groups_json" | jq -r '.Groups[].GroupName')
    fi
    
    echo "$groups_with_details" > /tmp/groups_with_details.json
    
    log "INFO" "IAM groups exploration completed"
}

# Explore IAM roles
explore_roles() {
    log "INFO" "Exploring IAM roles..."
    echo -e "${YELLOW}Discovering IAM roles...${NC}"
    
    # Get all IAM roles
    local roles_json=$(aws iam list-roles --output json)
    local role_count=$(echo "$roles_json" | jq '.Roles | length')
    
    echo "Found ${role_count} IAM roles"
    
    # Filter and store relevant roles data
    echo "$roles_json" | jq '{
        "discovery_timestamp": now | strftime("%Y-%m-%d %H:%M:%S"),
        "role_count": (.Roles | length),
        "roles": [
            .Roles[] | {
                "role_name": .RoleName,
                "arn": .Arn,
                "created_date": .CreateDate,
                "path": .Path,
                "max_session_duration": .MaxSessionDuration,
                "description": (.Description // "No description")
            }
        ]
    }' > /tmp/roles_data.json
    
    log "INFO" "IAM roles exploration completed"
}

# Explore IAM policies
explore_policies() {
    log "INFO" "Exploring IAM policies..."
    echo -e "${YELLOW}Discovering IAM policies...${NC}"
    
    # Get AWS managed policies
    local aws_policies=$(aws iam list-policies --scope AWS --max-items 100 --output json)
    local aws_count=$(echo "$aws_policies" | jq '.Policies | length')
    
    # Get customer managed policies
    local customer_policies=$(aws iam list-policies --scope Local --output json)
    local customer_count=$(echo "$customer_policies" | jq '.Policies | length')
    
    echo "Found ${aws_count} AWS managed policies"
    echo "Found ${customer_count} customer managed policies"
    
    # Store policies summary
    jq -n --argjson aws "$aws_policies" --argjson customer "$customer_policies" '{
        "discovery_timestamp": now | strftime("%Y-%m-%d %H:%M:%S"),
        "aws_managed_policies": {
            "count": ($aws.Policies | length),
            "policies": [
                $aws.Policies[] | {
                    "policy_name": .PolicyName,
                    "arn": .Arn,
                    "created_date": .CreateDate,
                    "update_date": .UpdateDate,
                    "description": (.Description // "No description")
                }
            ]
        },
        "customer_managed_policies": {
            "count": ($customer.Policies | length),
            "policies": [
                $customer.Policies[] | {
                    "policy_name": .PolicyName,
                    "arn": .Arn,
                    "created_date": .CreateDate,
                    "update_date": .UpdateDate,
                    "description": (.Description // "No description")
                }
            ]
        }
    }' > /tmp/policies_data.json
    
    log "INFO" "IAM policies exploration completed"
}

# Generate comprehensive report
generate_report() {
    log "INFO" "Generating comprehensive IAM exploration report..."
    echo -e "${YELLOW}Generating exploration report...${NC}"
    
    # Combine all exploration data
    local users_data='{"users": [], "user_details": []}'
    local groups_data='{"groups": []}'
    local roles_data='{"roles": []}'
    local policies_data='{"aws_managed_policies": {"count": 0, "policies": []}, "customer_managed_policies": {"count": 0, "policies": []}}'
    
    # Read data files if they exist
    [[ -f /tmp/users_data.json ]] && users_data=$(cat /tmp/users_data.json)
    [[ -f /tmp/users_with_details.json ]] && user_details=$(cat /tmp/users_with_details.json)
    [[ -f /tmp/groups_with_details.json ]] && groups_data=$(cat /tmp/groups_with_details.json)
    [[ -f /tmp/roles_data.json ]] && roles_data=$(cat /tmp/roles_data.json)
    [[ -f /tmp/policies_data.json ]] && policies_data=$(cat /tmp/policies_data.json)
    
    # Create comprehensive report
    jq -n \
        --argjson users "$users_data" \
        --argjson user_details "${user_details:-[]}" \
        --argjson groups "$groups_data" \
        --argjson roles "$roles_data" \
        --argjson policies "$policies_data" \
        '{
            "report_metadata": {
                "task": "Task 1: Explore IAM",
                "generated_at": now | strftime("%Y-%m-%d %H:%M:%S"),
                "generated_by": "IAM Lab Automation Script",
                "aws_account": "REDACTED"
            },
            "summary": {
                "total_users": ($users.user_count // 0),
                "total_groups": ($groups | length),
                "total_roles": ($roles.role_count // 0),
                "aws_managed_policies": ($policies.aws_managed_policies.count // 0),
                "customer_managed_policies": ($policies.customer_managed_policies.count // 0)
            },
            "iam_users": {
                "count": ($users.user_count // 0),
                "users": ($users.users // []),
                "user_assignments": $user_details
            },
            "iam_groups": {
                "count": ($groups | length),
                "groups": $groups
            },
            "iam_roles": {
                "count": ($roles.role_count // 0),
                "roles": ($roles.roles // [])
            },
            "iam_policies": $policies
        }' > "${REPORT_FILE}"
    
    # Clean up temporary files
    rm -f /tmp/users_data.json /tmp/users_with_details.json /tmp/groups_with_details.json /tmp/roles_data.json /tmp/policies_data.json
    
    log "INFO" "Comprehensive report generated: ${REPORT_FILE}"
}

# Display exploration summary
display_summary() {
    echo -e "${GREEN}"
    echo "======================================================================="
    echo "                    Task 1: Exploration Summary"
    echo "======================================================================="
    echo -e "${NC}"
    
    if [[ -f "${REPORT_FILE}" ]]; then
        local summary=$(jq '.summary' "${REPORT_FILE}")
        echo "IAM Resource Discovery Results:"
        echo "  • Users: $(echo "$summary" | jq -r '.total_users')"
        echo "  • Groups: $(echo "$summary" | jq -r '.total_groups')"
        echo "  • Roles: $(echo "$summary" | jq -r '.total_roles')"
        echo "  • AWS Managed Policies: $(echo "$summary" | jq -r '.aws_managed_policies')"
        echo "  • Customer Managed Policies: $(echo "$summary" | jq -r '.customer_managed_policies')"
        echo ""
        echo "Report generated: ${REPORT_FILE}"
        echo "Log file: ${LOG_FILE}"
        echo -e "${GREEN}✓ Task 1 completed successfully (20 points)${NC}"
    else
        echo -e "${RED}✗ Report generation failed${NC}"
        return 1
    fi
}

# Main execution function
main() {
    print_banner
    
    # Execute exploration tasks
    initialize_task
    explore_users
    explore_groups
    explore_roles
    explore_policies
    generate_report
    display_summary
    
    log "INFO" "Task 1: Explore IAM completed successfully"
}

# Script usage
usage() {
    echo "Usage: $0"
    echo ""
    echo "Task 1: Explore IAM Resources (20 points)"
    echo ""
    echo "This script explores and documents existing IAM resources:"
    echo "  - IAM Users and their assignments"
    echo "  - IAM Groups and policies"
    echo "  - IAM Roles"
    echo "  - IAM Policies (AWS managed and customer managed)"
    echo ""
    echo "Output:"
    echo "  - Report: ${OUTPUT_DIR}/user-groups-report.json"
    echo "  - Log: ${OUTPUT_DIR}/task1-exploration.log"
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