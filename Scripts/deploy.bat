@echo off

REM Definição do charset
chcp 65001
if errorlevel 1 (
    echo "Falha ao definir o charset para UTF-8."
    pause
    exit /b 1
)

REM Definição do local de trabalho
setlocal

REM Definição das constantes do script
set "HOST_REMOTE=192.168.0.53:5985"
set "USERNAME=Administrador"
set "PASSWORD=C1d2e3@HWEB"

REM Adiciona o host como host confiavel
powershell -Command "Set-Item WSMan:\localhost\Client\TrustedHosts -Value '%HOST_REMOTE%' -Force"

REM Renicia o serviço do WinRM
powershell -Command "Restart-Service WinRM"

REM Realiza um ping como teste
powershell -Command ^
    "$cred = New-Object System.Management.Automation.PSCredential('%USERNAME%', (ConvertTo-SecureString '%PASSyWORD%' -AsPlainText -Force));" ^
    "Invoke-Command -ComputerName '%HOST_REMOTE%' -Credential $cred -ScriptBlock { ping localhost }"

pause

endlocal