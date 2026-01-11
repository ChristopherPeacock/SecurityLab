# File Enumeration Lab Setup

## 🎯 Purpose

This repository contains tools for practicing file enumeration and keyword-based search techniques in a controlled lab environment. Perfect for security testing, red team exercises, and blue team detection validation.

## 📋 Lab Setup Instructions

### Prerequisites

- Windows 10/11 machine (physical or VM)
- PowerShell 5.1 or higher
- Administrator privileges (optional - scripts work without elevation)

### Recommended Lab Environments

#### Option 1: Windows Sandbox (Recommended for Testing)

- **Pros**: Isolated, disposable, clean slate every restart
- **Cons**: Requires Windows 10/11 Pro/Enterprise
- **Setup**: Enable Windows Sandbox in Windows Features

#### Option 2: Virtual Machine

- **Pros**: Persistent, customizable, can snapshot
- **Cons**: Requires VM software (VirtualBox, VMware, Hyper-V)
- **Setup**: Create a Windows 10/11 VM with at least 2GB RAM

#### Option 3: Physical Windows Machine

- **Pros**: Real-world performance, no virtualization overhead
- **Cons**: Less isolated, requires cleanup
- **Setup**: Use a dedicated test machine or create a restore point

---

## 🚀 Quick Start

### Step 1: Deploy Dummy Files (Target Machine)

On the **target** Windows machine (Sandbox, VM, or physical):

1. Open PowerShell (no admin required)
2. Navigate to this directory:

   ```powershell
   cd C:\Path\To\SearchScript
   ```

3. Run the deployment script:

   ```powershell
   .\Deploy-DummyFiles.ps1
   ```

This creates **5 random .txt files** with:

- ✅ Random locations across Documents, Downloads, ProgramData, Temp, etc.
- ✅ Random nested subfolder depths (0-3 levels)
- ✅ 2 files guaranteed to contain the keyword **"confidential"**
- ✅ Randomized filenames using GUIDs
- ✅ Safe, local-only, no persistence

### Step 2: Run File Enumeration

Compile and run your enumeration tool:

```powershell
# Compile the C# tool
csc /out:FileEnum.exe FileEnumeration.cs

# Run file enumeration
.\FileEnum.exe
```

### Step 3: Validate Results

Your enumeration tool should:

- Discover all 5 deployed files
- Identify the 2 files containing "confidential"
- Report file paths, sizes, and keyword matches

---

## 🧪 What Gets Deployed

The `Deploy-DummyFiles.ps1` script creates realistic dummy files:

| File Content Type | Contains "confidential"? | Purpose |
|-------------------|-------------------------|---------|
| Meeting summary | ❌ | Noise file (false negative test) |
| System checklist | ❌ | Noise file (false negative test) |
| Archived project docs | ✅ | Target file (true positive) |
| Finance notes | ✅ | Target file (true positive) |
| Personal task list | ❌ | Noise file (false negative test) |

**Randomization:**

- Files are shuffled before deployment
- Locations are randomly selected
- Subfolders are randomly generated with GUID-based names
- Filenames use random GUID prefixes

---

## 🔁 Repeatable Testing

### Windows Sandbox Workflow (Auto-Cleanup)

1. Start Windows Sandbox
2. Copy this folder into the Sandbox
3. Run `Deploy-DummyFiles.ps1`
4. Test your enumeration tool
5. Close Sandbox (everything is wiped automatically)

### VM/Physical Machine Workflow

1. Take a snapshot/restore point (optional)
2. Run `Deploy-DummyFiles.ps1`
3. Test your enumeration tool
4. Run cleanup script (see below) OR restore snapshot

---

## 🧹 Cleanup Script

To remove all deployed files (if you need to reset without restarting):

```powershell
# TODO: Create Remove-DummyFiles.ps1 that tracks and removes deployed files
# For now, manually delete or use Windows Sandbox for auto-cleanup
```

**Manual Cleanup Locations:**

- `%USERPROFILE%\Documents\data_*`
- `%USERPROFILE%\Downloads\data_*`
- `%PUBLIC%\Documents\data_*`
- `C:\ProgramData\data_*`
- `%TEMP%\data_*`

---

## 🛡️ Safety Notes

✅ **Safe Practices:**

- No network activity
- No registry modifications
- No persistence mechanisms
- No privilege escalation
- Only creates .txt files in user-accessible locations

⚠️ **Considerations:**

- Files are created with user-level permissions
- Some locations (like `C:\ProgramData`) may require admin rights
- Always test in isolated environments first

---

## 📊 Testing Scenarios

### Scenario 1: Basic Keyword Search

- **Objective**: Find files containing "confidential"
- **Expected Results**: 2 matches
- **Validation**: Manual verification of file content

### Scenario 2: Recursive Directory Enumeration

- **Objective**: Discover all .txt files in common directories
- **Expected Results**: 5 files found
- **Validation**: Count matches deployment script output

### Scenario 3: Performance Testing

- **Objective**: Measure scan time across multiple directories
- **Expected Results**: Sub-second completion on modern hardware
- **Validation**: Time the enumeration process

### Scenario 4: False Positive Detection

- **Objective**: Ensure non-matching files aren't flagged
- **Expected Results**: Only 2 files flagged as containing "confidential"
- **Validation**: Zero false positives in results

---

## 🔧 Customization

Edit `Deploy-DummyFiles.ps1` to adjust:

**File Count:**

```powershell
# Add more templates to $fileTemplates array
```

**Search Locations:**

```powershell
$basePaths = @(
    "$env:USERPROFILE\Custom\Path",
    # Add your own paths here
)
```

**Keywords:**

```powershell
# Modify file templates to include different sensitive terms
# Examples: "password", "secret", "private", "api_key"
```

**Subfolder Depth:**

```powershell
$depth = Get-Random -Minimum 0 -Maximum 4  # Change max depth here
```

---

## 📚 Additional Resources

- [Windows Sandbox Documentation](https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-overview)
- [PowerShell Security Best Practices](https://learn.microsoft.com/en-us/powershell/scripting/security/overview)
- [File System Enumeration Techniques](https://attack.mitre.org/techniques/T1083/)

---

## 🤝 Contributing

Found a bug? Have an improvement? Submit an issue or pull request!

---

## ⚖️ Disclaimer

**FOR EDUCATIONAL AND AUTHORIZED TESTING ONLY**

This tool is provided for:

- Security research
- Authorized penetration testing
- Blue team detection development
- Red team training exercises

**Always obtain proper authorization before testing on systems you do not own.**

---

## 📝 License

Use responsibly. Test ethically. Learn continuously.
