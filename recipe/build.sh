#!/bin/bash

set -euxo pipefail

echo "=== MANUAL INSTALLATION APPROACH ==="
echo "Python version: $(${PYTHON} --version)"

# Create the target package directory manually
echo "=== CREATING PACKAGE STRUCTURE MANUALLY ==="
mkdir -p "${SP_DIR}/array_record"

# Copy the package files directly
echo "=== COPYING PACKAGE FILES ==="
cp -r array_record_pkg/* "${SP_DIR}/array_record/"

# Create the package metadata
echo "=== CREATING PACKAGE METADATA ==="
mkdir -p "${SP_DIR}/array_record-0.8.0a1.dist-info"

cat > "${SP_DIR}/array_record-0.8.0a1.dist-info/METADATA" << EOF
Metadata-Version: 2.1
Name: array-record
Version: 0.8.0a1
Summary: A file format that achieves a new frontier of IO efficiency
Author: ArrayRecord team
Author-email: no-reply@google.com
License: Apache-2.0
Requires-Python: >=3.10
Requires-Dist: absl-py
Requires-Dist: etils[epath]
EOF

echo "array_record" > "${SP_DIR}/array_record-0.8.0a1.dist-info/top_level.txt"

echo "=== VERIFYING INSTALLATION ==="
${PYTHON} -c "
import array_record
print('✅ Array Record manual installation successful!')
print('Package location:', array_record.__file__)
"