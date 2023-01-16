
dir
Write-Output (Get-Location).Path
$nowTime = get-date -format "yyyy-MM-dd_HH-mm-sss"
$synclogPath = $PSScriptRoot+"\_temp\_logs\sync-"+$nowTime+".log"
$errorReposlogPath = $PSScriptRoot+"\_temp\_logs\errorRepos-"+$nowTime+".log"
$errorRepos = @("test","test2")

Write-Output $synclogPath

Write-Output "---DEBUG---,$nowTime,sync start" | Out-File -FilePath $synclogPath -Append
type $synclogPath -Last 2

Write-Output "`n---DEBUG---,syncerror repos saved to: $errorReposlogPath" | Out-File -FilePath $synclogPath -Append
type $synclogPath -Last 2

Write-Output $errorRepos | Out-File -FilePath $errorReposlogPath -Append
