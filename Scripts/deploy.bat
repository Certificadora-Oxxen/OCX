@set n0kdeploy=1.0
setlocal DisableDelayedExpansion
@echo off

REM Definição do charset
chcp 65001
if errorlevel 1 (
    echo "Falha ao definir o charset para UTF-8."
    pause
    exit /b 1
)

:: Elevar o script para administrador e passar argumentos, evitando loop
:: Verifica se o script está sendo executado como administrador
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Solicitando privilégios de administrador...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~dpnx0 elevated' -Verb RunAs"
)

REM Definição das constantes
set "BUILD_DIR=G:\Meu Drive\Projetos\Herdom\ocx-boitata\Build"
set "BUILD_FILE=Boitata.ocx"
set "REMOTE_TARGET_DIR=\\Hweb\d\OCX"
set "REMOTE_TARGET_FILE=%REMOTE_TARGET_DIR%\Boitata.ocx"
set "REMOTE_HOST=HWEB"
set "REMOTE_USER=Administrador"
set "REMOTE_PASS=C1d2e3@HWEB"

REM Parando o IIS no servidor remoto
echo "Parando o IIS no servidor remoto..."
winrs -r:%REMOTE_HOST% -u:%REMOTE_USER% -p:%REMOTE_PASS% iisreset /stop
if errorlevel 1 (
    echo "Falha ao parar o IIS no servidor remoto."
    pause
    exit /b 1
)

REM Copiando o arquivo OCX compilado para o diretório de destino no servidor remoto
echo "Copiando o arquivo OCX compilado para o servidor remoto..."
copy "%BUILD_DIR%\%BUILD_FILE%" "%REMOTE_TARGET_FILE%"
if errorlevel 1 (
    echo "Falha ao copiar o arquivo OCX para o servidor remoto."
    pause
    exit /b 1
)

REM Registrando o arquivo OCX no servidor remoto
echo "Registrando o arquivo OCX no servidor remoto..."
winrs -r:%REMOTE_HOST% -u:%REMOTE_USER% -p:%REMOTE_PASS% regsvr32 /s "%REMOTE_TARGET_FILE%"
if errorlevel 1 (
    echo "Falha ao registrar o arquivo OCX no servidor remoto."
    pause
    exit /b 1
)

REM Iniciando o IIS no servidor remoto
echo "Iniciando o IIS no servidor remoto..."
winrs -r:%REMOTE_HOST% -u:%REMOTE_USER% -p:%REMOTE_PASS% iisreset /start
if errorlevel 1 (
    echo "Falha ao iniciar o IIS no servidor remoto."
    pause
    exit /b 1
)

echo "Deploy concluído com sucesso!"
pause

endlocal
