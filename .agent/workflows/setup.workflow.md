# Workspace Setup Workflow
**Purpose**: Initialize professional workspace structure  
**Version**: 1.0.0  
**Last Updated**: 2025-10-17

---

## Prerequisites
- [ ] User approval obtained
- [ ] ProjectManifest.md reviewed
- [ ] SystemInstructions.md loaded
- [ ] AgentDescriptions.json validated

---

## Phase 0: Meta-Design ✅ COMPLETED

### 0.1 Project Constitution
- [x] Create `.agent/` directory
- [x] Draft ProjectManifest.md
- [x] Define workflow principles

### 0.2 System Instructions
- [x] Create SystemInstructions.md
- [x] Define operational principles
- [x] Document tool usage guidelines

### 0.3 Agent Descriptions
- [x] Create AgentDescriptions.json
- [x] Define capabilities
- [x] Document collaboration protocol

### 0.4 User Approval
- [ ] Present constitution to user
- [ ] Explain optimized workflow
- [ ] Obtain approval to proceed

**Status**: Awaiting user approval

---

## Phase 1: Analysis

### 1.1 Workspace Scan
```yaml
Action: Scan entire C:\devspo structure
Tool: list_dir (recursive)
Output: workspace-structure.txt

Expected:
  - Directory tree
  - File counts per directory
  - Total size estimation
```

### 1.2 Project Classification
```yaml
Action: Identify project types
Tools:
  - file_search: Find project markers (.ahk, .ps1, .md, etc.)
  - grep_search: Search for key patterns
  - semantic_search: Understand project purposes

Output: project-inventory.md

Expected:
  - Project name
  - Technology stack
  - Current status
  - Dependencies
```

### 1.3 Dependency Mapping
```yaml
Action: Identify inter-project dependencies
Tools:
  - grep_search: Find file references
  - semantic_search: Find logical dependencies

Output: dependency-graph.md

Expected:
  - Dependency visualization (Mermaid)
  - Critical paths
  - Isolated projects
```

### 1.4 Analysis Report
```yaml
Action: Consolidate findings
Output: project-structure-analysis.md

Contents:
  1. Executive Summary
  2. Project Inventory
  3. Technology Stack
  4. Dependency Map
  5. Recommendations
```

**Deliverables**:
- [ ] workspace-structure.txt
- [ ] project-inventory.md
- [ ] dependency-graph.md
- [ ] project-structure-analysis.md

---

## Phase 2: Git Foundation

### 2.1 .gitignore Configuration
```yaml
Action: Create comprehensive .gitignore
Based on:
  - AutoHotkey patterns
  - PowerShell patterns
  - Windows system files
  - IDE files (.vscode, etc.)
  - Temporary files
  - Archive directories

Content:
  # Windows
  Thumbs.db
  Desktop.ini
  $RECYCLE.BIN/
  
  # AutoHotkey
  *.exe (except distributed)
  
  # PowerShell
  *.ps1xml
  
  # Archives
  .archive/
  Backup_*/
  
  # IDE
  .vscode-agent/
  
  # Logs
  *.log
```

### 2.2 .gitattributes Configuration
```yaml
Action: Standardize line endings and diff behavior

Content:
  # Auto detect text files
  * text=auto
  
  # Force LF for scripts
  *.sh text eol=lf
  *.ps1 text eol=crlf
  *.ahk text eol=crlf
  
  # Binary files
  *.exe binary
  *.dll binary
```

### 2.3 README.md Creation
```yaml
Action: Create professional README

Structure:
  1. Project Overview
  2. Directory Structure
  3. Getting Started
  4. Project List
  5. Contributing
  6. License
```

### 2.4 Git Initialization
```yaml
Action: Initialize Git repository
Commands:
  1. git init
  2. git config user.name "[User Name]"
  3. git config user.email "[User Email]"

Verification:
  - .git/ directory exists
  - git status works
```

**Deliverables**:
- [ ] .gitignore
- [ ] .gitattributes
- [ ] README.md
- [ ] Git initialized

---

## Phase 3: Intelligent Archive

### 3.1 Archive Target Identification
```yaml
Action: Identify archivable files
Criteria:
  ✅ Include:
     - Files matching *_backup_*
     - Files matching *.bak, *.old, *.tmp
     - Duplicate versions (keep latest)
     - Unused example files
  
  ❌ Exclude:
     - Active project files
     - Unique documents
     - Configuration files
     - Dependencies

Tool: file_search + grep_search
Output: archive-candidates.txt
```

### 3.2 Archive Structure Creation
```yaml
Action: Create archive directory
Structure:
  .archive/
    └── 2025-10-17/
        ├── keyboard-scripts/
        ├── interception/
        └── misc/

Naming: .archive/YYYY-MM-DD/[project-name]/
```

