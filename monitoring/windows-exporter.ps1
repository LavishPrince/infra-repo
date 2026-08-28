
$Architecture = "amd64" 
$ExporterVersion = "0.31.8"

# Explicitly using your requested root link string
$DownloadRoot = "https://github.com/prometheus-community/windows_exporter/releases/download"
$Url = "$DownloadRoot/v$ExporterVersion/windows_exporter-$ExporterVersion-$Architecture.msi"

$DownloadPath = "windows_exporter.msi"
$ServiceName = "windows_exporter"
$LogPath = "$PSScriptRoot\msi_install.log"

# 1. Check if the service already exists
$Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($Service) {
    Write-Host "windows_exporter is already installed. Status: $($Service.Status)" -ForegroundColor Cyan
    
    # 2. If it exists but is stopped, start it
    if ($Service.Status -ne "Running") {
        Write-Host "Starting stopped windows_exporter service..." -ForegroundColor Yellow
        Start-Service -Name $ServiceName
    }
} else {
    # 3. If it doesn't exist, download and install it cleanly
    Write-Host "windows_exporter not found. Beginning clean installation..." -ForegroundColor Yellow
    
    Write-Host "Downloading version $ExporterVersion ($Architecture)..."
    try {
        Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -ErrorAction Stop
    } catch {
        Write-Error "Failed to download windows_exporter. Verify the version, architecture, and network connection."
        return
    }
    
    Write-Host "Executing MSI Installer..."
    # FIXED: Added /L*V to log any errors to your active monitoring folder
    $Arguments = "/i `"$DownloadPath`" ENABLED_COLLECTORS=`"cpu,logical_disk,net,os,system,memory`" /qn /norestart /L*V `"$LogPath`""
    
    # FIXED: Removed conflicting -Verb parameter to resolve the parameter set error
    Start-Process -FilePath "msiexec.exe" -ArgumentList $Arguments -Wait -NoNewWindow -PassThru
    
    # 4. Wait for Windows Service Registration (Mitigating the MSI Race Condition)
    Write-Host "Waiting for service registration..." -ForegroundColor Yellow
    $RetryCount = 0
    while (-not (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) -and $RetryCount -lt 10) {
        Start-Sleep -Seconds 2
        $RetryCount++
    }
    
    # 5. Verify it was installed and force start it
    if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
        Set-Service -Name $ServiceName -StartupType Automatic
        Start-Service -Name $ServiceName
        Write-Host "Successfully installed and started windows_exporter!" -ForegroundColor Green
        # Clean up log on success
        if (Test-Path $LogPath) { Remove-Item -Path $LogPath -Force }
    } else {
        Write-Error "Installation failed or timed out. Check '$LogPath' for the detailed error."
    }
    
    # 6. Clean up installer
    if (Test-Path $DownloadPath) {
        Remove-Item -Path $DownloadPath -Force
    }
}

