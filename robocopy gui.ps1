# Load the Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Helper functions
function Create-Label {
    param(
        [string]$Text,
        [int]$Top,
        [int]$Left
    )
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Text
    $label.Top = $Top
    $label.Left = $Left
    $label.AutoSize = $true
    return $label
}

function Create-TextBox {
    param(
        [int]$Top,
        [int]$Left
    )
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Width = 600
    $textBox.Top = $Top
    $textBox.Left = $Left
    return $textBox
}

# Main form setup
$form = New-Object System.Windows.Forms.Form
$form.Text = "Robocopy GUI"
$form.Width = 920
$form.Height = 820
$form.StartPosition = "CenterScreen"

# Controls setup
$labelSource = Create-Label -Text "Source Directory:" -Top 20 -Left 20

# TextBox for Source Directory
$textSource = Create-TextBox -Top 20 -Left 150

# Button to Browse Source Directory
$buttonBrowseSource = New-Object System.Windows.Forms.Button
$buttonBrowseSource.Text = "Browse"
$buttonBrowseSource.Top = 20
$buttonBrowseSource.Left = 770
$buttonBrowseSource.Add_Click({
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textSource.Text = $folderDialog.SelectedPath
    }
})
$tooltip = New-Object System.Windows.Forms.ToolTip
$tooltip.SetToolTip($buttonBrowseSource, "Browse for the source directory")

# Label for Destination Directory
$labelDest = Create-Label -Text "Destination Directory:" -Top 60 -Left 20

# TextBox for Destination Directory
$textDest = Create-TextBox -Top 60 -Left 150

# Button to Browse Destination Directory
$buttonBrowseDest = New-Object System.Windows.Forms.Button
$buttonBrowseDest.Text = "Browse"
$buttonBrowseDest.Top = 60
$buttonBrowseDest.Left = 770
$buttonBrowseDest.Add_Click({
    $folderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textDest.Text = $folderDialog.SelectedPath
    }
})
$tooltip.SetToolTip($buttonBrowseDest, "Browse for the destination directory")

# Checkbox for Mirroring
$checkMirror = New-Object System.Windows.Forms.CheckBox
$checkMirror.Text = "Mirror (Delete files in destination that are not in source)"
$checkMirror.Top = 100
$checkMirror.Left = 20
$checkMirror.AutoSize = $true
$tooltip.SetToolTip($checkMirror, "Deletes files in the destination directory that are not present in the source directory.")

# Checkbox for Multi-threading
$checkMultiThread = New-Object System.Windows.Forms.CheckBox
$checkMultiThread.Text = "Enable Multi-threading"
$checkMultiThread.Top = 130
$checkMultiThread.Left = 20
$checkMultiThread.AutoSize = $true
$tooltip.SetToolTip($checkMultiThread, "Enable multi-threading for faster copying.")

# NumericUpDown for Multi-threading Value
$numericThreads = New-Object System.Windows.Forms.NumericUpDown
$numericThreads.Top = 130
$numericThreads.Left = 250
$numericThreads.Width = 60
$numericThreads.Value = 8
$numericThreads.Minimum = 1
$numericThreads.Maximum = 128
$tooltip.SetToolTip($numericThreads, "Set the number of threads to use for multi-threading.")

# Checkbox for Logging
$checkLog = New-Object System.Windows.Forms.CheckBox
$checkLog.Text = "Enable Logging"
$checkLog.Top = 20
$checkLog.Left = 770
$checkLog.AutoSize = $true
$tooltip.SetToolTip($checkLog, "Enable logging of the robocopy operation to a file.")

# TextBox for Log File Path
$textLogPath = New-Object System.Windows.Forms.TextBox
$textLogPath.Width = 600
$textLogPath.Top = 160
$textLogPath.Left = 150
$textLogPath.Enabled = $false

# Button to Browse Log File Path
$buttonBrowseLog = New-Object System.Windows.Forms.Button
$buttonBrowseLog.Text = "Browse"
$buttonBrowseLog.Top = 160
$buttonBrowseLog.Left = 770
$buttonBrowseLog.Enabled = $false
$buttonBrowseLog.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "Log Files (*.log)|*.log|All Files (*.*)|*.*"
    if ($saveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textLogPath.Text = $saveFileDialog.FileName
    }
})
$tooltip.SetToolTip($buttonBrowseLog, "Browse to select the path where the log file should be saved.")

