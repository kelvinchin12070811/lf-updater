$prevTitle = $host.UI.RawUI.WindowTitle

$isLFCD = $false
foreach ($arg in $args) {
    if ($arg -match '^-last-dir-path=') { $isLFCD = $true }
}

$host.UI.RawUI.WindowTitle = $isLFCD ? 'LFCD' : 'LF'
&lf.bin.exe '-single' $args
$host.UI.RawUI.WindowTitle = $prevTitle
