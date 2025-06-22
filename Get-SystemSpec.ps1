# Get-SystemSpec.ps1
# Created by Studio Mitsu
# https://github.com/MitsuArchive/PcSpecChecker
# MIT License

param(
    [switch]$Detail
)

$timestampDisplay = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$report = New-Object System.Collections.Generic.List[string]
$report.Add("==== Spec Check Started at $timestampDisplay ====")

$report.Add("== OS / CPU / Memory ==")
$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$ram = [Math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
$report.Add("OS: $($os.Caption) ($($os.OSArchitecture))")
$report.Add("Version: $($os.Version)")
$report.Add("CPU: $($cpu.Name) / Logical Cores: $($cpu.NumberOfLogicalProcessors)")
$report.Add("Total RAM: ${ram} GB")
$report.Add("")

$report.Add("== GPU ==")
$gpuList = Get-CimInstance Win32_VideoController
foreach ($gpu in $gpuList) {
    $vramGB = if ($gpu.AdapterRAM) { [Math]::Round($gpu.AdapterRAM / 1GB, 2) } else { "Unknown" }
    $report.Add("$($gpu.Name) / VRAM: ${vramGB} GB")
}
$report.Add("")

$report.Add("== Disk Info (HDD / SSD / Free Space) ==")
$disks = Get-PhysicalDisk
foreach ($disk in $disks) {
    $sizeGB = [Math]::Round($disk.Size / 1GB, 2)
    $report.Add("$($disk.FriendlyName): $($disk.MediaType) / ${sizeGB} GB")
}
$report.Add("")

$report.Add("== Drive Free Space ==")
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Name -ne 'Temp' } | ForEach-Object {
    $freeGB = [Math]::Round($_.Free / 1GB, 2)
    $usedGB = [Math]::Round($_.Used / 1GB, 2)
    $report.Add("$($_.Name): Used ${usedGB} GB / Free ${freeGB} GB")
}
$report.Add("")

$report.Add("== Virtual Memory (Page File) ==")
$pagefiles = Get-CimInstance Win32_PageFileUsage
foreach ($pf in $pagefiles) {
    $report.Add("$($pf.Name): In Use $($pf.CurrentUsage) MB / Peak $($pf.PeakUsage) MB")
}
$report.Add("")

$report.Add("== System Summary ==")
$info = Get-ComputerInfo | Select-Object CsName, OsName, OsArchitecture, CsTotalPhysicalMemory
$report.Add("Computer Name: " + $info.CsName)
$report.Add("OS: " + $info.OsName)
$report.Add("Architecture: " + $info.OsArchitecture)
$report.Add("Processor: " + $cpu.Name)
$physicalMemoryGB = [Math]::Round($info.CsTotalPhysicalMemory / 1GB, 2)
$report.Add("Total Physical Memory: ${physicalMemoryGB} GB")
$report.Add("")

if ($Detail) {
    $report.Add("== Detailed Hardware Info ==")
    $bios = Get-CimInstance Win32_BIOS
    $report.Add("BIOS Version: $($bios.SMBIOSBIOSVersion)")
    $report.Add("BIOS Manufacturer: $($bios.Manufacturer)")
    $report.Add("BIOS Release Date: $($bios.ReleaseDate)")

    $baseBoard = Get-CimInstance Win32_BaseBoard
    $report.Add("Motherboard Manufacturer: $($baseBoard.Manufacturer)")
    $report.Add("Motherboard Product: $($baseBoard.Product)")

    $tpm = Get-WmiObject -Namespace "Root\\CIMv2\\Security\\MicrosoftTpm" -Class Win32_Tpm -ErrorAction SilentlyContinue
    if ($tpm) {
        $report.Add("TPM Present: Yes")
        $report.Add("TPM Version: $($tpm.SpecVersion)")
    } else {
        $report.Add("TPM Present: No")
    }

    $bitlocker = Get-BitLockerVolume -MountPoint C: -ErrorAction SilentlyContinue
    if ($bitlocker) {
        $report.Add("BitLocker Status (C:): $($bitlocker.VolumeStatus)")
    }

    $firmware = (Get-ComputerInfo).BiosFirmwareType
    $report.Add("Firmware Type: $firmware")
    $report.Add("")
}

$report.Add("==== End ====")
$report.Add("")

Write-Output ($report -join "`r`n")

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
