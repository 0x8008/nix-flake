#!/usr/bin/env bash
# inject-acpi.sh — copies AML files and injects them into the win11 VM XML
# Run once with: sudo bash inject-acpi.sh
set -euo pipefail

FLAKE_DIR="$(cd "$(dirname "$0")" && pwd)"
AML_DIR="/var/lib/libvirt/acpi"
FAKE_BAT="$AML_DIR/fake_battery.aml"
SPOOF_DEV="$AML_DIR/spoofed_devices.aml"
VM_NAME="win11"
TMP_XML="/tmp/${VM_NAME}-acpi.xml"

echo "==> Copying AML files to $AML_DIR"
mkdir -p "$AML_DIR"
cp "$FLAKE_DIR/acpi/fake_battery.aml"    "$FAKE_BAT"
cp "$FLAKE_DIR/acpi/spoofed_devices.aml" "$SPOOF_DEV"
chmod 644 "$FAKE_BAT" "$SPOOF_DEV"

echo "==> Dumping current VM XML"
virsh --connect qemu:///system dumpxml "$VM_NAME" > "$TMP_XML"

echo "==> Injecting qemu:commandline ACPI tables"
python3 - "$TMP_XML" "$FAKE_BAT" "$SPOOF_DEV" << 'EOF'
import sys, re

xml_path = sys.argv[1]
aml_files = sys.argv[2:]

with open(xml_path, 'r') as f:
    xml = f.read()

# Add qemu namespace to <domain> if not present
if 'xmlns:qemu' not in xml:
    xml = xml.replace(
        '<domain type=',
        '<domain xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0" type=',
        1
    )

# Build the qemu:commandline block
args_xml = '\n  <qemu:commandline>\n'
for aml in aml_files:
    args_xml += f'    <qemu:arg value="-acpitable"/>\n'
    args_xml += f'    <qemu:arg value="file={aml}"/>\n'
args_xml += '  </qemu:commandline>\n'

# Remove existing qemu:commandline block if present
xml = re.sub(
    r'\s*<qemu:commandline>.*?</qemu:commandline>',
    '',
    xml,
    flags=re.DOTALL
)

# Insert before </domain>
xml = xml.replace('</domain>', args_xml + '</domain>', 1)

with open(xml_path, 'w') as f:
    f.write(xml)

print("XML updated successfully.")
EOF

echo "==> Redefining VM"
virsh --connect qemu:///system define "$TMP_XML"

echo "==> Done. Verifying injection:"
virsh --connect qemu:///system dumpxml "$VM_NAME" | grep -A6 "qemu:commandline" || echo "WARNING: qemu:commandline not found in output"

rm -f "$TMP_XML"
