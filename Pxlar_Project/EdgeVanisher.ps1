# ====================================================
#      PXLAR EDGE VANISHER - SURGICAL REMOVAL
# ====================================================

Write-Host "----------------------------------------------------" -ForegroundColor Yellow
Write-Host "   Edge Vanisher: Permanent Uninstallation Tool" -ForegroundColor Yellow
Write-Host "----------------------------------------------------" -ForegroundColor Yellow

# 1. Terminate Edge Processes
Write-Host "[1/7] Terminating Edge processes..." -ForegroundColor Cyan
$processes = Get-Process | Where-Object { $_.Name -like "*edge*" }
if ($processes) {
    $processes | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "Successfully stopped all Edge processes." -ForegroundColor Green
}

# 2. Uninstall Edge via Setup.exe (The "Force" Method)
Write-Host "[2/7] Searching for Edge Installer..." -ForegroundColor Cyan
$edgePath = Get-ChildItem -Path "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\*\Installer\setup.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
if ($edgePath) {
    Write-Host "Installer found. Running force-uninstall..." -ForegroundColor Yellow
    Start-Process -FilePath $edgePath.FullName -ArgumentList "--uninstall --system-level --verbose-logging --force-uninstall" -Wait
    Write-Host "Official uninstaller command executed." -ForegroundColor Green
}

# 3. Clean Edge Registry Keys
Write-Host "[3/7] Cleaning Registry entries..." -ForegroundColor Cyan
$edgeRegKeys = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update",
    "HKLM:\SOFTWARE\Microsoft\EdgeUpdate",
    "HKCU:\Software\Microsoft\Edge",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Edge"
)
foreach ($key in $edgeRegKeys) {
    if (Test-Path $key) {
        Remove-Item -Path $key -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Removed Key: $key" -ForegroundColor Green
    }
}

# 4. Remove EdgeUpdate Services
Write-Host "[4/7] Deleting Edge services..." -ForegroundColor Cyan
$services = @("edgeupdate", "edgeupdatem", "MicrosoftEdgeElevationService")
foreach ($service in $services) {
    if (Get-Service -Name $service -ErrorAction SilentlyContinue) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        & sc.exe delete $service | Out-Null
        Write-Host "Service '$service' deleted." -ForegroundColor Green
    }
}

# 5. Refresh Windows Explorer
Write-Host "[5/7] Refreshing Explorer..." -ForegroundColor Cyan
Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
Start-Process explorer

# 6. Create Protective "Vaccine" Folders
Write-Host "[6/7] Locking Edge folders to prevent re-install..." -ForegroundColor Cyan
$protectiveFolders = @(
    "${env:ProgramFiles(x86)}\Microsoft\Edge",
    "${env:ProgramFiles(x86)}\Microsoft\EdgeCore"
)

$systemSid = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-18") # SYSTEM

foreach ($folder in $protectiveFolders) {
    if (-not (Test-Path $folder)) { New-Item -Path $folder -ItemType Directory -Force | Out-Null }
    
    try {
        $acl = Get-Acl $folder
        $acl.SetAccessRuleProtection($true, $false) # Disable inheritance
        $denyRule = New-Object System.Security.AccessControl.FileSystemAccessRule($systemSid, "FullControl", "ContainerInherit,ObjectInherit", "None", "Deny")
        $acl.AddAccessRule($denyRule)
        Set-Acl $folder $acl
        Write-Host "Folder $folder is now LOCKED." -ForegroundColor Green
    } catch {
        Write-Host "Could not lock $folder (already locked or in use)." -ForegroundColor Gray
    }
}

Write-Host "`n[DONE] Edge has been vanished from the system." -ForegroundColor Green