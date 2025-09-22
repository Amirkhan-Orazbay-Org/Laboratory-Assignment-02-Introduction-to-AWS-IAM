# AWS CLI Commands Reference

## Overview

This document provides a comprehensive reference of AWS CLI commands used in the IAM Laboratory Assignment automation scripts. All commands are organized by functionality and include practical examples.

## Prerequisites

Before using these commands, ensure:
- AWS CLI is installed and configured
- You have appropriate IAM permissions
- You understand the JSON structure of AWS responses

## General Syntax

```bash
aws [global-options] <service> <operation> [options]
```

### Global Options
- `--output` - Output format (json, text, table, yaml)
- `--query` - JMESPath query to filter output
- `--region` - AWS region override
- `--profile` - AWS profile to use

## Identity and Access Management (IAM)

### User Management

#### List Users
```bash
# List all users
aws iam list-users

# List users with specific path prefix
aws iam list-users --path-prefix /lab/

# List users with output formatting
aws iam list-users --output table

# List users with query filtering
aws iam list-users --query 'Users[?contains(UserName, `user-`)]'
```

#### Get User Information
```bash
# Get specific user details
aws iam get-user --user-name user-1

# Get current user (caller identity)
aws sts get-caller-identity

# Get user with specific output format
aws iam get-user --user-name user-1 --output text --query 'User.Arn'
```

#### Create User
```bash
# Create user with default path
aws iam create-user --user-name user-1

# Create user with specific path
aws iam create-user --user-name user-1 --path /lab/

# Create user with tags
aws iam create-user --user-name user-1 --tags Key=Environment,Value=Lab Key=Purpose,Value=Training
```

#### Delete User
```bash
# Delete user (must remove from groups first)
aws iam delete-user --user-name user-1
```

### Group Management

#### List Groups
```bash
# List all groups
aws iam list-groups

# List groups with path prefix
aws iam list-groups --path-prefix /lab/

# List groups with formatting
aws iam list-groups --output table --query 'Groups[*].[GroupName,Path,CreateDate]'
```

#### Get Group Information
```bash
# Get group details and members
aws iam get-group --group-name S3-Support

# Get group details only (no member list)
aws iam get-group --group-name S3-Support --no-paginate

# Get group members only
aws iam get-group --group-name S3-Support --query 'Users[*].UserName' --output text
```

#### Create Group
```bash
# Create group with default path
aws iam create-group --group-name S3-Support

# Create group with specific path
aws iam create-group --group-name S3-Support --path /lab/
```

#### Delete Group
```bash
# Delete group (must detach policies and remove users first)
aws iam delete-group --group-name S3-Support
```

### User-Group Associations

#### Get User's Groups
```bash
# List groups for a user
aws iam get-groups-for-user --user-name user-1

# Get group names only
aws iam get-groups-for-user --user-name user-1 --query 'Groups[*].GroupName' --output text

# Check if user is in specific group
aws iam get-groups-for-user --user-name user-1 --query "Groups[?GroupName=='S3-Support'].GroupName" --output text
```

#### Add User to Group
```bash
# Add user to group
aws iam add-user-to-group --group-name S3-Support --user-name user-1

# Add multiple users to group (using loop)
for user in user-1 user-2; do
    aws iam add-user-to-group --group-name S3-Support --user-name $user
done
```

#### Remove User from Group
```bash
# Remove user from group
aws iam remove-user-from-group --group-name S3-Support --user-name user-1
```

### Policy Management

#### List Policies
```bash
# List AWS managed policies
aws iam list-policies --scope AWS

# List customer managed policies
aws iam list-policies --scope Local

# List policies with filtering
aws iam list-policies --scope AWS --query 'Policies[?contains(PolicyName, `S3`)]'

# List policies with specific max items
aws iam list-policies --scope AWS --max-items 50
```

#### Get Policy Details
```bash
# Get policy information
aws iam get-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Get policy version (document)
aws iam get-policy-version --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess --version-id v1
```

#### Create Custom Policy
```bash
# Create policy from JSON file
aws iam create-policy --policy-name EC2-Admin-Policy --policy-document file://policy.json

# Create policy with inline JSON
aws iam create-policy --policy-name EC2-Admin-Policy --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:*",
            "Resource": "*"
        }
    ]
}'

# Create policy with description
aws iam create-policy \
    --policy-name EC2-Admin-Policy \
    --policy-document file://policy.json \
    --description "Custom policy for EC2 administration"
```

