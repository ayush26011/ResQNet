#!/bin/bash
# Exit on error
set -e

# Base directory setup
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "$SCRIPT_DIR" )"
JNILIBS_DIR="$PROJECT_ROOT/llm_llamacpp/android/src/main/jniLibs"

echo "=================================================="
echo "Downloading prebuilt llama.cpp libraries for Android..."
echo "Project Root: $PROJECT_ROOT"
echo "Target Dir:   $JNILIBS_DIR"
echo "=================================================="

# Create target directories
mkdir -p "$JNILIBS_DIR/arm64-v8a"
mkdir -p "$JNILIBS_DIR/x86_64"

# Create a temporary directory for downloads
TEMP_DIR=$(mktemp -d)
echo "Created temp directory: $TEMP_DIR"

# Download & extract arm64-v8a
echo "Downloading arm64-v8a libraries..."
curl -L "https://github.com/brynjen/dart-llm/releases/download/v0.1.0/llm_llamacpp-v0.1.0-android-arm64-v8a.zip" -o "$TEMP_DIR/arm64.zip"
echo "Extracting arm64-v8a libraries..."
unzip -o "$TEMP_DIR/arm64.zip" -d "$TEMP_DIR/arm64"
# Copy all .so files
cp "$TEMP_DIR"/arm64/*.so "$JNILIBS_DIR/arm64-v8a/"

# Download & extract x86_64
echo "Downloading x86_64 libraries..."
curl -L "https://github.com/brynjen/dart-llm/releases/download/v0.1.0/llm_llamacpp-v0.1.0-android-x86_64.zip" -o "$TEMP_DIR/x64.zip"
echo "Extracting x86_64 libraries..."
unzip -o "$TEMP_DIR/x64.zip" -d "$TEMP_DIR/x64"
# Copy all .so files
cp "$TEMP_DIR"/x64/*.so "$JNILIBS_DIR/x86_64/"

# Copy libomp.so from NDK if available
NDK_DIR="$HOME/Library/Android/sdk/ndk"
if [ -d "$NDK_DIR" ]; then
    echo "Locating libomp.so in NDK..."
    LATEST_NDK=$(ls -vd "$NDK_DIR"/*/ 2>/dev/null | tail -n1)
    if [ -n "$LATEST_NDK" ]; then
        echo "Found NDK path: $LATEST_NDK"
        ARM64_OMP=$(find "$LATEST_NDK" -path "*/aarch64/libomp.so" -print -quit)
        if [ -n "$ARM64_OMP" ]; then
            echo "Copying arm64 libomp.so: $ARM64_OMP"
            cp "$ARM64_OMP" "$JNILIBS_DIR/arm64-v8a/"
        fi
        X64_OMP=$(find "$LATEST_NDK" -path "*/x86_64/libomp.so" -print -quit)
        if [ -n "$X64_OMP" ]; then
            echo "Copying x86_64 libomp.so: $X64_OMP"
            cp "$X64_OMP" "$JNILIBS_DIR/x86_64/"
        fi
    fi
fi

# Clean up
rm -rf "$TEMP_DIR"

echo "=================================================="
echo "✓ Native libraries downloaded and placed successfully"
echo "=================================================="
