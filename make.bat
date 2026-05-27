@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

set "OUT_NAME=CraftTechLauncher-v2.exe"
set "PROJ_ROOT=%~dp0"
cd /d "%PROJ_ROOT%"
set "GCC=%PROJ_ROOT%tools\mingw64\bin\gcc.exe"
set "GPP=%PROJ_ROOT%tools\mingw64\bin\g++.exe"
set "WINDRES=%PROJ_ROOT%tools\mingw64\bin\windres.exe"

if not exist "build" mkdir "build"
del /q build\*.o >nul 2>nul

echo [1/4] 编译 C 脊椎 (Win64)...
"%GCC%" -m64 -c src\main.c -o build\main.o -I"./include"

echo [2/4] 编译 C++ UI 模块 (Win64)...
for /r src\ui %%f in (*.cpp) do (
    "%GPP%" -m64 -c "%%f" -o build\%%~nf.o -I"./include"
)

echo [3/4] 处理logo图标资源...

pushd src
"..\\tools\\mingw64\\bin\\windres.exe" resource.rc -o "..\\build\\resource.o"
popd

set "RES_OBJ="
if exist "build\resource.o" set "RES_OBJ=build\resource.o"

echo [4/4] 正在缝合生成 %OUT_NAME%...
"%GPP%" -m64 build\main.o build\gui.o %RES_OBJ% -o "%OUT_NAME%" -mwindows -lgdi32 -luser32 -lcomctl32

if exist "%OUT_NAME%" (
    echo ========================================
    echo   构建成功: %OUT_NAME%
    echo   如果图标没出来，请检查 app.ico 是否为标准格式。
    echo ========================================
)
pause