# Скрипт для установки необходимых компонентов Visual Studio для сборки Flutter Windows приложений

Write-Host "Проверка Visual Studio Installer..." -ForegroundColor Cyan

$vsInstallerPath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vs_installer.exe"
if (-not (Test-Path $vsInstallerPath)) {
    $vsInstallerPath = "${env:ProgramFiles}\Microsoft Visual Studio\Installer\vs_installer.exe"
}

if (-not (Test-Path $vsInstallerPath)) {
    Write-Host "Ошибка: Visual Studio Installer не найден!" -ForegroundColor Red
    Write-Host "Пожалуйста, установите Visual Studio Community 2026 или более новую версию." -ForegroundColor Yellow
    exit 1
}

Write-Host "Найден Visual Studio Installer: $vsInstallerPath" -ForegroundColor Green

# Получаем список установленных продуктов
Write-Host "`nПоиск установленных продуктов Visual Studio..." -ForegroundColor Cyan
$products = & $vsInstallerPath list | Select-String "Community"

if ($products.Count -eq 0) {
    Write-Host "Ошибка: Visual Studio Community не найден!" -ForegroundColor Red
    exit 1
}

# Извлекаем версию продукта (например, 18.0.11222.15)
$productLine = $products[0].Line
$versionMatch = [regex]::Match($productLine, '(\d+\.\d+\.\d+\.\d+)')
if ($versionMatch.Success) {
    $productVersion = $versionMatch.Groups[1].Value
    Write-Host "Найден продукт: Visual Studio Community $productVersion" -ForegroundColor Green
} else {
    Write-Host "Не удалось определить версию продукта. Используем стандартную установку." -ForegroundColor Yellow
    $productVersion = "Community"
}

Write-Host "`nУстановка необходимых компонентов..." -ForegroundColor Cyan
Write-Host "Это может занять некоторое время..." -ForegroundColor Yellow

# Компоненты для установки
$components = @(
    "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",  # MSVC v142 - VS 2019 C++ x64/x86 build tools
    "Microsoft.VisualStudio.Component.VC.CMake.Project",  # C++ CMake tools for Windows
    "Microsoft.VisualStudio.Component.Windows10SDK"        # Windows 10 SDK
)

$componentArgs = $components -join " --add "

# Запускаем установку компонентов
$arguments = "modify --installPath `"C:\Program Files\Microsoft Visual Studio\18\Community`" --add $componentArgs --quiet --norestart"

Write-Host "`nВыполняется команда:" -ForegroundColor Cyan
Write-Host "$vsInstallerPath $arguments" -ForegroundColor Gray

try {
    $process = Start-Process -FilePath $vsInstallerPath -ArgumentList $arguments -Wait -NoNewWindow -PassThru
    
    if ($process.ExitCode -eq 0) {
        Write-Host "`nУспешно! Компоненты установлены." -ForegroundColor Green
        Write-Host "`nПроверьте установку командой: flutter doctor" -ForegroundColor Cyan
    } else {
        Write-Host "`nПроизошла ошибка при установке. Код выхода: $($process.ExitCode)" -ForegroundColor Red
        Write-Host "`nПопробуйте установить компоненты вручную:" -ForegroundColor Yellow
        Write-Host "1. Откройте Visual Studio Installer" -ForegroundColor White
        Write-Host "2. Нажмите 'Изменить' для Visual Studio Community 2026" -ForegroundColor White
        Write-Host "3. Установите рабочую нагрузку 'Desktop development with C++'" -ForegroundColor White
        Write-Host "4. Убедитесь, что выбраны:" -ForegroundColor White
        Write-Host "   - MSVC v142 - VS 2019 C++ x64/x86 build tools" -ForegroundColor White
        Write-Host "   - C++ CMake tools for Windows" -ForegroundColor White
        Write-Host "   - Windows 10 SDK" -ForegroundColor White
    }
} catch {
    Write-Host "`nОшибка при выполнении установки: $_" -ForegroundColor Red
    Write-Host "`nПопробуйте установить компоненты вручную через Visual Studio Installer." -ForegroundColor Yellow
}

