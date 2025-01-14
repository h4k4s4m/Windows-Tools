# Load the Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Robocopy GUI"
$form.Width = 920
$form.Height = 820
$form.StartPosition = "CenterScreen"

# Label for Source Directory
$labelSource = New-Object System.Windows.Forms.Label
$labelSource.Text = "Source Directory:"
$labelSource.Top = 20
$labelSource.Left = 20
$labelSource.AutoSize = $true

# TextBox for Source Directory
$textSource = New-Object System.Windows.Forms.TextBox
$textSource.Width = 600
$textSource.Top = 20
$textSource.Left = 150

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

# Label for Destination Directory
$labelDest = New-Object System.Windows.Forms.Label
$labelDest.Text = "Destination Directory:"
$labelDest.Top = 60
$labelDest.Left = 20
$labelDest.AutoSize = $true

# TextBox for Destination Directory
$textDest = New-Object System.Windows.Forms.TextBox
$textDest.Width = 600
$textDest.Top = 60
$textDest.Left = 150

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

# Checkbox for Mirroring
$checkMirror = New-Object System.Windows.Forms.CheckBox
$checkMirror.Text = "Mirror (Delete files in destination that are not in source)"
$checkMirror.Top = 100
$checkMirror.Left = 20
$checkMirror.AutoSize = $true

# Checkbox for Multi-threading
$checkMultiThread = New-Object System.Windows.Forms.CheckBox
$checkMultiThread.Text = "Enable Multi-threading"
$checkMultiThread.Top = 130
$checkMultiThread.Left = 20
$checkMultiThread.AutoSize = $true

# NumericUpDown for Multi-threading Value
$numericThreads = New-Object System.Windows.Forms.NumericUpDown
$numericThreads.Top = 130
$numericThreads.Left = 250
$numericThreads.Width = 60
$numericThreads.Value = 8
$numericThreads.Minimum = 1
$numericThreads.Maximum = 128

# Checkbox for Logging
$checkLog = New-Object System.Windows.Forms.CheckBox
$checkLog.Text = "Enable Logging"
$checkLog.Top = 20
$checkLog.Left = 770
$checkLog.AutoSize = $true

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

# Additional Checkbox Options
$checkRestart = New-Object System.Windows.Forms.CheckBox
$checkRestart.Text = "Restartable Mode (/Z)"
$checkRestart.Top = 220
$checkRestart.Left = 20
$checkRestart.AutoSize = $true
$checkRestart.Checked = $true

$checkPurge = New-Object System.Windows.Forms.CheckBox
$checkPurge.Text = "Purge Extra Files (/PURGE)"
$checkPurge.Top = 250
$checkPurge.Left = 20
$checkPurge.AutoSize = $true

$checkMove = New-Object System.Windows.Forms.CheckBox
$checkMove.Text = "Move Files (/MOVE)"
$checkMove.Top = 280
$checkMove.Left = 20
$checkMove.AutoSize = $true

$checkVerify = New-Object System.Windows.Forms.CheckBox
$checkVerify.Text = "Verify Copied Files (/V)"
$checkVerify.Top = 310
$checkVerify.Left = 20
$checkVerify.AutoSize = $true

$checkNoPrompt = New-Object System.Windows.Forms.CheckBox
$checkNoPrompt.Text = "No Prompt on Overwrite (/NP)"
$checkNoPrompt.Top = 340
$checkNoPrompt.Left = 20
$checkNoPrompt.AutoSize = $true

$checkXD = New-Object System.Windows.Forms.CheckBox
$checkXD.Text = "Exclude Directories (Use /XD)"
$checkXD.Top = 370
$checkXD.Left = 20
$checkXD.AutoSize = $true

# Button to Execute Robocopy
$buttonRun = New-Object System.Windows.Forms.Button
$buttonRun.Text = "Run Robocopy"
$buttonRun.Top = 410
$buttonRun.Left = 20
$buttonRun.Width = 150
$buttonRun.Height = 40

# Output TextBox
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.Width = 880
$outputBox.Height = 300
$outputBox.Top = 470
$outputBox.Left = 20

# Button click event to execute Robocopy
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

    try {
        $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $command" -NoNewWindow -PassThru -Wait
        $outputBox.AppendText("Robocopy completed with exit code: $($process.ExitCode)`n")
    } catch {
        $outputBox.AppendText("Error running Robocopy: $_`n")
    }
})

# Add controls to the form
$form.Controls.Add($labelSource)
$form.Controls.Add($textSource)
$form.Controls.Add($buttonBrowseSource)
$form.Controls.Add($labelDest)
$form.Controls.Add($textDest)
$form.Controls.Add($buttonBrowseDest)
$form.Controls.Add($checkMirror)
$form.Controls.Add($checkMultiThread)
$form.Controls.Add($numericThreads)
$form.Controls.Add($checkLog)
$form.Controls.Add($textLogPath)
$form.Controls.Add($buttonBrowseLog)
$form.Controls.Add($checkSubdirs)
$form.Controls.Add($checkRestart)
$form.Controls.Add($checkPurge)
$form.Controls.Add($checkMove)
$form.Controls.Add($checkVerify)
$form.Controls.Add($checkNoPrompt)
$form.Controls.Add($checkXD)
$form.Controls.Add($buttonRun)
$form.Controls.Add($outputBox)

# Show the form
$form.ShowDialog()
