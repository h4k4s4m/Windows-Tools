# RoboCopy GUI
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Load XAML
[xml]$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="RoboCopy GUI" Height="600" Width="800" WindowStartupLocation="CenterScreen">
    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- Source and Destination -->
        <Grid Grid.Row="0" Margin="0,0,0,10">
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>

            <Label Grid.Row="0" Grid.Column="0" Content="Source:" Margin="0,0,5,5"/>
            <TextBox Grid.Row="0" Grid.Column="1" Name="txtSource" Margin="0,0,5,5"/>
            <Button Grid.Row="0" Grid.Column="2" Name="btnBrowseSource" Content="Browse" Width="80"/>

            <Label Grid.Row="1" Grid.Column="0" Content="Destination:" Margin="0,0,5,5"/>
            <TextBox Grid.Row="1" Grid.Column="1" Name="txtDestination" Margin="0,0,5,5"/>
            <Button Grid.Row="1" Grid.Column="2" Name="btnBrowseDestination" Content="Browse" Width="80"/>
        </Grid>

        <!-- Options TabControl -->
        <TabControl Grid.Row="1" Name="tabOptions">
            <TabItem Header="Copy Options">
                <ScrollViewer>
                    <StackPanel Margin="10">
                        <GroupBox Header="Directory Options">
                            <StackPanel Margin="5">                                
                                <DockPanel Margin="0,0">
                                    <CheckBox Name="chkLevels" Content="Copy Only Top Levels (/LEV:)" 
                                            ToolTip="Only copy the top n levels of the source directory tree"/>
                                    <TextBox Name="txtLevels" Width="50" Margin="0,0" IsEnabled="{Binding ElementName=chkLevels, Path=IsChecked}"/>
                                </DockPanel>
                                <CheckBox Name="chkSubdirectories" Content="Copy Subdirectories (/S)" 
                                    ToolTip="Copy subdirectories, but not empty ones"/>
                                <CheckBox Name="chkEmptySubdirectories" Content="Copy Empty Subdirectories (/E)"
                                    ToolTip="Copy subdirectories, including empty ones"/>
                                <CheckBox Name="chkMirror" Content="Copy Empty Subdirectories (/MIR)"
                                    ToolTip="Equivalent to /E + /PURGE, removes items in destination that doesn't exist in source"/>

                            </StackPanel>
                        </GroupBox>

                        <GroupBox Header="Copy Mode" Margin="0,10">
                            <StackPanel Margin="5">
                                <CheckBox Name="chkRestartable" Content="Restartable Mode (/Z)"
                                        ToolTip="Copy files in restartable mode"/>
                                <CheckBox Name="chkBackup" Content="Backup Mode (/B)"
                                        ToolTip="Copy files in Backup mode"/>
                                <CheckBox Name="chkRestartableBackup" Content="Restartable + Backup Mode (/ZB)"
                                        ToolTip="Use restartable mode; if access denied use Backup mode"/>
                                <CheckBox Name="chkUnbuffered" Content="Unbuffered I/O (/J)"
                                        ToolTip="Copy using unbuffered I/O (recommended for large files)"/>
                            </StackPanel>
                        </GroupBox>

                        <GroupBox Header="Copy Flags" Margin="0,10">
                            <StackPanel Margin="5">
                                <CheckBox Name="chkData" Content="Data (D)" IsChecked="True"
                                        ToolTip="Copy file data"/>
                                <CheckBox Name="chkAttributes" Content="Attributes (A)" IsChecked="True"
                                        ToolTip="Copy file attributes"/>
                                <CheckBox Name="chkTimestamps" Content="Timestamps (T)" IsChecked="True"
                                        ToolTip="Copy file timestamps"/>
                                <CheckBox Name="chkSecurity" Content="Security (S)"
                                        ToolTip="Copy NTFS ACLs"/>
                                <CheckBox Name="chkOwner" Content="Owner (O)"
                                        ToolTip="Copy owner information"/>
                                <CheckBox Name="chkAuditing" Content="Auditing (U)"
                                        ToolTip="Copy auditing information"/>
                            </StackPanel>
                        </GroupBox>
                    </StackPanel>
                </ScrollViewer>
            </TabItem>

            <TabItem Header="File Selection">
                <ScrollViewer>
                    <StackPanel Margin="10">
                        <GroupBox Header="File Attributes">
                            <StackPanel Margin="5">
                                <CheckBox Name="chkArchive" Content="Copy files with Archive attribute (/A)"
                                        ToolTip="Copy only files with the Archive attribute set"/>
                                <CheckBox Name="chkArchiveAndReset" Content="Copy and Reset Archive attribute (/M)"
                                        ToolTip="Copy only files with the Archive attribute and reset it"/>
                            </StackPanel>
                        </GroupBox>

                        <GroupBox Header="File Age/Size" Margin="0,10">
                            <Grid Margin="5">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="Auto"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Grid.RowDefinitions>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="Auto"/>
                                    <RowDefinition Height="Auto"/>
                                </Grid.RowDefinitions>

                                <CheckBox Grid.Row="0" Grid.Column="0" Name="chkMaxAge" Content="Maximum Age (days):"
                                        ToolTip="Exclude files older than n days"/>
                                <TextBox Grid.Row="0" Grid.Column="1" Name="txtMaxAge" Margin="5,2"
                                        IsEnabled="{Binding ElementName=chkMaxAge, Path=IsChecked}"/>

                                <CheckBox Grid.Row="1" Grid.Column="0" Name="chkMinAge" Content="Minimum Age (days):"
                                        ToolTip="Exclude files newer than n days"/>
                                <TextBox Grid.Row="1" Grid.Column="1" Name="txtMinAge" Margin="5,2"
                                        IsEnabled="{Binding ElementName=chkMinAge, Path=IsChecked}"/>

                                <CheckBox Grid.Row="2" Grid.Column="0" Name="chkMaxSize" Content="Maximum Size (bytes):"
                                        ToolTip="Exclude files bigger than n bytes"/>
                                <TextBox Grid.Row="2" Grid.Column="1" Name="txtMaxSize" Margin="5,2"
                                        IsEnabled="{Binding ElementName=chkMaxSize, Path=IsChecked}"/>

                                <CheckBox Grid.Row="3" Grid.Column="0" Name="chkMinSize" Content="Minimum Size (bytes):"
                                        ToolTip="Exclude files smaller than n bytes"/>
                                <TextBox Grid.Row="3" Grid.Column="1" Name="txtMinSize" Margin="5,2"
                                        IsEnabled="{Binding ElementName=chkMinSize, Path=IsChecked}"/>
                            </Grid>
                        </GroupBox>

                        <GroupBox Header="Exclude Options" Margin="0,10">
                            <StackPanel Margin="5">
                                <CheckBox Name="chkExcludeChanged" Content="Exclude Changed files (/XC)"
                                        ToolTip="Exclude files that have been modified"/>
                                <CheckBox Name="chkExcludeNewer" Content="Exclude Newer files (/XN)"
                                        ToolTip="Exclude files that are newer in the destination"/>
                                <CheckBox Name="chkExcludeOlder" Content="Exclude Older files (/XO)"
                                        ToolTip="Exclude files that are older in the destination"/>
                            </StackPanel>
                        </GroupBox>
                    </StackPanel>
                </ScrollViewer>
            </TabItem>

            <TabItem Header="Retry Options">
                <StackPanel Margin="10">
                    <GroupBox Header="Retry Settings">
                        <Grid Margin="5">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="Auto"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                            </Grid.RowDefinitions>

                            <Label Grid.Row="0" Grid.Column="0" Content="Number of Retries (/R:):"
                                   ToolTip="Number of retries on failed copies"/>
                            <TextBox Grid.Row="0" Grid.Column="1" Name="txtRetries" Text="1000000" Margin="5,2"/>

                            <Label Grid.Row="1" Grid.Column="0" Content="Wait Time (seconds) (/W:):"
                                   ToolTip="Wait time between retries in seconds"/>
                            <TextBox Grid.Row="1" Grid.Column="1" Name="txtWaitTime" Text="30" Margin="5,2"/>
                        </Grid>
                    </GroupBox>

                    <CheckBox Name="chkSaveRetrySettings" Content="Save retry settings in Registry (/REG)"
                            Margin="5,10" ToolTip="Save retry settings as default in Registry"/>
                </StackPanel>
            </TabItem>

            <TabItem Header="Logging Options">
                <ScrollViewer>
                    <StackPanel Margin="10">
                        <GroupBox Header="Output Options">
                            <StackPanel Margin="5">
                                <CheckBox Name="chkListOnly" Content="List Only (/L)"
                                        ToolTip="List files that would be copied without actually copying"/>
                                <CheckBox Name="chkVerbose" Content="Verbose Output (/V)"
                                        ToolTip="Produce verbose output, showing skipped files"/>
                                <CheckBox Name="chkIncludeSourceTimestamp" Content="Include Source Timestamps (/TS)"
                                        ToolTip="Include source file timestamps in the output"/>
                                <CheckBox Name="chkIncludeFullPath" Content="Include Full Paths (/FP)"
                                        ToolTip="Include full path names of files in the output"/>
                            </StackPanel>
                        </GroupBox>

                        <GroupBox Header="Log File" Margin="0,10">
                            <Grid Margin="5">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="Auto"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="Auto"/>
                                </Grid.ColumnDefinitions>

                                <CheckBox Grid.Column="0" Name="chkLogFile" Content="Log to File (/LOG:)"
                                        ToolTip="Output status to log file"/>
                                <TextBox Grid.Column="1" Name="txtLogFile" Margin="5,0"
                                        IsEnabled="{Binding ElementName=chkLogFile, Path=IsChecked}"/>
                                <Button Grid.Column="2" Name="btnBrowseLog" Content="Browse" Width="80"
                                        IsEnabled="{Binding ElementName=chkLogFile, Path=IsChecked}"/>
                            </Grid>
                        </GroupBox>

                        <GroupBox Header="Progress Options" Margin="0,10">
                            <StackPanel Margin="5">
                                <CheckBox Name="chkNoProgress" Content="No Progress (/NP)"
                                        ToolTip="Don't display percentage copied"/>
                                <CheckBox Name="chkShowETA" Content="Show ETA (/ETA)"
                                        ToolTip="Show Estimated Time of Arrival of copied files"/>
                            </StackPanel>
                        </GroupBox>
                    </StackPanel>
                </ScrollViewer>
            </TabItem>

            <TabItem Header="Job Options">
                <StackPanel Margin="10">
                    <GroupBox Header="Job File">
                        <Grid Margin="5">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="Auto"/>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="Auto"/>
                            </Grid.ColumnDefinitions>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="Auto"/>
                            </Grid.RowDefinitions>

                            <Label Grid.Row="0" Grid.Column="0" Content="Job Name:"/>
                            <TextBox Grid.Row="0" Grid.Column="1" Name="txtJobName" Margin="5,2"/>
                            <Button Grid.Row="0" Grid.Column="2" Name="btnBrowseJob" Content="Browse" Width="80"/>

                            <StackPanel Grid.Row="1" Grid.Column="0" Grid.ColumnSpan="3" 
                                      Orientation="Horizontal" Margin="0,10,0,0">
                                <Button Name="btnSaveJob" Content="Save Job" Width="100" Margin="0,0,5,0"/>
                                <Button Name="btnLoadJob" Content="Load Job" Width="100"/>
                            </StackPanel>
                        </Grid>
                    </GroupBox>
                </StackPanel>
            </TabItem>
        </TabControl>

        <!-- Bottom Buttons -->
        <StackPanel Grid.Row="2" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,10,0,0">
            <Button Name="btnSaveConfig" Content="Save Config" Width="100" Margin="0,0,5,0"/>
            <Button Name="btnLoadConfig" Content="Load Config" Width="100" Margin="0,0,5,0"/>
            <Button Name="btnClearConfig" Content="Clear Config" Width="100" Margin="0,0,5,0"/>
            <Button Name="btnCopyCommand" Content="Copy Command" Width="100" Margin="0,0,5,0"/>
            <Button Name="btnRun" Content="Run" Width="100"/>
        </StackPanel>
    </Grid>
