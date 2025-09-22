#!/bin/bash
# task2-assign-users.sh - User Group Assignment Implementation
# INF 422 Laboratory Assignment 02 - Task 2
# Student: [Your Name]  
# Points: 20 out of 100 total

# TASK DESCRIPTION:
# Implement the business scenario from AWS Academy guided lab Task 2
# Add users to appropriate groups using AWS CLI commands

echo "👥 TASK 2: Adding Users to Groups per Business Scenario"
echo "======================================================="

# TODO 1: Set up error handling and logging
# Add proper error handling and create log file for operations
# Log file should be: outputs/assignment-log.txt
# YOUR CODE HERE:


# BUSINESS SCENARIO (from AWS Academy guided lab):
# user-1 → S3-Support group (Storage support role)
# user-2 → EC2-Support group (EC2 support role)
# user-3 → EC2-Admin group (EC2 administrator role)

echo "📋 Business Scenario Implementation:"
echo "   user-1 → S3-Support (Storage support role)"  
echo "   user-2 → EC2-Support (EC2 support role)"
echo "   user-3 → EC2-Admin (EC2 administrator role)"
echo ""

# TODO 2: Define user-group assignments
# Create variables or array to store the user-to-group mappings
# HINT: You can use associative arrays or simple variables
# Example: USER1="user-1" GROUP1="S3-Support"
# YOUR CODE HERE:


# TODO 3: Process each user assignment
# For each user-group pair:
# 1. Verify user exists
# 2. Verify group exists  
# 3. Check if user is already in group
# 4. Add user to group if not already member
# 5. Verify assignment was successful
# 6. Log all operations with timestamps

# REQUIRED COMMANDS:
# aws iam get-user --user-name [USER] (to check if user exists)
# aws iam get-group --group-name [GROUP] (to check if group exists)  
# aws iam get-groups-for-user --user-name [USER] (to check current memberships)
# aws iam add-user-to-group --user-name [USER] --group-name [GROUP]

# TODO 3a: Process user-1 → S3-Support
echo "📝 Processing: user-1 → S3-Support"
# YOUR CODE HERE:


echo ""

# TODO 3b: Process user-2 → EC2-Support  
echo "📝 Processing: user-2 → EC2-Support"
# YOUR CODE HERE:


echo ""

# TODO 3c: Process user-3 → EC2-Admin
echo "📝 Processing: user-3 → EC2-Admin"  
# YOUR CODE HERE:


echo ""

# TODO 4: Verify all assignments
# For each user, show their current group memberships
# This proves the assignments worked correctly
echo "🔍 Verification: Current Group Memberships"
echo "=============================================="

# TODO 4a: Show user-1 group memberships
echo "👤 user-1 group memberships:"
# YOUR CODE HERE:


# TODO 4b: Show user-2 group memberships
echo "👤 user-2 group memberships:"  
# YOUR CODE HERE:


# TODO 4c: Show user-3 group memberships
echo "👤 user-3 group memberships:"
# YOUR CODE HERE:


echo ""

# TODO 5: Generate assignment summary
# Create summary in log file with:
# - Total assignments attempted
# - Successful assignments  
# - Failed assignments
# - Completion timestamp
echo "📊 Assignment Summary:"
# YOUR CODE HERE:


echo ""
echo "✅ Task 2 completed!"
echo "📄 Detailed log saved to: outputs/assignment-log.txt"
echo ""
echo "Business scenario status:"
echo "   👔 user-1 → S3-Support: Storage administration access"
echo "   🖥️  user-2 → EC2-Support: Read-only EC2 infrastructure access"
echo "   🔧 user-3 → EC2-Admin: Full EC2 administrative capabilities"
