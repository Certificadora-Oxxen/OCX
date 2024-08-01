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

REM Definição das constantes
set "PROJECT_FILE=Boitata.dpr"
set "PROJECT_DIR=G:\Meu Drive\Projetos\Herdom\ocx-boitata\Ocx"
set "COMPILER_COMMAND=DCC32 -B %PROJECT_FILE%"

REM Mover para o diretório do projeto
cd /d "%PROJECT_DIR%"
if errorlevel 1 (
    echo "Não foi possível acessar o diretório %PROJECT_DIR%. Verifique o caminho e tente novamente."
    pause
    exit /b 1
)

REM Verificar se o arquivo do projeto existe
if not exist "%PROJECT_FILE%" (
    echo "O arquivo de projeto %PROJECT_FILE% não foi encontrado no diretório %PROJECT_DIR%."
    pause
    exit /b 1
)

REM Executar o comando de compilação
echo "Iniciando a compilação do projeto..."
%COMPILER_COMMAND%

REM Verificar se a compilação foi bem-sucedida
if errorlevel 0 (
    echo "Compilação concluída com sucesso!"
) else (
    echo "Erro durante a compilação. Verifique os detalhes acima para mais informações."
)

REM Pausar para ver o resultado
pause

endlocal
