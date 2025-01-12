# Windows 11 Optimization Script
# Created for Low-Spec Machines
# Save this as "Win11_Optimizer.ps1"

# Create Snapshot Directory
$SnapshotDir = "$env:USERPROFILE\win11opt"
if (!(Test-Path $SnapshotDir)) { New-Item -ItemType Directory -Path $SnapshotDir }

# Function to take a snapshot of running services
Function Take-Snapshot {
    $services = Get-Service | Select-Object Name, Status, DisplayName
    $services | Out-File "$SnapshotDir\ServicesSnapshot.txt"
    Write-Host "Services snapshot saved to $SnapshotDir\ServicesSnapshot.txt" -ForegroundColor Green
}

# Function to disable unnecessary services
Function Disable-Services {
    $servicesToDisable = @(
        "DiagTrack",
        "SysMain",
        "wuauserv",
        "XboxGipSvc",
        "XblAuthManager",
        "PrintSpooler",
        "Fax",
        "BluetoothSupport",
        "MapsBroker",
        "wercplsupport"
    )

    foreach ($service in $servicesToDisable) {
        try {
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
            Set-Service -Name $service -StartupType Disabled
            Write-Host "$service disabled successfully." -ForegroundColor Green
        } catch {
            Write-Host "Failed to disable $service." -ForegroundColor Red
        }
    }
}

# Function to remove unnecessary apps
Function Remove-Bloatware {
    $bloatwareApps = @(
        "Microsoft.XboxApp",
        "Microsoft.XboxGameOverlay",
        "Microsoft.WindowsCommunicationsApps",
        "Microsoft.MicrosoftOfficeHub",
        "Microsoft.OneNote",
        "Microsoft.SkypeApp",
        "Microsoft.GetHelp",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo"
    )

    foreach ($app in $bloatwareApps) {
        try {
            Get-AppxPackage -Name $app | Remove-AppxPackage
            Write-Host "$app removed successfully." -ForegroundColor Green
        } catch {
            Write-Host "Failed to remove $app." -ForegroundColor Red
        }
    }
}

# Function to optimize visual effects
Function Optimize-VisualEffects {
    $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
    Set-ItemProperty -Path $RegPath -Name VisualFXSetting -Value 2
    Write-Host "Visual effects optimized." -ForegroundColor Green
}

# Function to manage background apps
Function Disable-BackgroundApps {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1
    Write-Host "Background apps disabled." -ForegroundColor Green
}

# Function to perform optimizations
Function Perform-Optimizations {
    Write-Host "Starting optimizations..." -ForegroundColor Cyan
    Disable-Services
    Remove-Bloatware
    Optimize-VisualEffects
    Disable-BackgroundApps
    Write-Host "All optimizations completed!" -ForegroundColor Green
}

# Main Menu
Function Show-Menu {
    Clear-Host
    Write-Host "============================="
    Write-Host " Windows 11 Optimization Tool"
    Write-Host "============================="
    Write-Host "1. Take Snapshot (Services, Registry)"
    Write-Host "2. Disable Unnecessary Services"
    Write-Host "3. Remove Built-in Bloatware"
    Write-Host "4. Optimize Visual Effects"
    Write-Host "5. Disable Background Apps"
    Write-Host "6. Perform All Optimizations"
    Write-Host "7. Exit"
    Write-Host "============================="
    $choice = Read-Host "Enter your choice (1-7)"

    switch ($choice) {
        1 { Take-Snapshot }
        2 { Disable-Services }
        3 { Remove-Bloatware }
        4 { Optimize-VisualEffects }
        5 { Disable-BackgroundApps }
        6 { Perform-Optimizations }
        7 { Write-Host "Exiting..." -ForegroundColor Yellow; exit }
        default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red }
    }
}

# Run the menu in a loop
while ($true) {
    Show-Menu
}