# Enable/Disable log file path based on checkbox
$checkLog.Add_CheckedChanged({
    $textLogPath.Enabled = $checkLog.Checked
    $buttonBrowseLog.Enabled = $checkLog.Checked
})

# Checkbox for Copying Subdirectories
$checkSubdirs = New-Object System.Windows.Forms.CheckBox
$checkSubdirs.Text = "Copy All Subdirectories"
$checkSubdirs.Top = 190
$checkSubdirs.Left = 20
$checkSubdirs.AutoSize = $true
$checkSubdirs.Checked = $true
$tooltip.SetToolTip($checkSubdirs, "Copy all subdirectories, including empty ones.")

# Additional Checkbox Options
$checkRestart = New-Object System.Windows.Forms.CheckBox
$checkRestart.Text = "Restartable Mode (/Z)"
$checkRestart.Top = 220
$checkRestart.Left = 20
$checkRestart.AutoSize = $true
$checkRestart.Checked = $true
$tooltip.SetToolTip($checkRestart, "Puts Robocopy in restartable mode, which is useful for copying large files over unreliable network connections.")

# Checkbox for Purging
$checkPurge = New-Object System.Windows.Forms.CheckBox
$checkPurge.Text = "Purge Extra Files (/PURGE)"
$checkPurge.Top = 250
$checkPurge.Left = 20
$checkPurge.AutoSize = $true
$tooltip.SetToolTip($checkPurge, "Deletes destination files and directories that no longer exist in the source.")

# Checkbox for Moving Files
$checkMove = New-Object System.Windows.Forms.CheckBox
$checkMove.Text = "Move Files (/MOVE)"
$checkMove.Top = 280
$checkMove.Left = 20
$checkMove.AutoSize = $true
$tooltip.SetToolTip($checkMove, "Moves files and directories, and deletes them from the source after copying.")

# Checkbox for Verifying Files
$checkVerify = New-Object System.Windows.Forms.CheckBox
$checkVerify.Text = "Verify Copied Files (/V)"
$checkVerify.Top = 310
$checkVerify.Left = 20
$checkVerify.AutoSize = $true
$tooltip.SetToolTip($checkVerify, "Adds verification to each copied file to ensure it is identical on the destination.")

# Checkbox for No Prompt
$checkNoPrompt = New-Object System.Windows.Forms.CheckBox
$checkNoPrompt.Text = "No Prompt on Overwrite (/NP)"
$checkNoPrompt.Top = 340
$checkNoPrompt.Left = 20
$checkNoPrompt.AutoSize = $true
$tooltip.SetToolTip($checkNoPrompt, "Suppresses the prompt that usually appears before overwriting a file.")

# Checkbox for Exclude Directories
$checkXD = New-Object System.Windows.Forms.CheckBox
$checkXD.Text = "Exclude Directories (Use /XD)"
$checkXD.Top = 370
$checkXD.Left = 20
$checkXD.AutoSize = $true
$tooltip.SetToolTip($checkXD, "Allows you to exclude specific directories from the copy operation.")

# Button to Execute Robocopy
$buttonRun = New-Object System.Windows.Forms.Button
$buttonRun.Text = "Run Robocopy"
$buttonRun.Top = 410
$buttonRun.Left = 20
$buttonRun.Width = 150
$buttonRun.Height = 40
$tooltip.SetToolTip($buttonRun, "Execute the Robocopy command with the selected options.")

# Progress Bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Top = 460
$progressBar.Left = 20
$progressBar.Width = 880
$progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Marquee
$progressBar.MarqueeAnimationSpeed = 30
$progressBar.Visible = $false

# Output TextBox
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.Width = 880
$outputBox.Height = 300
$outputBox.Top = 490
$outputBox.Left = 20

# Functions for settings management
function Save-Settings {
    param(
        [string]$filePath
    )
    $settings = @{
        SourceDirectory = $textSource.Text
        DestinationDirectory = $textDest.Text
        Mirror = $checkMirror.Checked
        MultiThread = $checkMultiThread.Checked
        ThreadCount = $numericThreads.Value
        Logging = $checkLog.Checked
        LogPath = $textLogPath.Text
        Subdirectories = $checkSubdirs.Checked
        Restartable = $checkRestart.Checked
        Purge = $checkPurge.Checked
        Move = $checkMove.Checked
        Verify = $checkVerify.Checked
        NoPrompt = $checkNoPrompt.Checked
        ExcludeDirectories = $checkXD.Checked
    }
    ConvertTo-Json $settings | Out-File -Path $filePath -Force
}

