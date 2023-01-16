## Get-ScheduledTask -TaskName 'sync-repos-gite-test' | Disable-ScheduledTask
## Get-ScheduledTask -TaskName 'sync-repos-gite-test' | Enable-ScheduledTask
## Get-ScheduledTask -TaskName 'sync-repos-gite-test' | Start-ScheduledTask
## Get-ScheduledTask -TaskName 'sync-repos-gite-test' | Stop-ScheduledTask

$account="localadmin"
$psFilePath =$PSScriptRoot+"\sync-repos.ps1"

## 二选一，TODO


#S4U：不管用户是否登录都要运行 or 最高权限运行
$principal = New-ScheduledTaskPrincipal -UserId $account -LogonType S4U

## 使用最高权限运行选项，将使运行计划任务的账户提升至管理员身份，使其有足够的权限运行任务
# $Params = @{
#     "UserID"    = "NT AUTHORITY\\SYSTEM"
#     "LogonType" = 'ServiceAccount'
#     "RunLevel"  = 'Highest'
#    }
    
#$principal = New-ScheduledTaskPrincipal @Params


$action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"  -Argument "-file $psFilePath"
#每天凌晨2点执行一次，无期限运行。
$trigger = New-ScheduledTaskTrigger -Daily -At 2am
#电源选型设置
$setting = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd

$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $setting -Principal $principal
Write-Host "task:"
Write-Host $task

Register-ScheduledTask -TaskName  "sync-repos-gite-dayly-2am" -InputObject $task

