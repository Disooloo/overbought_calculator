# Установка компонентов Visual Studio для сборки Windows приложения

## Проблема
Flutter требует следующие компоненты Visual Studio для сборки Windows приложений:
- MSVC v142 - VS 2019 C++ x64/x86 build tools
- C++ CMake tools for Windows  
- Windows 10 SDK

## Решение 1: Через Visual Studio Installer (Рекомендуется)

1. Откройте **Visual Studio Installer** (найдите в меню Пуск)
2. Найдите **Visual Studio Community 2026** и нажмите кнопку **"Изменить"**
3. В списке рабочих нагрузок выберите **"Desktop development with C++"**
4. В правой панели убедитесь, что выбраны следующие компоненты:
   - ✅ **MSVC v142 - VS 2019 C++ x64/x86 build tools** (или более новая версия)
   - ✅ **C++ CMake tools for Windows**
   - ✅ **Windows 10 SDK** (или Windows 11 SDK)
5. Нажмите **"Изменить"** и дождитесь завершения установки
6. После установки выполните: `flutter doctor` для проверки

## Решение 2: Через командную строку

Откройте PowerShell от имени администратора и выполните:

```powershell
& "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" modify `
  --installPath "C:\Program Files\Microsoft Visual Studio\18\Community" `
  --add Microsoft.VisualStudio.Workload.NativeDesktop `
  --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
  --add Microsoft.VisualStudio.Component.VC.CMake.Project `
  --add Microsoft.VisualStudio.Component.Windows10SDK `
  --quiet --norestart
```

## После установки

Выполните проверку:
```bash
flutter doctor
```

Затем попробуйте собрать приложение:
```bash
flutter build windows --release
```

Готовый файл будет находиться в: `build\windows\x64\runner\Release\overbought_calculator.exe`

