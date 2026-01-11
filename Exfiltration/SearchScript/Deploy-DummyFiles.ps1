# ============================
# Dummy File Deployment Script
# ============================
# Purpose: Deploy realistic dummy files for file enumeration testing
# Environment: Windows Sandbox, VM, or physical Windows machine
# Privileges: No admin required (some paths may fail without elevation)
# ============================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Dummy File Deployment Script" -ForegroundColor Cyan
Write-Host "  Lab Environment Setup" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$basePaths = @(
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Downloads",
    "$env:PUBLIC\Documents",
    "C:\ProgramData",
    "$env:TEMP"
)

$fileTemplates = @(
    @"
Meeting summary – Q4 planning

Attendees:
- Alex
- Jamie
- Chris
- Morgan

Key points discussed:
- Infrastructure upgrade timeline pushed back
- Budget adjustments discussed
"@,

    @"
System verification checklist

Firewall enabled
Disk encryption active
No critical alerts detected
"@,

    @"
Archived project documentation

This folder relates to a legacy migration project.
Some configuration details were marked as confidential
due to contractual obligations.
"@,

    @"
Internal finance notes

These figures are preliminary.
Some sections of this document are confidential
and should not be shared externally.
"@,

    @"
Personal task list

- Update BIOS
- Clear temp files
- Organize folders
"@
)

Write-Host "[*] Preparing to deploy $($fileTemplates.Count) files..." -ForegroundColor Yellow
Write-Host "[*] Target locations: $($basePaths.Count) base paths`n" -ForegroundColor Yellow

# Randomize order
$fileTemplates = $fileTemplates | Get-Random -Count $fileTemplates.Count

$deployedFiles = @()
$successCount = 0
$failCount = 0

for ($i = 0; $i -lt $fileTemplates.Count; $i++) {

    # Pick random base path
    $base = Get-Random -InputObject $basePaths

    # Create random subfolders (0–3 depth)
    $depth = Get-Random -Minimum 0 -Maximum 4
    $currentPath = $base

    for ($d = 0; $d -lt $depth; $d++) {
        $folderName = "data_$([guid]::NewGuid().ToString().Substring(0,6))"
        $currentPath = Join-Path $currentPath $folderName
    }

    try {
        if (-not (Test-Path $currentPath)) {
            New-Item -ItemType Directory -Path $currentPath -Force -ErrorAction Stop | Out-Null
        }

        # Random filename
        $fileName = "file_$([guid]::NewGuid().ToString().Substring(0,8)).txt"
        $filePath = Join-Path $currentPath $fileName

        # Write content
        Set-Content -Path $filePath -Value $fileTemplates[$i] -ErrorAction Stop

        # Check if contains "confidential"
        $hasKeyword = $fileTemplates[$i] -match "confidential"
        $keywordTag = if ($hasKeyword) { "[KEYWORD: confidential]" } else { "" }

        Write-Host "[+] Created: $filePath $keywordTag" -ForegroundColor Green
        
        $deployedFiles += $filePath
        $successCount++
    }
    catch {
        Write-Host "[-] Failed to create file at: $currentPath" -ForegroundColor Red
        Write-Host "    Error: $($_.Exception.Message)" -ForegroundColor Red
        $failCount++
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Deployment Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Successfully deployed: $successCount files" -ForegroundColor Green
if ($failCount -gt 0) {
    Write-Host "Failed deployments: $failCount files" -ForegroundColor Red
    Write-Host "Tip: Run as Administrator for access to all paths" -ForegroundColor Yellow
}

Write-Host "`n[*] Files containing 'confidential': 2 (expected)" -ForegroundColor Yellow
Write-Host "[*] Lab environment ready for enumeration testing`n" -ForegroundColor Green

# Optional: Export deployed file list for cleanup
$logPath = Join-Path $PSScriptRoot "deployed-files.log"
$deployedFiles | Out-File -FilePath $logPath -Encoding UTF8
Write-Host "[+] Deployed file list saved to: $logPath" -ForegroundColor Cyan
Write-Host "    (Use this for manual cleanup if needed)`n" -ForegroundColor Cyan