#### Delete Policy
```bash
# Delete customer managed policy
aws iam delete-policy --policy-arn arn:aws:iam::123456789012:policy/EC2-Admin-Policy
```

### Group Policy Attachments

#### List Group Policies
```bash
# List attached managed policies
aws iam list-attached-group-policies --group-name S3-Support

# List inline policies
aws iam list-group-policies --group-name S3-Support

# Get inline policy document
aws iam get-group-policy --group-name S3-Support --policy-name MyInlinePolicy
```

#### Attach Policy to Group
```bash
# Attach AWS managed policy
aws iam attach-group-policy \
    --group-name S3-Support \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Attach customer managed policy
aws iam attach-group-policy \
    --group-name EC2-Admin \
    --policy-arn arn:aws:iam::123456789012:policy/EC2-Admin-Policy
```

#### Detach Policy from Group
```bash
# Detach managed policy
aws iam detach-group-policy \
    --group-name S3-Support \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
```

### User Policy Attachments

#### List User Policies
```bash
# List attached managed policies for user
aws iam list-attached-user-policies --user-name user-1

# List inline policies for user
aws iam list-user-policies --user-name user-1
```

#### Attach Policy to User
```bash
# Attach managed policy to user
aws iam attach-user-policy \
    --user-name user-1 \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
```

#### Detach Policy from User
```bash
# Detach managed policy from user
aws iam detach-user-policy \
    --user-name user-1 \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
```

### Role Management

#### List Roles
```bash
# List all roles
aws iam list-roles

# List roles with path prefix
aws iam list-roles --path-prefix /service-role/

# List roles with filtering
aws iam list-roles --query 'Roles[?contains(RoleName, `EC2`)]'
```

#### Get Role Information
```bash
# Get role details
aws iam get-role --role-name MyRole

# Get role's trust policy
aws iam get-role --role-name MyRole --query 'Role.AssumeRolePolicyDocument'
```

### Permission Testing

#### Simulate Policy
```bash
# Simulate principal policy
aws iam simulate-principal-policy \
    --policy-source-arn arn:aws:iam::123456789012:user/user-1 \
    --action-names s3:GetObject \
    --resource-arns arn:aws:s3:::my-bucket/*

# Simulate with multiple actions
aws iam simulate-principal-policy \
    --policy-source-arn arn:aws:iam::123456789012:user/user-1 \
    --action-names s3:GetObject s3:PutObject \
    --resource-arns arn:aws:s3:::my-bucket/*

# Simulate custom policy
aws iam simulate-custom-policy \
    --policy-input-list file://policy1.json file://policy2.json \
    --action-names ec2:DescribeInstances \
    --resource-arns "*"

# Get evaluation details
aws iam simulate-principal-policy \
    --policy-source-arn arn:aws:iam::123456789012:user/user-1 \
    --action-names s3:GetObject \
    --resource-arns arn:aws:s3:::my-bucket/* \
    --query 'EvaluationResults[0].EvalDecision' \
    --output text
```

## Security Token Service (STS)

### Identity Operations
```bash
# Get caller identity
aws sts get-caller-identity

# Get account ID only
aws sts get-caller-identity --query Account --output text

# Get current user ARN
aws sts get-caller-identity --query Arn --output text
```

## Advanced Query Techniques

### JMESPath Queries

#### Filtering Arrays
```bash
# Filter users by name pattern
aws iam list-users --query 'Users[?starts_with(UserName, `user-`)]'

# Filter policies by name containing text
aws iam list-policies --query 'Policies[?contains(PolicyName, `S3`)]'

# Filter groups created after specific date
aws iam list-groups --query 'Groups[?CreateDate >= `2024-01-01`]'
```

#### Projecting Data
```bash
# Get specific fields from users
aws iam list-users --query 'Users[*].[UserName,CreateDate,Arn]'

# Create custom object structure
aws iam list-users --query 'Users[*].{Name:UserName,Created:CreateDate,ID:UserId}'

# Get nested data
aws iam get-group --group-name S3-Support --query 'Users[*].{Name:UserName,ID:UserId}'
```

#### Combining Operations
```bash
# Get user names from specific group
aws iam get-group --group-name S3-Support --query 'Users[*].UserName' --output text

# Count items
aws iam list-users --query 'length(Users)'

# Sort results
aws iam list-users --query 'Users | sort_by(@, &CreateDate)'
```

### Output Formatting