</Window>
"@

# Create the window
$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

# Get controls
$btnBrowseSource = $window.FindName("btnBrowseSource")
$btnBrowseDestination = $window.FindName("btnBrowseDestination")
$btnBrowseLog = $window.FindName("btnBrowseLog")
$btnBrowseJob = $window.FindName("btnBrowseJob")
$txtSource = $window.FindName("txtSource")
$txtDestination = $window.FindName("txtDestination")
$btnRun = $window.FindName("btnRun")
$btnCopyCommand = $window.FindName("btnCopyCommand")
$btnSaveConfig = $window.FindName("btnSaveConfig")
$btnLoadConfig = $window.FindName("btnLoadConfig")
$btnClearConfig = $window.FindName("btnClearConfig")
$btnSaveJob = $window.FindName("btnSaveJob")
$btnLoadJob = $window.FindName("btnLoadJob")

# Browse button handlers
$btnBrowseSource.Add_Click({
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        $folderBrowser.Description = "Select Source Directory"
        if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $txtSource.Text = $folderBrowser.SelectedPath
        }
    })

$btnBrowseDestination.Add_Click({
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        $folderBrowser.Description = "Select Destination Directory"
        if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $txtDestination.Text = $folderBrowser.SelectedPath
        }
    })

$btnBrowseLog.Add_Click({
        $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
        $saveDialog.Filter = "Log files (*.log)|*.log|All files (*.*)|*.*"
        $saveDialog.DefaultExt = "log"
        if ($saveDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $window.FindName("txtLogFile").Text = $saveDialog.FileName
        }
    })

