@echo off
echo ========================================
echo Установка компонентов Visual Studio
echo ========================================
echo.

set "VS_INSTALLER=C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe"
set "INSTALL_PATH=C:\Program Files\Microsoft Visual Studio\18\Community"

if not exist "%VS_INSTALLER%" (
    set "VS_INSTALLER=C:\Program Files\Microsoft Visual Studio\Installer\vs_installer.exe"
)

if not exist "%VS_INSTALLER%" (
    echo ОШИБКА: Visual Studio Installer не найден!
    echo.
    echo Пожалуйста, установите Visual Studio Community 2026 или более новую версию.
    echo Затем установите компоненты вручную через Visual Studio Installer:
    echo 1. Откройте Visual Studio Installer
    echo 2. Нажмите "Изменить" для Visual Studio Community 2026
    echo 3. Установите рабочую нагрузку "Desktop development with C++"
    echo.
    pause
    exit /b 1
)

echo Найден Visual Studio Installer: %VS_INSTALLER%
echo.
echo Установка компонентов...
echo Это может занять некоторое время...
echo.

"%VS_INSTALLER%" modify ^
  --installPath "%INSTALL_PATH%" ^
  --add Microsoft.VisualStudio.Workload.NativeDesktop ^
  --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 ^
  --add Microsoft.VisualStudio.Component.VC.CMake.Project ^
  --add Microsoft.VisualStudio.Component.Windows10SDK ^
  --quiet --norestart

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Успешно! Компоненты установлены.
    echo ========================================
    echo.
    echo Проверьте установку командой: flutter doctor
    echo.
) else (
    echo.
    echo ========================================
    echo Произошла ошибка при установке.
    echo ========================================
    echo.
    echo Попробуйте установить компоненты вручную:
    echo 1. Откройте Visual Studio Installer
    echo 2. Нажмите "Изменить" для Visual Studio Community 2026
    echo 3. Установите рабочую нагрузку "Desktop development with C++"
    echo 4. Убедитесь, что выбраны:
    echo    - MSVC v142 - VS 2019 C++ x64/x86 build tools
    echo    - C++ CMake tools for Windows
    echo    - Windows 10 SDK
    echo.
)

pause

