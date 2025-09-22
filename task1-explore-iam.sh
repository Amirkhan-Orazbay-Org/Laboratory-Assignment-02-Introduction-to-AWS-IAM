#!/bin/bash
# task1-explore-iam.sh - IAM Users and Groups Exploration
# INF 422 Laboratory Assignment 02 - Task 1
# Student: [Your Name]
# Points: 20 out of 100 total

# TASK DESCRIPTION: 
# Replicate AWS Academy guided lab Task 1 using AWS CLI commands
# Explore existing IAM users, groups, and their relationships

echo "🔍 TASK 1: Exploring IAM Users and Groups via CLI"
echo "=================================================="

# TODO 1: Set up error handling and create outputs directory
# Add proper error handling for this script
# Ensure outputs directory exists for generated files
# YOUR CODE HERE:


# TODO 2: List all IAM users
# Use AWS CLI to get all users in the account
# Display in both JSON format and user-friendly table format
# REQUIRED COMMAND: aws iam list-users
echo "👥 Listing all IAM users..."
# YOUR CODE HERE:


echo ""

# TODO 3: List all IAM groups  
# Use AWS CLI to get all groups in the account
# Display in both JSON format and user-friendly table format
# REQUIRED COMMAND: aws iam list-groups
echo "👥 Listing all IAM groups..."
# YOUR CODE HERE:


echo ""

# TODO 4: Inspect specific lab groups
# For each group (EC2-Admin, EC2-Support, S3-Support):
# - Get group details including members
# - List attached managed policies  
# - List inline policies
# REQUIRED COMMANDS: 
# aws iam get-group --group-name [GROUP_NAME]
# aws iam list-attached-group-policies --group-name [GROUP_NAME]  
# aws iam list-group-policies --group-name [GROUP_NAME]

GROUPS=("EC2-Admin" "EC2-Support" "S3-Support")

for GROUP in "${GROUPS[@]}"; do
    echo "🔍 Inspecting Group: $GROUP"
    echo "----------------------------------------"
    
    # TODO 4a: Get group members
    # Show all users who are members of this group
    echo "Members:"
    # YOUR CODE HERE:
    
    
    # TODO 4b: Get attached managed policies
    # Show what AWS managed policies are attached to this group
    echo "Attached Managed Policies:"
    # YOUR CODE HERE:
    
    
    # TODO 4c: Get inline policies  
    # Show any inline policies defined for this group
    echo "Inline Policies:"
    # YOUR CODE HERE:
    
    
    echo ""
done

# TODO 5: Generate JSON report file
# Create a comprehensive JSON report with all findings
# Save as: outputs/user-groups-report.json
# Include: timestamp, account info, users list, groups list, group details
echo "📄 Generating comprehensive JSON report..."
# YOUR CODE HERE:


# TODO 6: Display summary statistics
# Show summary of what was discovered:
# - Total number of users found
# - Total number of groups found  
# - Which groups have members
# - Report file location
echo "📊 Discovery Summary:"
# YOUR CODE HERE:


echo ""
echo "✅ Task 1 completed!"
echo "📄 Detailed findings saved to: outputs/user-groups-report.json"
