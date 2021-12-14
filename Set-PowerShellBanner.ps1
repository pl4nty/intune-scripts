$banner = @'                                                                                                                                                                                                                                             
add some ASCII art here
'@

$prefix = 'Clear-Host
Write-Host "'

$content = $prefix + $banner

# Use these instead of $profile to edit profiles multiple shells
$targets = "C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1", "C:\Program Files\PowerShell\7\profile.ps1"
foreach ($target in $targets) {
    if (Test-Path $target -PathType leaf) {
        Add-Content -Path $target -Value $content
    } else {
        New-Item -Path $target -ItemType 'file' -Force -Value $content
    }
}