function Load-Settings {
    param(
        [string]$filePath
    )
    try {
        $content = Get-Content -Path $filePath -Raw
        $settings = ConvertFrom-Json $content
        $textSource.Text = $settings.SourceDirectory
        $textDest.Text = $settings.DestinationDirectory
        $checkMirror.Checked = $settings.Mirror
        $checkMultiThread.Checked = $settings.MultiThread
        $numericThreads.Value = $settings.ThreadCount
        $checkLog.Checked = $settings.Logging
        $textLogPath.Text = $settings.LogPath
        $checkSubdirs.Checked = $settings.Subdirectories
        $checkRestart.Checked = $settings.Restartable
        $checkPurge.Checked = $settings.Purge
        $checkMove.Checked = $settings.Move
        $checkVerify.Checked = $settings.Verify
        $checkNoPrompt.Checked = $settings.NoPrompt
        $checkXD.Checked = $settings.ExcludeDirectories
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error loading settings: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}

# Event handlers
$buttonRun.Add_Click({
    $source = $textSource.Text
    $destination = $textDest.Text
    $mirror = if ($checkMirror.Checked) { "/MIR" } else { "" }
    $multiThread = if ($checkMultiThread.Checked) { "/MT:$($numericThreads.Value)" } else { "" }
    $subdirs = if ($checkSubdirs.Checked) { "/E" } else { "" }
    $logFile = if ($checkLog.Checked -and $textLogPath.Text.Length -gt 0) { "/LOG:`"$($textLogPath.Text)`"" } else { "" }
    $restart = if ($checkRestart.Checked) { "/Z" } else { "" }
    $purge = if ($checkPurge.Checked) { "/PURGE" } else { "" }
    $move = if ($checkMove.Checked) { "/MOVE" } else { "" }
    $verify = if ($checkVerify.Checked) { "/V" } else { "" }
    $noPrompt = if ($checkNoPrompt.Checked) { "/NP" } else { "" }
    $xd = if ($checkXD.Checked) { "/XD" } else { "" }

    if ([string]::IsNullOrWhiteSpace($source) -or [string]::IsNullOrWhiteSpace($destination)) {
        [System.Windows.Forms.MessageBox]::Show("Please select both source and destination directories.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    $command = "robocopy `"$source`" `"$destination`" $restart $mirror $multiThread $subdirs $purge $move $verify $noPrompt $xd $logFile"
    $outputBox.Text = "Running: $command`n"
    $progressBar.Visible = $true

    try {
        $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $command" -NoNewWindow -PassThru -Wait
        $outputBox.AppendText("Robocopy completed with exit code: $($process.ExitCode)`n")
    } catch {
        $outputBox.AppendText("Error running Robocopy: $_`n")
    } finally {
        $progressBar.Visible = $false
    }
})

$buttonHelp.Add_Click({
    $message = @"
Robocopy (Robust File Copy) is a powerful command-line utility for copying files and directories. It offers a wide range of options for controlling the copy process, including the ability to preserve file attributes, handle network interruptions, and perform incremental backups.

Key Features:
- Source and Destination Directory Selection: Specify the source and destination directories for the copy operation.
- Mirror:  Deletes files in the destination that are not present in the source.
- Multi-threading: Enables faster copying by using multiple threads.
- Logging: Creates a log file of the copy operation.
- Subdirectory Options: Controls how subdirectories are copied.
- Additional Options: Includes various Robocopy flags for advanced control.

To use this GUI:
1. Enter the source and destination directories.
2. Select the desired options using the checkboxes.
3. Click 'Run Robocopy' to start the copy process.
"@
    [System.Windows.Forms.MessageBox]::Show($message, "Help", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})

# Add controls to form
$form.Controls.AddRange(@(
    $labelSource,
    $textSource,
    $buttonBrowseSource,
    $labelDest,
    $textDest,
    $buttonBrowseDest,
    $checkMirror,
    $checkMultiThread,
    $numericThreads,
    $checkLog,
    $textLogPath,
    $buttonBrowseLog,
    $checkSubdirs,
    $checkRestart,
    $checkPurge,
    $checkMove,
    $checkVerify,
    $checkNoPrompt,
    $checkXD,
    $buttonRun,
    $progressBar,
    $outputBox
))

# Show the form
$form.ShowDialog()