### 3.3 Safe File Migration
```yaml
Action: Move files to archive
Process:
  1. Create target directory
  2. Copy file (verify)
  3. Delete original
  4. Log operation

Safety:
  - Verify copy before delete
  - Maintain relative paths
  - Create migration log

Output: archive-migration.log
```

### 3.4 Verification
```yaml
Action: Verify archive success
Checks:
  1. All candidates moved
  2. No broken dependencies
  3. Active projects functional
  4. Archive structure correct

Output: archive-verification-report.md
```

**Deliverables**:
- [ ] .archive/ directory
- [ ] Files migrated
- [ ] Migration log
- [ ] Verification report

---

## Phase 4: Agent Infrastructure

### 4.1 Workflows Directory ✅ COMPLETED
- [x] Create `.agent/workflows/`
- [x] Add this file (setup.workflow.md)

### 4.2 Maintenance Workflow
```yaml
Action: Create maintenance.workflow.md
Content:
  - Daily checks
  - Weekly reviews
  - Monthly audits
  - Emergency procedures
```

### 4.3 Troubleshooting Guide
```yaml
Action: Create troubleshooting.workflow.md
Content:
  - Common issues
  - Diagnostic procedures
  - Solution templates
  - Escalation paths
```

**Deliverables**:
- [x] workflows/ directory
- [x] maintenance.workflow.md
- [x] troubleshooting.workflow.md

---

## Phase 5: Initial Commit

### 5.1 Stage All Files
```yaml
Command: git add --all
Verification:
  - Check staged files
  - Verify .gitignore working
  - Confirm intentional additions
```

### 5.2 Initial Commit
```yaml
Command: git commit -m "chore: Initial professional workspace setup

- Add .agent/ infrastructure
- Configure Git (.gitignore, .gitattributes)
- Create comprehensive README
- Archive legacy files
- Document workflows

Ref: ProjectManifest.md v1.0.0"

Verification:
  - Commit successful
  - History shows changes
```

### 5.3 GitHub Connection Guide
```yaml
Action: Create github-setup.md
Content:
  1. Create GitHub repository
  2. Add remote
  3. Push initial commit
  4. Configure branch protection
  5. Set up Actions (optional)
```

**Deliverables**:
- [ ] git add executed
- [ ] Initial commit made
- [ ] github-setup.md created

---

## Phase 6: Professional Organization

### 6.1 Naming Convention Audit
```yaml
Action: Review and standardize naming
Rules:
  - Files: kebab-case
  - Directories: lowercase
  - Scripts: PascalCase.ext
  - Japanese: Keep (compatibility)

Tool: file_search patterns
Output: naming-review.md
```

### 6.2 Documentation Structure
```yaml
Action: Organize documentation
Structure:
  docs/
    ├── architecture/
    ├── guides/
    ├── api/
    └── troubleshooting/

Files to organize:
  - README.md (root)
  - CHANGELOG.md
  - CONTRIBUTING.md
  - LICENSE
```

### 6.3 Final Optimization
```yaml
Action: Apply final polish
Tasks:
  - Remove redundant comments
  - Standardize formatting
  - Update all READMEs
  - Check broken links
```

### 6.4 Final Commit
```yaml
Command: git commit -m "chore: Professional organization complete

- Standardize naming conventions
- Organize documentation structure
- Polish code formatting
- Update all references

Project ready for production."

Verification:
  - All changes committed
  - No pending modifications
  - Clean git status
```

**Deliverables**:
- [ ] Naming standardized
- [ ] Documentation organized
- [ ] Final commit made
- [ ] User final approval

---

## Success Criteria

### Technical
- [ ] Git repository initialized
- [ ] All files under version control
- [ ] Archive structure in place
- [ ] Agent infrastructure complete
- [ ] Documentation comprehensive

### Quality
- [ ] No broken dependencies
- [ ] Consistent naming
- [ ] Clear structure
- [ ] Reproducible setup

### Operational
- [ ] User approval obtained
- [ ] Workflows documented
- [ ] Maintenance procedures defined
- [ ] Troubleshooting guides available

---

## Rollback Procedure

If any phase fails:

1. **Stop immediately**
2. **Assess impact**
   - Files modified?
   - Files deleted?
   - Structure changed?

3. **Rollback steps**
   ```bash
   # If Git initialized
   git reset --hard HEAD
   
   # If files archived
   # Restore from .archive/YYYY-MM-DD/
   
   # If structure changed
   # Manual restoration required
   ```

4. **Report to user**
   - What failed
   - Current state
   - Rollback actions taken
   - Recommendations

---

## Next Steps

After completion:
1. Review with user
2. Address any concerns
3. Begin active development
4. Schedule first maintenance review

---

**Workflow Status**: Phase 0 complete, awaiting user approval for Phase 1