#### Table Format
```bash
# Display as table
aws iam list-users --output table

# Custom table with specific columns
aws iam list-users --output table --query 'Users[*].[UserName,CreateDate]'
```

#### Text Format
```bash
# Simple text output
aws iam list-users --output text --query 'Users[*].UserName'

# Tab-separated values
aws iam list-users --output text --query 'Users[*].[UserName,CreateDate]'
```

## Error Handling and Debugging

### Common Error Responses
```bash
# AccessDenied
# Insufficient permissions for the operation

# NoSuchEntity
# Requested resource doesn't exist

# EntityAlreadyExists
# Resource already exists (for create operations)

# InvalidInput
# Invalid parameter values
```

### Debugging Commands
```bash
# Enable debug output
aws iam list-users --debug

# Dry run (for supported operations)
aws iam simulate-principal-policy --dry-run

# Verbose output
aws iam list-users --cli-read-timeout 0 --cli-connect-timeout 60
```

### Error Checking in Scripts
```bash
# Check if user exists
if aws iam get-user --user-name user-1 &>/dev/null; then
    echo "User exists"
else
    echo "User does not exist"
fi

# Check command success
if aws iam create-user --user-name user-1; then
    echo "User created successfully"
else
    echo "Failed to create user"
    exit 1
fi
```

## Practical Examples

### Complete User Setup
```bash
# Create user, group, and assign
aws iam create-user --user-name user-1 --path /lab/
aws iam create-group --group-name S3-Support --path /lab/
aws iam attach-group-policy \
    --group-name S3-Support \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
aws iam add-user-to-group --group-name S3-Support --user-name user-1
```

### Bulk Operations
```bash
# Create multiple users
for user in user-1 user-2 user-3; do
    aws iam create-user --user-name $user --path /lab/
done

# Assign multiple users to group
for user in user-1 user-2 user-3; do
    aws iam add-user-to-group --group-name S3-Support --user-name $user
done
```

### Validation Scripts
```bash
# Verify user exists and is in correct group
USER="user-1"
GROUP="S3-Support"

if aws iam get-user --user-name $USER &>/dev/null; then
    if aws iam get-groups-for-user --user-name $USER --query "Groups[?GroupName=='$GROUP']" | grep -q "$GROUP"; then
        echo "✓ $USER is correctly assigned to $GROUP"
    else
        echo "✗ $USER is not in $GROUP"
    fi
else
    echo "✗ $USER does not exist"
fi
```

### JSON Processing with jq
```bash
# Extract specific data
aws iam list-users | jq '.Users[] | select(.UserName | startswith("user-")) | .UserName'

# Create summary report
aws iam list-groups | jq '{
    group_count: (.Groups | length),
    groups: [.Groups[] | {name: .GroupName, path: .Path}]
}'

# Combine multiple API calls
USERS=$(aws iam list-users --query 'Users[*].UserName' --output text)
for user in $USERS; do
    GROUPS=$(aws iam get-groups-for-user --user-name $user --query 'Groups[*].GroupName' --output text)
    echo "$user: $GROUPS"
done
```

## Performance and Rate Limiting

### Rate Limiting Best Practices
```bash
# Add delays between API calls
aws iam create-user --user-name user-1
sleep 1
aws iam create-user --user-name user-2

# Use pagination for large datasets
aws iam list-policies --max-items 100

# Batch operations where possible
# (Group multiple related operations)
```

### Retry Logic
```bash
# Simple retry function
retry_command() {
    local cmd="$1"
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if $cmd; then
            return 0
        else
            echo "Attempt $attempt failed, retrying..."
            sleep $((attempt * 2))
            ((attempt++))
        fi
    done
    
    echo "Command failed after $max_attempts attempts"
    return 1
}

# Usage
retry_command "aws iam create-user --user-name user-1"
```

## Security Best Practices

### Least Privilege Commands
```bash
# Grant minimal required permissions
aws iam attach-group-policy \
    --group-name S3-Support \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Use resource-specific ARNs when possible
aws iam simulate-principal-policy \
    --policy-source-arn arn:aws:iam::123456789012:user/user-1 \
    --action-names s3:GetObject \
    --resource-arns arn:aws:s3:::specific-bucket/*
```

### Credential Management
```bash
# Use named profiles instead of default
aws iam list-users --profile lab-admin

# Verify current credentials
aws sts get-caller-identity
```

---

*This CLI commands reference is part of the AWS IAM Laboratory Assignment automation project. Use these commands as building blocks for your automation scripts while following AWS best practices for security and efficiency.*