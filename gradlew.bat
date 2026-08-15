@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "APP_HOME=%~dp0"
set "WRAPPER_DIR=%APP_HOME%gradle\wrapper"
set "PROPERTIES_FILE=%WRAPPER_DIR%\gradle-wrapper.properties"

if not exist "%PROPERTIES_FILE%" (
    echo ERROR: No se encontro %PROPERTIES_FILE%.
    exit /b 1
)

set "DIST_URL="
for /f "tokens=1,* delims==" %%A in ('findstr /b "distributionUrl=" "%PROPERTIES_FILE%"') do set "DIST_URL=%%B"

if not defined DIST_URL (
    echo ERROR: No se encontro distributionUrl en gradle-wrapper.properties.
    exit /b 1
)

set "GRADLE_VERSION=8.14.5"
set "CACHE_ROOT=%USERPROFILE%\.gradle\wrapper\dists\gradle-%GRADLE_VERSION%"
set "INSTALL_DIR=%CACHE_ROOT%\gradle-%GRADLE_VERSION%"
set "GRADLE_HOME=%INSTALL_DIR%"

if exist "%GRADLE_HOME%\bin\gradle.bat" goto RUN_GRADLE

set "ZIP_FILE=%CACHE_ROOT%\gradle-%GRADLE_VERSION%-bin.zip"
if not exist "%CACHE_ROOT%" mkdir "%CACHE_ROOT%"

echo Gradle %GRADLE_VERSION% no esta instalado localmente.
echo Descargando Gradle desde:
echo %DIST_URL%
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri 'https://services.gradle.org/distributions/gradle-8.14.5-bin.zip' -OutFile '%ZIP_FILE%'"
if errorlevel 1 (
    echo.
    echo ERROR: No se pudo descargar Gradle.
    echo Verifica tu conexion a Internet y vuelve a ejecutar:
    echo .\gradlew.bat bootRun
    exit /b 1
)

if exist "%INSTALL_DIR%" rmdir /s /q "%INSTALL_DIR%"
echo Extrayendo Gradle...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%CACHE_ROOT%' -Force"
if errorlevel 1 (
    echo ERROR: No se pudo extraer Gradle.
    exit /b 1
)

if not exist "%GRADLE_HOME%\bin\gradle.bat" (
    echo ERROR: La instalacion de Gradle no tiene la estructura esperada.
    exit /b 1
)

:RUN_GRADLE
call "%GRADLE_HOME%\bin\gradle.bat" %*
exit /b %ERRORLEVEL%
