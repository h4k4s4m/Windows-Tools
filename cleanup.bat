@echo off
:: Title of the window
title Windows Maintenance Script

echo ===========================
echo Starting Maintenance Tasks
echo ===========================

:: Task 1: Empty Recycle Bin
echo Emptying Recycle Bin...
pwsh -command "Clear-RecycleBin -Force"
echo Recycle Bin emptied!

:: Task 2: Clear Temporary Files
echo Clearing Temporary Files...
del /s /q "%TEMP%\*" >nul
rd /s /q "%TEMP%" >nul
echo Temporary Files Cleared!

:: Task 3: Clear Prefetch Files
echo Clearing Prefetch Files...
del /s /q C:\Windows\Prefetch\* >nul
echo Prefetch Files Cleared!

:: Task 4: Run Disk Cleanup
echo Running Disk Cleanup...
cleanmgr /sagerun:1
echo Disk Cleanup Completed!

:: Task 5: Run Disk Defragmentation
echo Running Disk Defragmentation...
defrag C: /O
echo Disk Defragmentation Completed!

:: Task 6: Flush DNS Cache
echo Flushing DNS Cache...
ipconfig /flushdns
echo DNS Cache Flushed!

:: Task 7: Clear Windows Update Cache
echo Clearing Windows Update Cache...
net stop wuauserv
rd /s /q C:\Windows\SoftwareDistribution
net start wuauserv
echo Windows Update Cache Cleared!

:: Task 8: Run System File Checker
echo Running System File Checker (SFC)...
sfc /scannow
echo System File Checker Completed!

:: Task 9: Check Disk Health
echo Checking Disk Health...
chkdsk C:
echo Disk Health Check Completed!

:: Task 10: Check Available Disk Space
echo Checking Available Disk Space...
wmic logicaldisk get size,freespace,caption

:: Task 11: Optimize Windows Update Services
echo Optimizing Windows Update Services...
net stop wuauserv
net start wuauserv
echo Windows Update Services Optimized!

:: Task 12: Restart Explorer (Optional)
:: echo Restarting Explorer...
:: taskkill /f /im explorer.exe
:: start explorer.exe
:: echo Explorer Restarted!

:: Task 13: Reboot System (Optional)
:: echo Restarting System in 30 Seconds...
:: shutdown /r /t 30

echo ===========================
echo All Maintenance Tasks Completed!
echo ===========================

:: Pause to view results
:: pause
