# AWS IAM Laboratory Assignment Implementation Guide

## Overview

This implementation guide provides comprehensive documentation for the AWS IAM Laboratory Assignment automation scripts. The lab replicates AWS Academy IAM guided lab tasks using AWS CLI automation instead of console operations.

## Architecture

The automation consists of four main components:

1. **Master Script (`iam-lab-automation.sh`)** - Orchestrates all tasks (40 points)
2. **Task 1 (`task1-explore-iam.sh`)** - IAM resource exploration (20 points)
3. **Task 2 (`task2-assign-users.sh`)** - User and group management (20 points)
4. **Task 3 (`task3-test-permissions.sh`)** - Permission validation (10 points)

## Prerequisites

### System Requirements
- Linux/Unix environment (tested on Ubuntu/Amazon Linux)
- Bash 4.0 or higher
- jq (JSON processor) for data manipulation
- AWS CLI v2 installed and configured

### AWS Requirements
- AWS account with appropriate IAM permissions
- AWS CLI configured with credentials (`aws configure`)
- IAM permissions to:
  - Create/manage IAM users, groups, and policies
  - Simulate IAM policies
  - List IAM resources

### Permission Requirements

The user running these scripts needs the following IAM permissions:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateUser",
                "iam:CreateGroup",
                "iam:CreatePolicy",
                "iam:AttachGroupPolicy",
                "iam:AddUserToGroup",
                "iam:ListUsers",
                "iam:ListGroups",
                "iam:ListRoles",
                "iam:ListPolicies",
                "iam:GetUser",
                "iam:GetGroup",
                "iam:GetGroupsForUser",
                "iam:ListAttachedGroupPolicies",
                "iam:ListGroupPolicies",
                "iam:ListUserPolicies",
                "iam:SimulatePrincipalPolicy",
                "sts:GetCallerIdentity"
            ],
            "Resource": "*"
        }
    ]
}
```

## Installation and Setup

### 1. Clone Repository
```bash
git clone https://github.com/Amirkhan-Orazbay-Org/Laboratory-Assignment-02-Introduction-to-AWS-IAM
cd Laboratory-Assignment-02-Introduction-to-AWS-IAM
```

### 2. Verify Prerequisites
```bash
# Check AWS CLI
aws --version

# Check jq
jq --version

# Check AWS credentials
aws sts get-caller-identity
```

### 3. Make Scripts Executable
```bash
chmod +x *.sh
```

## Usage

### Quick Start
```bash
# Run all tasks automatically
./iam-lab-automation.sh
```

### Individual Task Execution
```bash
# Task 1: Explore IAM resources
./task1-explore-iam.sh

# Task 2: Create users and assign to groups
./task2-assign-users.sh

