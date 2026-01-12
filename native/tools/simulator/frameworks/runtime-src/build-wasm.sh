#!/bin/bash

# WebAssembly build script for Cocos Simulator
# Make sure you have Emscripten SDK installed and activated

set -e

# Check if emscripten is available
if ! command -v emcc &> /dev/null; then
    echo "Error: Emscripten not found. Please install and activate the Emscripten SDK."
    echo "Visit: https://emscripten.org/docs/getting_started/downloads.html"
    exit 1
fi

# Create build directory
BUILD_DIR="build-wasm"
if [ -d "$BUILD_DIR" ]; then
    echo "Cleaning existing build directory..."
    rm -rf "$BUILD_DIR"
fi

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Copy the WebAssembly specific CMakeLists.txt
cp ../CMakeLists-wasm.txt ./CMakeLists.txt

# Configure with Emscripten
echo "Configuring WebAssembly build..."
emcmake cmake . \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE="$EMSCRIPTEN/cmake/Modules/Platform/Emscripten.cmake"

# Build
echo "Building WebAssembly..."
emmake make -j$(nproc)

echo "Build completed! Output files are in $BUILD_DIR/"
echo "You can serve the files using a local HTTP server:"
echo "  cd $BUILD_DIR && python3 -m http.server 8080"
echo "Then open http://localhost:8080/SimulatorApp.html in your browser"