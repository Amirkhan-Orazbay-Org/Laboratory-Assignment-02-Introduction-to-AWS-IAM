#!/bin/bash
# iam-lab-automation.sh - Master Script Template
# INF 422 Laboratory Assignment 02
# Student: [Your Name]
# Date: [Current Date]

# ASSIGNMENT: Create a master script that executes all lab tasks in sequence
# POINTS: 40 out of 100 total points

echo "🚀 AWS IAM Lab - CLI Automation"
echo "==============================="
echo "Student: [Your Name]"
echo "Assignment: INF 422 Lab 02"
echo ""

# TODO 1: Add error handling
# Implement 'set -e' or proper error checking so script stops if any task fails
# HINT: Use 'set -e' at the beginning to exit on any error
# YOUR CODE HERE:


# TODO 2: Create outputs directory
# Create the outputs/ directory where all generated files will be stored
# HINT: Use 'mkdir -p outputs' to create directory if it doesn't exist
# YOUR CODE HERE:


# TODO 3: Verify AWS CLI is configured
# Check that AWS CLI is properly configured before running tasks
# HINT: Use 'aws sts get-caller-identity' to test AWS access
# Display account info to user and exit if not configured
# YOUR CODE HERE:


echo "Starting lab automation tasks..."
echo ""

# TODO 4: Execute Task 1 - Explore IAM
# Run the task1-explore-iam.sh script
# Check if it completed successfully before continuing
# Print success/failure message
# HINT: Use './task1-explore-iam.sh' and check return code with $?
echo "▶️ Executing Task 1: Explore IAM..."
# YOUR CODE HERE:


echo ""

# TODO 5: Execute Task 2 - Assign Users  
# Run the task2-assign-users.sh script
# Check if it completed successfully before continuing
# Print success/failure message
echo "▶️ Executing Task 2: Assign Users to Groups..."
# YOUR CODE HERE:


echo ""

# TODO 6: Execute Task 3 - Test Permissions
# Run the task3-test-permissions.sh script  
# Check if it completed successfully before continuing
# Print success/failure message
echo "▶️ Executing Task 3: Test Permissions..."
# YOUR CODE HERE:


echo ""

# TODO 7: Generate Lab Summary Report
# Create a comprehensive summary file: outputs/lab-summary.md
# Include: completion time, tasks completed, files generated, student info
# HINT: Use 'cat > filename << EOF' for multi-line file creation
echo "📊 Generating Lab Summary Report..."
# YOUR CODE HERE:


# TODO 8: Display completion status
# Show user what files were generated and next steps
# List contents of outputs/ directory
# Provide instructions for submission
echo ""
echo "🎉 Lab automation completed!"
echo ""
echo "Generated files:"
# YOUR CODE HERE: List files in outputs/ directory


echo ""
echo "Next steps:"
echo "1. Review all generated reports in outputs/ directory"
echo "2. Update documentation in documentation/ directory"  
echo "3. Commit and push to GitHub repository"
echo "4. Submit repository URL via Moodle"