# Task 3: Test permissions
./task3-test-permissions.sh
```

### Help and Documentation
```bash
# Get help for any script
./iam-lab-automation.sh --help
./task1-explore-iam.sh --help
./task2-assign-users.sh --help
./task3-test-permissions.sh --help
```

## Script Details

### Master Script (iam-lab-automation.sh)

**Purpose**: Orchestrates the execution of all three tasks in sequence.

**Features**:
- Prerequisites checking
- Error handling and logging
- Progress tracking
- Summary reporting
- Colored output for better readability

**Output**:
- `outputs/master-execution.log` - Comprehensive execution log
- Console output with colored status indicators

### Task 1: Explore IAM (task1-explore-iam.sh)

**Purpose**: Discovers and documents existing IAM resources.

**Operations**:
- Lists all IAM users with their group memberships
- Enumerates IAM groups with attached policies
- Discovers IAM roles
- Catalogs IAM policies (AWS managed and customer managed)

**Output**:
- `outputs/user-groups-report.json` - Comprehensive IAM resource report
- `outputs/task1-exploration.log` - Task execution log

**JSON Report Structure**:
```json
{
  "report_metadata": {...},
  "summary": {...},
  "iam_users": {...},
  "iam_groups": {...},
  "iam_roles": {...},
  "iam_policies": {...}
}
```

### Task 2: Assign Users (task2-assign-users.sh)

**Purpose**: Creates lab users, groups, and manages assignments.

**Operations**:
- Creates users: `user-1`, `user-2`, `user-3`
- Creates groups: `S3-Support`, `EC2-Support`, `EC2-Admin`
- Attaches appropriate policies to groups
- Assigns users to groups based on lab requirements

**Group Configurations**:
- **S3-Support**: `AmazonS3ReadOnlyAccess` policy
- **EC2-Support**: `AmazonEC2ReadOnlyAccess` policy
- **EC2-Admin**: Custom `EC2-Admin-Policy` with EC2 management permissions

**User Assignments**:
- `user-1` → `S3-Support` (S3 read-only access)
- `user-2` → `EC2-Support` (EC2 read-only access)
- `user-3` → `EC2-Admin` (EC2 administrative access)

**Output**:
- `outputs/assignment-log.txt` - Detailed assignment operations log
- `outputs/task2-assignment.log` - Task execution log

### Task 3: Test Permissions (task3-test-permissions.sh)

**Purpose**: Validates IAM permissions using AWS Policy Simulator.

**Test Categories**:
1. **Basic IAM Permissions** - User self-service capabilities
2. **S3 Permissions** - Testing user-1 (S3-Support group)
3. **EC2 Support Permissions** - Testing user-2 (EC2-Support group)
4. **EC2 Admin Permissions** - Testing user-3 (EC2-Admin group)
5. **Cross-Service Isolation** - Verifying access boundaries

**Testing Methodology**:
- Uses AWS IAM Policy Simulator for safe testing
- Tests both positive (should allow) and negative (should deny) permissions
- Verifies principle of least privilege
- Confirms proper access boundaries

**Output**:
- `outputs/permission-test-results.txt` - Comprehensive test results
- `outputs/task3-testing.log` - Task execution log

## Directory Structure

```
├── iam-lab-automation.sh       # Master orchestration script (40pts)
├── task1-explore-iam.sh        # IAM exploration script (20pts)
├── task2-assign-users.sh       # User assignment script (20pts)
├── task3-test-permissions.sh   # Permission testing script (10pts)
├── outputs/                    # Generated output files
│   ├── user-groups-report.json
│   ├── assignment-log.txt
│   ├── permission-test-results.txt
│   ├── master-execution.log
│   ├── task1-exploration.log
│   ├── task2-assignment.log
│   └── task3-testing.log
├── documentation/              # Documentation files
│   ├── implementation-guide.md
│   ├── cli-commands-reference.md
│   └── execution-log.md
└── README.md                   # Project overview
```

## Error Handling

### Common Issues and Solutions

1. **AWS CLI Not Configured**
   ```
   Error: AWS credentials not configured
   Solution: Run 'aws configure' and provide credentials
   ```

2. **Insufficient IAM Permissions**
   ```
   Error: AccessDenied when creating users/groups
   Solution: Ensure your IAM user has the required permissions
   ```

3. **jq Not Installed**
   ```
   Error: jq: command not found
   Solution: Install jq (Ubuntu: apt install jq, Amazon Linux: yum install jq)
   ```

4. **Script Permission Denied**
   ```
   Error: Permission denied
   Solution: Run 'chmod +x *.sh' to make scripts executable
   ```

### Error Recovery

The scripts are designed to be idempotent:
- Re-running scripts will not create duplicate resources
- Existing users/groups are detected and skipped
- Failed operations can be retried safely

## Logging and Monitoring

### Log Levels
- **INFO**: Normal operation information
- **WARN**: Non-critical issues or unexpected results
- **ERROR**: Critical errors that may cause task failure

### Log Locations
- Master log: `outputs/master-execution.log`
- Task-specific logs: `outputs/task[1-3]-*.log`
- Assignment operations: `outputs/assignment-log.txt`
- Test results: `outputs/permission-test-results.txt`

### Log Rotation
Logs are overwritten on each script execution. Archive logs manually if historical data is needed.

## Security Considerations

### Best Practices
1. **Least Privilege**: Scripts create users with minimal required permissions
2. **Resource Isolation**: Users are restricted to specific service domains
3. **No Hardcoded Credentials**: Uses AWS CLI configuration
4. **Safe Testing**: Permission testing uses simulation, not actual resource access

### Lab Environment Safety
- Users are created in `/lab/` path for easy identification
- Custom policies are clearly named and scoped
- No production resource modification

## Customization

### Modifying User/Group Configuration

To customize users and groups, edit the arrays in `task2-assign-users.sh`:

```bash
# Modify these arrays as needed
LAB_USERS=("user-1" "user-2" "user-3")
LAB_GROUPS=("S3-Support" "EC2-Support" "EC2-Admin")
```

### Adding New Policies

To add new policies, extend the group creation functions in `task2-assign-users.sh` or create new functions following the existing pattern.

### Custom Testing

To add new permission tests, extend the test functions in `task3-test-permissions.sh`:

```bash
# Add new test function
test_custom_permissions() {
    local user="custom-user"
    # Add test logic here
}

# Call from main function
test_custom_permissions
```

## Troubleshooting

### Debug Mode
Enable debug output by setting:
```bash
set -x  # Add at the beginning of any script
```

### Verbose AWS CLI
Enable AWS CLI debug output:
```bash
export AWS_CLI_LOG_LEVEL=debug
```

### Manual Verification
Verify results using AWS CLI:
```bash
# List created users
aws iam list-users --path-prefix /lab/

# Check user groups
aws iam get-groups-for-user --user-name user-1

# Verify group policies
aws iam list-attached-group-policies --group-name S3-Support
```

## Performance Considerations

### Execution Time
- Task 1: 30-60 seconds (depends on existing resources)
- Task 2: 30-45 seconds
- Task 3: 45-90 seconds (depends on simulation response time)
- Total: 2-4 minutes

### Rate Limiting
AWS IAM API has rate limits. The scripts include appropriate delays and error handling for rate limit scenarios.

### Resource Limits
Be aware of IAM service limits:
- Users per account: 5,000
- Groups per account: 300
- Policies per account: 1,500

## Maintenance

### Cleanup
To remove lab resources:
```bash
# Remove users from groups
aws iam remove-user-from-group --group-name S3-Support --user-name user-1

# Delete users
aws iam delete-user --user-name user-1

# Detach and delete policies
aws iam detach-group-policy --group-name EC2-Admin --policy-arn arn:aws:iam::ACCOUNT:policy/EC2-Admin-Policy
aws iam delete-policy --policy-arn arn:aws:iam::ACCOUNT:policy/EC2-Admin-Policy

# Delete groups
aws iam delete-group --group-name S3-Support
```

### Updates and Versioning
- Keep scripts under version control
- Test changes in non-production environments
- Document any customizations made

## Support and Documentation

### Additional Resources
- [AWS IAM User Guide](https://docs.aws.amazon.com/iam/)
- [AWS CLI IAM Commands](https://docs.aws.amazon.com/cli/latest/reference/iam/)
- [IAM Policy Simulator](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_testing-policies.html)

### Getting Help
1. Check the troubleshooting section
2. Review log files for error details
3. Verify AWS credentials and permissions
4. Consult AWS documentation for service-specific issues

---

*This implementation guide is part of the AWS IAM Laboratory Assignment automation project.*