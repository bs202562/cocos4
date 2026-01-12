@echo off
REM WebAssembly build script for Cocos Simulator
REM Make sure you have Emscripten SDK installed and activated

setlocal enabledelayedexpansion

REM Check if emscripten is available
where emcc >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: Emscripten not found. Please install and activate the Emscripten SDK.
    echo Visit: https://emscripten.org/docs/getting_started/downloads.html
    exit /b 1
)

REM Create build directory
set BUILD_DIR=build-wasm
if exist "%BUILD_DIR%" (
    echo Cleaning existing build directory...
    rmdir /s /q "%BUILD_DIR%"
)

mkdir "%BUILD_DIR%"
cd "%BUILD_DIR%"

REM Copy the WebAssembly specific CMakeLists.txt
copy ..\CMakeLists-wasm.txt .\CMakeLists.txt

REM Configure with Emscripten
echo Configuring WebAssembly build...
call emcmake cmake . ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_TOOLCHAIN_FILE="%EMSCRIPTEN%/cmake/Modules/Platform/Emscripten.cmake"

if %errorlevel% neq 0 (
    echo CMake configuration failed!
    exit /b 1
)

REM Build
echo Building WebAssembly...
call emmake make

if %errorlevel% neq 0 (
    echo Build failed!
    exit /b 1
)

echo Build completed! Output files are in %BUILD_DIR%/
echo You can serve the files using a local HTTP server:
echo   cd %BUILD_DIR% ^&^& python -m http.server 8080
echo Then open http://localhost:8080/SimulatorApp.html in your browser

pause