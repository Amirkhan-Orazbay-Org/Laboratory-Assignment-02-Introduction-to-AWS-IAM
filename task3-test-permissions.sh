#!/bin/bash
# task3-test-permissions.sh - Permission Inheritance Testing
# INF 422 Laboratory Assignment 02 - Task 3
# Student: [Your Name]
# Points: 10 out of 100 total

# TASK DESCRIPTION:
# Test and verify IAM permissions work as expected
# Since AWS Academy doesn't allow user switching, test the services that groups should access
# Document what each group can do based on their attached policies

echo "🧪 TASK 3: Testing User Permissions via CLI"
echo "============================================"

# TODO 1: Set up results file and error handling
# Create results file: outputs/permission-test-results.txt
# Add proper error handling for this script
# YOUR CODE HERE:


echo "🔍 Testing permission scenarios based on group assignments..."
echo ""

# TODO 2: Test S3 Access (S3-Support group permissions)
# The S3-Support group should have access to S3 services
# Test: aws s3 ls (list S3 buckets)
# Document: Whether S3 access works and what buckets are visible
echo "📋 Test 1: S3 Access Permissions (S3-Support group)"
echo "Expected: Should be able to list S3 buckets"

# YOUR CODE HERE:
# - Test S3 bucket listing: aws s3 ls
# - Check if command succeeds or fails  
# - Log results to permission-test-results.txt
# - Display results to user


echo ""

# TODO 3: Test EC2 Read Access (EC2-Support group permissions)  
# The EC2-Support group should have read-only access to EC2
# Test: aws ec2 describe-instances --region us-east-1
# Document: Whether EC2 read access works and what instances are visible
echo "📋 Test 2: EC2 Read Access (EC2-Support group)"
echo "Expected: Should be able to view EC2 instances"

# YOUR CODE HERE:
# - Test EC2 instance listing: aws ec2 describe-instances --region us-east-1
# - Check if command succeeds or fails
# - Count total instances found
# - Show any running instances
# - Log results to permission-test-results.txt
# - Display results to user


echo ""

# TODO 4: Test EC2 Admin Access (EC2-Admin group permissions)
# The EC2-Admin group should have administrative access to EC2
# Test: Check for instances that could be managed (but don't actually stop them)
# Document: What administrative capabilities are available
echo "📋 Test 3: EC2 Administrative Access (EC2-Admin group)" 
echo "Expected: Should have instance management capabilities"

# YOUR CODE HERE:
# - List running instances that could be managed
# - Test describe-instances with admin-level queries
# - Document administrative capabilities (without actually stopping instances)
# - Log findings to permission-test-results.txt  
# - Display results to user


echo ""

# TODO 5: Test Permission Boundaries
# Demonstrate the principle of least privilege
# Show how each group only has access to their designated services
echo "📋 Test 4: Permission Boundaries (Least Privilege)"
echo "Expected: Each group limited to their designated services"

# YOUR CODE HERE:
# - Document that S3-Support has S3 but NOT EC2 admin access
# - Document that EC2-Support has EC2 read but NOT S3 or admin access
# - Document that EC2-Admin has EC2 admin access
# - Explain how this demonstrates least privilege principle
# - Log boundary analysis to permission-test-results.txt


echo ""

# TODO 6: Generate comprehensive test summary
# Create summary section in results file with:
# - All tests performed
# - Results of each test
# - Business scenario verification
# - Key findings about permission inheritance
echo "📊 Generating Test Summary..."

# YOUR CODE HERE:
# - Add comprehensive summary to permission-test-results.txt
# - Include test date, account info, and all findings
# - Document how the tests verify the business scenario works
# - Show that user-group assignments enable correct permissions


echo ""
echo "✅ Task 3 completed!"
echo "📄 Detailed results saved to: outputs/permission-test-results.txt"
echo ""
echo "🔍 Permission Testing Summary:"
echo "   🪣 S3 Access: [YOUR RESULT HERE]"
echo "   🖥️  EC2 Read Access: [YOUR RESULT HERE]"  
echo "   🔧 EC2 Admin Access: [YOUR RESULT HERE]"
echo "   🔒 Permission Boundaries: [YOUR ANALYSIS HERE]"
