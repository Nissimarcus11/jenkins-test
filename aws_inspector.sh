#!/usr/bin/env bash
function set_up_inspector_sbomgen() {
   #!/usr/bin/env bash
set -euo pipefail

ARCH="amd64"  # x86_64 = amd64
SBOM_URL="https://amazon-inspector-sbomgen.s3.amazonaws.com/latest/linux/${ARCH}/inspector-sbomgen.zip"
INSTALL_DIR="$HOME/bin/amazon_inspector"

echo "Downloading Amazon Inspector SBOM Generator (linux/${ARCH})..."
curl -fsSL "$SBOM_URL" -o inspector-sbomgen.zip

echo "Unzipping..."
unzip -o inspector-sbomgen.zip >/dev/null

echo "Cleaning zip..."
rm inspector-sbomgen.zip

echo "Searching for extracted sbomgen binary..."

# Detect versioned directory (e.g., inspector-sbomgen-1.9.1/linux/amd64)
ROOT_DIR=$(find . -maxdepth 1 -type d -name "inspector-sbomgen-*" | head -n 1)

if [ -z "$ROOT_DIR" ]; then
    echo "ERROR: Could not find extracted inspector-sbomgen-* directory"
    exit 1
fi
echo "Found extracted directory: $ROOT_DIR"
BIN_PATH="$ROOT_DIR/linux/${ARCH}"
echo "Found BIN directory: $BIN_PATH"▐


echo "==============================="

mkdir -p "$INSTALL_DIR"

echo "Installing to $INSTALL_DIR"
mv -f "$BIN_PATH"/* "$INSTALL_DIR/"

chmod -R +x "$INSTALL_DIR"

echo "Cleaning extracted folder..."
rm -rf "$ROOT_DIR"
echo "==============================="Ä
echo "listing installed files:"
ls -ral "$INSTALL_DIR"

echo ""
echo "Installation complete. Version:"
"$INSTALL_DIR/inspector-sbomgen" --version
}
set_up_inspector_sbomgen