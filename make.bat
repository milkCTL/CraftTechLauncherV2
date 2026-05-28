@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

set "OUT_NAME=CraftTechLauncher-v2.exe"
set "PROJ_ROOT=%~dp0"
cd /d "%PROJ_ROOT%"
set "GCC=%PROJ_ROOT%tools\mingw64\bin\gcc.exe"
set "GPP=%PROJ_ROOT%tools\mingw64\bin\g++.exe"
set "WINDRES=%PROJ_ROOT%tools\mingw64\bin\windres.exe"
set "NASM=%PROJ_ROOT%tools\nasm-3.01\nasm.exe"

if not exist "build" mkdir "build"
del /q build\*.o >nul 2>nul

echo [1/5] 编译底层汇编内核 (Win64)...
if exist "src\asm\renderer.asm" (
    "%NASM%" -f win64 src\asm\renderer.asm -o build\renderer.o
) else (
    echo 未找到 asm\renderer.asm，跳过汇编编译。
)

echo [2/5] 编译 C 脊椎 (Win64)...
"%GCC%" -m64 -c src\main.c -o build\main.o -I"./include"

echo [3/5] 编译 C++ UI 模块 (Win64)...
for /r src\ui %%f in (*.cpp) do (
    "%GPP%" -m64 -c "%%f" -o build\%%~nf.o -I"./include"
)

echo [4/5] 处理 logo 图标资源...
pushd src
"..\\tools\\mingw64\\bin\\windres.exe" resource.rc -o "..\\build\\resource.o"
popd
set "LINK_OBJECTS=build\main.o build\gui.o"
if exist "build\renderer.o" set "LINK_OBJECTS=!LINK_OBJECTS! build\renderer.o"
if exist "build\resource.o" set "LINK_OBJECTS=!LINK_OBJECTS! build\resource.o"
echo [5/5] 正在缝合生成 %OUT_NAME%...
"%GPP%" -m64 !LINK_OBJECTS! -o "%OUT_NAME%" -mwindows -lgdi32 -luser32 -lcomctl32

if exist "%OUT_NAME%" (
    echo ========================================
    echo   构建成功: %OUT_NAME%
    echo ========================================
)
pause
