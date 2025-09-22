# INF 422 Laboratory Assignment 02
# Cloud Security Fundamentals & IAM Configuration

**Student Name:** [Your Full Name]  
**Student ID:** [Your Student ID]  
**GitHub Username:** [Your GitHub Username]  
**Assignment Due:** End of Week 3

## Assignment Overview

This repository contains AWS CLI implementations of the AWS Academy "Introduction to AWS IAM" guided lab tasks. All console-based operations from the guided lab have been recreated using bash scripts and AWS CLI commands.

## Required Deliverables

| Script | Points | Description |
|--------|--------|-------------|
| `iam-lab-automation.sh` | 40 | Master script that runs all tasks |
| `task1-explore-iam.sh` | 20 | Explore users, groups, and policies |
| `task2-assign-users.sh` | 20 | Assign users to groups per business scenario |
| `task3-test-permissions.sh` | 10 | Test and verify permissions |
| Documentation | 10 | README and implementation guides |
| **Total** | **100** | **Complete lab automation** |

## Repository Structure

```
├── iam-lab-automation.sh          # Master script (40 points)
├── task1-explore-iam.sh           # Task 1: Exploration (20 points)
├── task2-assign-users.sh          # Task 2: User assignments (20 points)
├── task3-test-permissions.sh      # Task 3: Permission testing (10 points)
├── outputs/                       # Generated output files
│   ├── user-groups-report.json    # Task 1 findings
│   ├── assignment-log.txt         # Task 2 operations log
│   ├── permission-test-results.txt # Task 3 test results
│   └── lab-summary.md             # Master script summary
├── documentation/
│   ├── implementation-guide.md    # Your implementation approach
│   └── cli-commands-used.md       # AWS CLI commands reference
└── README.md                      # This file
```

## Business Scenario

Your scripts must implement this enterprise scenario from the AWS Academy lab:

- **user-1** → **S3-Support** group (Storage administration role)
- **user-2** → **EC2-Support** group (EC2 infrastructure support role) 
- **user-3** → **EC2-Admin** group (EC2 administrative role)

## TODO: Complete Implementation

### Before You Start
- [ ] Complete AWS Academy "Introduction to AWS IAM" guided lab using console
- [ ] Understand what each task accomplishes
- [ ] Have AWS Academy Learner Lab access ready
- [ ] Understand the business scenario requirements

### Implementation Tasks
- [ ] **Master Script**: Implement `iam-lab-automation.sh` (40 points)
- [ ] **Task 1**: Implement `task1-explore-iam.sh` (20 points)  
- [ ] **Task 2**: Implement `task2-assign-users.sh` (20 points)
- [ ] **Task 3**: Implement `task3-test-permissions.sh` (10 points)
- [ ] **Documentation**: Complete implementation guide (10 points)

### Testing Requirements
- [ ] All scripts execute without errors in AWS Academy Learner Lab
- [ ] All required output files are generated in `outputs/` directory  
- [ ] Master script successfully runs all task scripts in sequence
- [ ] Business scenario is properly implemented (users assigned to correct groups)
- [ ] Permission testing demonstrates group access works correctly

## Execution Instructions

### Step 1: Make Scripts Executable
```bash
chmod +x *.sh
```

### Step 2: Test AWS CLI Configuration
```bash
aws sts get-caller-identity
```

### Step 3: Run Master Script  
```bash
./iam-lab-automation.sh
```

### Step 4: Verify Results
```bash
ls -la outputs/
```

## AWS CLI Commands You'll Need

Your implementation should use these AWS CLI commands:

**IAM User/Group Management:**
- `aws iam list-users`
- `aws iam list-groups` 
- `aws iam get-group --group-name [GROUP]`
- `aws iam add-user-to-group --user-name [USER] --group-name [GROUP]`
- `aws iam get-groups-for-user --user-name [USER]`

**Policy Inspection:**
- `aws iam list-attached-group-policies --group-name [GROUP]`
- `aws iam list-group-policies --group-name [GROUP]`

**Permission Testing:**
- `aws s3 ls`
- `aws ec2 describe-instances --region us-east-1`

**Utility:**
- `aws sts get-caller-identity`

## Expected Output Files

Your scripts must generate these files in the `outputs/` directory:

1. **user-groups-report.json** - Complete IAM analysis from Task 1
2. **assignment-log.txt** - User assignment operations log from Task 2  
3. **permission-test-results.txt** - Permission testing results from Task 3
4. **lab-summary.md** - Overall lab completion summary from master script

## Submission Requirements

- [ ] All scripts implemented and tested
- [ ] All output files generated correctly
- [ ] Documentation completed  
- [ ] Repository committed and pushed to GitHub
- [ ] GitHub repository URL submitted via Moodle assignment

## TODO: Update These Sections After Implementation

### Implementation Notes
[Document your approach, challenges, and solutions here]

### Testing Results  
[Document your testing process and results here]

### Lessons Learned
[Reflect on what you learned about AWS CLI and IAM]

---

**Course**: INF 422 Cloud Computing Essentials  
**Instructor**: Amirkhan Orazbay  
**Institution**: Suleyman Demirel University

**Assignment Status**: ⏳ In Progress / ✅ Completed