$btnBrowseJob.Add_Click({
        $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
        $saveDialog.Filter = "RoboCopy job files (*.rcj)|*.rcj|All files (*.*)|*.*"
        $saveDialog.DefaultExt = "rcj"
        if ($saveDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $window.FindName("txtJobName").Text = $saveDialog.FileName
        }
    })

# Function to build Robocopy command
function Build-RobocopyCommand {
    $command = "robocopy"
    
    # Add source and destination
    if ($txtSource.Text -and $txtDestination.Text) {
        $command += " `"$($txtSource.Text)`" `"$($txtDestination.Text)`""
    }
    
    # Add copy options
    if ($window.FindName("chkSubdirectories").IsChecked) { $command += " /S" }
    if ($window.FindName("chkEmptySubdirectories").IsChecked) { $command += " /E" }
    if ($window.FindName("chkMirror").IsChecked) { $command += " /MIR" }
    if ($window.FindName("chkLevels").IsChecked) { $command += " /LEV:$($window.FindName('txtLevels').Text)" }
    if ($window.FindName("chkRestartable").IsChecked) { $command += " /Z" }
    if ($window.FindName("chkBackup").IsChecked) { $command += " /B" }
    if ($window.FindName("chkRestartableBackup").IsChecked) { $command += " /ZB" }
    if ($window.FindName("chkUnbuffered").IsChecked) { $command += " /J" }
    
    # Build COPY flags
    $copyFlags = ""
    if ($window.FindName("chkData").IsChecked) { $copyFlags += "D" }
    if ($window.FindName("chkAttributes").IsChecked) { $copyFlags += "A" }
    if ($window.FindName("chkTimestamps").IsChecked) { $copyFlags += "T" }
    if ($window.FindName("chkSecurity").IsChecked) { $copyFlags += "S" }
    if ($window.FindName("chkOwner").IsChecked) { $copyFlags += "O" }
    if ($window.FindName("chkAuditing").IsChecked) { $copyFlags += "U" }
    
    if ($copyFlags) {
        $command += " /COPY:$copyFlags"
    }
    
    # Add file selection options
    if ($window.FindName("chkArchive").IsChecked) { $command += " /A" }
    if ($window.FindName("chkArchiveAndReset").IsChecked) { $command += " /M" }
    if ($window.FindName("chkMaxAge").IsChecked) { $command += " /MAXAGE:$($window.FindName('txtMaxAge').Text)" }
    if ($window.FindName("chkMinAge").IsChecked) { $command += " /MINAGE:$($window.FindName('txtMinAge').Text)" }
    if ($window.FindName("chkMaxSize").IsChecked) { $command += " /MAX:$($window.FindName('txtMaxSize').Text)" }
    if ($window.FindName("chkMinSize").IsChecked) { $command += " /MIN:$($window.FindName('txtMinSize').Text)" }
    if ($window.FindName("chkExcludeChanged").IsChecked) { $command += " /XC" }
    if ($window.FindName("chkExcludeNewer").IsChecked) { $command += " /XN" }
    if ($window.FindName("chkExcludeOlder").IsChecked) { $command += " /XO" }
    
    # Add retry options
    $retries = $window.FindName("txtRetries").Text
    $waitTime = $window.FindName("txtWaitTime").Text
    if ($retries) { $command += " /R:$retries" }
    if ($waitTime) { $command += " /W:$waitTime" }
    if ($window.FindName("chkSaveRetrySettings").IsChecked) { $command += " /REG" }
    
    # Add logging options
    if ($window.FindName("chkListOnly").IsChecked) { $command += " /L" }
    if ($window.FindName("chkVerbose").IsChecked) { $command += " /V" }
    if ($window.FindName("chkIncludeSourceTimestamp").IsChecked) { $command += " /TS" }
    if ($window.FindName("chkIncludeFullPath").IsChecked) { $command += " /FP" }
    if ($window.FindName("chkLogFile").IsChecked) {
        $logFile = $window.FindName("txtLogFile").Text
        if ($logFile) { $command += " /LOG:`"$logFile`"" }
    }
    if ($window.FindName("chkNoProgress").IsChecked) { $command += " /NP" }
    if ($window.FindName("chkShowETA").IsChecked) { $command += " /ETA" }
    
    # Add job options
    $jobName = $window.FindName("txtJobName").Text
    if ($jobName) { $command += " /JOB:`"$jobName`"" }
    
    return $command
}

# Run button handler
$btnRun.Add_Click({
        $command = Build-RobocopyCommand
        if (-not $txtSource.Text -or -not $txtDestination.Text) {
            [System.Windows.MessageBox]::Show("Please select both source and destination directories.", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
            return
        }
    
        try {
            Invoke-Expression $command
            [System.Windows.MessageBox]::Show("Copy operation completed successfully!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        }
        catch {
            [System.Windows.MessageBox]::Show("Error executing Robocopy: $_", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
        }
    })

# Copy Command button handler
$btnCopyCommand.Add_Click({
        $command = Build-RobocopyCommand
        [System.Windows.Clipboard]::SetText($command)
        [System.Windows.MessageBox]::Show("Command copied to clipboard!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    })

# Save Config handler
$btnSaveConfig.Add_Click({
        $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
        $saveDialog.Filter = "JSON files (*.json)|*.json|All files (*.*)|*.*"
        $saveDialog.DefaultExt = "json"
    
        if ($saveDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $config = @{
                Source      = $txtSource.Text
                Destination = $txtDestination.Text
                Options     = @{
                    Subdirectories      = $window.FindName("chkSubdirectories").IsChecked
                    EmptySubdirectories = $window.FindName("chkEmptySubdirectories").IsChecked
                    Levels              = @{
                        Enabled = $window.FindName("chkLevels").IsChecked
                        Value   = $window.FindName("txtLevels").Text
                    }
                    Restartable         = $window.FindName("chkRestartable").IsChecked
                    Backup              = $window.FindName("chkBackup").IsChecked
                    RestartableBackup   = $window.FindName("chkRestartableBackup").IsChecked
                    Unbuffered          = $window.FindName("chkUnbuffered").IsChecked
                    CopyFlags           = @{
                        Data       = $window.FindName("chkData").IsChecked
                        Attributes = $window.FindName("chkAttributes").IsChecked
                        Timestamps = $window.FindName("chkTimestamps").IsChecked
                        Security   = $window.FindName("chkSecurity").IsChecked
                        Owner      = $window.FindName("chkOwner").IsChecked
                        Auditing   = $window.FindName("chkAuditing").IsChecked
                    }
                    FileSelection       = @{
                        Archive         = $window.FindName("chkArchive").IsChecked
                        ArchiveAndReset = $window.FindName("chkArchiveAndReset").IsChecked
                        MaxAge          = @{
                            Enabled = $window.FindName("chkMaxAge").IsChecked
                            Value   = $window.FindName("txtMaxAge").Text
                        }
                        MinAge          = @{
                            Enabled = $window.FindName("chkMinAge").IsChecked
                            Value   = $window.FindName("txtMinAge").Text
                        }
                        MaxSize         = @{
                            Enabled = $window.FindName("chkMaxSize").IsChecked
                            Value   = $window.FindName("txtMaxSize").Text
                        }
                        MinSize         = @{
                            Enabled = $window.FindName("chkMinSize").IsChecked
                            Value   = $window.FindName("txtMinSize").Text
                        }
                        ExcludeChanged  = $window.FindName("chkExcludeChanged").IsChecked
                        ExcludeNewer    = $window.FindName("chkExcludeNewer").IsChecked
                        ExcludeOlder    = $window.FindName("chkExcludeOlder").IsChecked
                    }
                    Retry               = @{
                        Retries      = $window.FindName("txtRetries").Text
                        WaitTime     = $window.FindName("txtWaitTime").Text
                        SaveSettings = $window.FindName("chkSaveRetrySettings").IsChecked
                    }
                    Logging             = @{
                        ListOnly               = $window.FindName("chkListOnly").IsChecked
                        Verbose                = $window.FindName("chkVerbose").IsChecked
                        IncludeSourceTimestamp = $window.FindName("chkIncludeSourceTimestamp").IsChecked
                        IncludeFullPath        = $window.FindName("chkIncludeFullPath").IsChecked
                        LogFile                = @{
                            Enabled = $window.FindName("chkLogFile").IsChecked
                            Path    = $window.FindName("txtLogFile").Text
                        }
                        NoProgress             = $window.FindName("chkNoProgress").IsChecked
                        ShowETA                = $window.FindName("chkShowETA").IsChecked
                    }
                    Job                 = @{
                        Name = $window.FindName("txtJobName").Text
                    }
                }
            }
        
            $config | ConvertTo-Json -Depth 10 | Set-Content $saveDialog.FileName
            [System.Windows.MessageBox]::Show("Configuration saved successfully!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        }
    })

# Load Config handler
$btnLoadConfig.Add_Click({
        $openDialog = New-Object System.Windows.Forms.OpenFileDialog
        $openDialog.Filter = "JSON files (*.json)|*.json|All files (*.*)|*.*"
    
        if ($openDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $config = Get-Content $openDialog.FileName | ConvertFrom-Json
        
            $txtSource.Text = $config.Source
            $txtDestination.Text = $config.Destination
        
            # Copy Options
            $window.FindName("chkSubdirectories").IsChecked = $config.Options.Subdirectories
            $window.FindName("chkEmptySubdirectories").IsChecked = $config.Options.EmptySubdirectories
            $window.FindName("chkLevels").IsChecked = $config.Options.Levels.Enabled
            $window.FindName("txtLevels").Text = $config.Options.Levels.Value
            $window.FindName("chkRestartable").IsChecked = $config.Options.Restartable
            $window.FindName("chkBackup").IsChecked = $config.Options.Backup
            $window.FindName("chkRestartableBackup").IsChecked = $config.Options.RestartableBackup
            $window.FindName("chkUnbuffered").IsChecked = $config.Options.Unbuffered
        
            $window.FindName("chkData").IsChecked = $config.Options.CopyFlags.Data
            $window.FindName("chkAttributes").IsChecked = $config.Options.CopyFlags.Attributes
            $window.FindName("chkTimestamps").IsChecked = $config.Options.CopyFlags.Timestamps
            $window.FindName("chkSecurity").IsChecked = $config.Options.CopyFlags.Security
            $window.FindName("chkOwner").IsChecked = $config.Options.CopyFlags.Owner
            $window.FindName("chkAuditing").IsChecked = $config.Options.CopyFlags.Auditing
        
            # File Selection
            $window.FindName("chkArchive").IsChecked = $config.Options.FileSelection.Archive
            $window.FindName("chkArchiveAndReset").IsChecked = $config.Options.FileSelection.ArchiveAndReset
            $window.FindName("chkMaxAge").IsChecked = $config.Options.FileSelection.MaxAge.Enabled
            $window.FindName("txtMaxAge").Text = $config.Options.FileSelection.MaxAge.Value
            $window.FindName("chkMinAge").IsChecked = $config.Options.FileSelection.MinAge.Enabled
            $window.FindName("txtMinAge").Text = $config.Options.FileSelection.MinAge.Value
            $window.FindName("chkMaxSize").IsChecked = $config.Options.FileSelection.MaxSize.Enabled
            $window.FindName("txtMaxSize").Text = $config.Options.FileSelection.MaxSize.Value
            $window.FindName("chkMinSize").IsChecked = $config.Options.FileSelection.MinSize.Enabled
            $window.FindName("txtMinSize").Text = $config.Options.FileSelection.MinSize.Value
            $window.FindName("chkExcludeChanged").IsChecked = $config.Options.FileSelection.ExcludeChanged
            $window.FindName("chkExcludeNewer").IsChecked = $config.Options.FileSelection.ExcludeNewer
            $window.FindName("chkExcludeOlder").IsChecked = $config.Options.FileSelection.ExcludeOlder
        
            # Retry Options
            $window.FindName("txtRetries").Text = $config.Options.Retry.Retries
            $window.FindName("txtWaitTime").Text = $config.Options.Retry.WaitTime
            $window.FindName("chkSaveRetrySettings").IsChecked = $config.Options.Retry.SaveSettings
        
            # Logging Options
            $window.FindName("chkListOnly").IsChecked = $config.Options.Logging.ListOnly
            $window.FindName("chkVerbose").IsChecked = $config.Options.Logging.Verbose
            $window.FindName("chkIncludeSourceTimestamp").IsChecked = $config.Options.Logging.IncludeSourceTimestamp
            $window.FindName("chkIncludeFullPath").IsChecked = $config.Options.Logging.IncludeFullPath
            $window.FindName("chkLogFile").IsChecked = $config.Options.Logging.LogFile.Enabled
            $window.FindName("txtLogFile").Text = $config.Options.Logging.LogFile.Path
            $window.FindName("chkNoProgress").IsChecked = $config.Options.Logging.NoProgress
            $window.FindName("chkShowETA").IsChecked = $config.Options.Logging.ShowETA
        
            # Job Options
            $window.FindName("txtJobName").Text = $config.Options.Job.Name
        
            [System.Windows.MessageBox]::Show("Configuration loaded successfully!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        }
    })

# Clear Config handler
$btnClearConfig.Add_Click({
        $txtSource.Text = ""
        $txtDestination.Text = ""
    
        # Clear Copy Options
        $window.FindName("chkSubdirectories").IsChecked = $false
        $window.FindName("chkEmptySubdirectories").IsChecked = $false
        $window.FindName("chkLevels").IsChecked = $false
        $window.FindName("txtLevels").Text = ""
        $window.FindName("chkRestartable").IsChecked = $false
        $window.FindName("chkBackup").IsChecked = $false
        $window.FindName("chkRestartableBackup").IsChecked = $false
        $window.FindName("chkUnbuffered").IsChecked = $false
    
        $window.FindName("chkData").IsChecked = $true
        $window.FindName("chkAttributes").IsChecked = $true
        $window.FindName("chkTimestamps").IsChecked = $true
        $window.FindName("chkSecurity").IsChecked = $false
        $window.FindName("chkOwner").IsChecked = $false
        $window.FindName("chkAuditing").IsChecked = $false
    
        # Clear File Selection
        $window.FindName("chkArchive").IsChecked = $false
        $window.FindName("chkArchiveAndReset").IsChecked = $false
        $window.FindName("chkMaxAge").IsChecked = $false
        $window.FindName("txtMaxAge").Text = ""
        $window.FindName("chkMinAge").IsChecked = $false
        $window.FindName("txtMinAge").Text = ""
        $window.FindName("chkMaxSize").IsChecked = $false
        $window.FindName("txtMaxSize").Text = ""
        $window.FindName("chkMinSize").IsChecked = $false
        $window.FindName("txtMinSize").Text = ""
        $window.FindName("chkExcludeChanged").IsChecked = $false
        $window.FindName("chkExcludeNewer").IsChecked = $false
        $window.FindName("chkExcludeOlder").IsChecked = $false
    
        # Clear Retry Options
        $window.FindName("txtRetries").Text = "1000000"
        $window.FindName("txtWaitTime").Text = "30"
        $window.FindName("chkSaveRetrySettings").IsChecked = $false
    
        # Clear Logging Options
        $window.FindName("chkListOnly").IsChecked = $false
        $window.FindName("chkVerbose").IsChecked = $false
        $window.FindName("chkIncludeSourceTimestamp").IsChecked = $false
        $window.FindName("chkIncludeFullPath").IsChecked = $false
        $window.FindName("chkLogFile").IsChecked = $false
        $window.FindName("txtLogFile").Text = ""
        $window.FindName("chkNoProgress").IsChecked = $false
        $window.FindName("chkShowETA").IsChecked = $false
    
        # Clear Job Options
        $window.FindName("txtJobName").Text = ""
    
        [System.Windows.MessageBox]::Show("Configuration cleared!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    })

# Save Job handler
$btnSaveJob.Add_Click({
        $jobName = $window.FindName("txtJobName").Text
        if (-not $jobName) {
            [System.Windows.MessageBox]::Show("Please enter a job name.", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
            return
        }
    
        $command = Build-RobocopyCommand
        $command += " /SAVE:$jobName"
    
        try {
            Invoke-Expression $command
            [System.Windows.MessageBox]::Show("Job saved successfully!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        }
        catch {
            [System.Windows.MessageBox]::Show("Error saving job: $_", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
        }
    })

# Load Job handler
$btnLoadJob.Add_Click({
        $jobName = $window.FindName("txtJobName").Text
        if (-not $jobName) {
            [System.Windows.MessageBox]::Show("Please enter a job name.", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
            return
        }
    
        try {
            $command = "robocopy /JOB:$jobName"
            Invoke-Expression $command
            [System.Windows.MessageBox]::Show("Job loaded successfully!", "Success", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        }
        catch {
            [System.Windows.MessageBox]::Show("Error loading job: $_", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
        }
    })

# Show the window
$window.ShowDialog() | Out-Null