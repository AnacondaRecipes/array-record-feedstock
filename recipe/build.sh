#!/bin/bash
set -euo pipefail

# Get Python version (e.g., "3.10" -> "cp310")
PYTHON_VERSION=$(python -c "import sys; print(f'cp{sys.version_info.major}{sys.version_info.minor}')")
echo "Detected Python version: $PYTHON_VERSION"
echo "Platform info: $(uname -s) $(uname -m)"

# Try to download and install the appropriate wheel for the current platform and Python version
SUCCESS=0

if [[ "$(uname -s)" == "Darwin" ]] && [[ "$(uname -m)" == "arm64" ]]; then
  # macOS ARM64
  if [[ "$PYTHON_VERSION" == "cp310" ]]; then
    WHEEL_URL="https://files.pythonhosted.org/packages/15/a3/7b8eb838015ee555444665a6613aa28bcb818e4568f173cc582d4775616e/array_record-0.7.2-cp310-cp310-macosx_11_0_arm64.whl"
  elif [[ "$PYTHON_VERSION" == "cp311" ]]; then
    WHEEL_URL="https://files.pythonhosted.org/packages/fd/52/389e14107613c052dc5cf73281ba47bc7c7a07a7f6ba866692be2f30bea3/array_record-0.7.2-cp311-cp311-macosx_11_0_arm64.whl"
  elif [[ "$PYTHON_VERSION" == "cp312" ]]; then
    WHEEL_URL="https://files.pythonhosted.org/packages/ef/77/dbf73417ad7d4bfed5b48e0ba4cf1d30c1804a42712b10211249e7eb9581/array_record-0.7.2-cp312-cp312-macosx_11_0_arm64.whl"
  elif [[ "$PYTHON_VERSION" == "cp313" ]]; then
    WHEEL_URL="https://files.pythonhosted.org/packages/63/a2/d4aafa97e211639098f206ec614f57ad3dc3d6caf871bdd88a8ea9d9975a/array_record-0.7.2-cp313-cp313-macosx_11_0_arm64.whl"
  fi
elif [[ "$(uname -s)" == "Linux" ]] && [[ "$(uname -m)" == "x86_64" ]]; then
  # Linux x86_64
  if [[ "$PYTHON_VERSION" == "cp310" ]]; then
    WHEEL_URL="https://files.pythonhosted.org/packages/c5/4b/e08c238bff43d804364f8162f062d63f80ba6ee4d23a381e618379543687/array_record-0.7.2-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
  elif [[ "$PYTHON_VERSION" == "cp311" ]]; then
    WHEEL_URL="https://files.pythonhosted.org/packages/55/44/944dcbf3c398f0b4c6158d02f6fb70124353cd33bf11c66cdc6c80eb7381/array_record-0.7.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
  elif [[ "$PYTHON_VERSION" == "cp312" ]]; then
    WHEEL_URL="https://files.pythonhosted.org/packages/c6/45/e563b02f3b6e312667ecdb908d69617895c368ee4c88a6934845dbc8b608/array_record-0.7.2-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
  elif [[ "$PYTHON_VERSION" == "cp313" ]]; then
    WHEEL_URL="https://files.pythonhosted.org/packages/80/00/a1e085ff62a90658b989e004d3c3587f04955570d210d2035221a9c3468c/array_record-0.7.2-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl"
  fi
elif [[ "$(uname -s)" == "Linux" ]] && [[ "$(uname -m)" == "aarch64" ]]; then
  # Linux ARM64
  if [[ "$PYTHON_VERSION" == "cp310" ]]; then
    WHEEL_URL="https://files.pythonhosted.org/packages/f7/5a/b58f1a2e5752ee765ce348b435358544a99e254f36dd7e726f66f6002d94/array_record-0.7.2-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
  elif [[ "$PYTHON_VERSION" == "cp311" ]]; then
    WHEEL_URL="https://files.pythonhosted.org/packages/da/9e/df7e365bb7516b90709964bd7ca851ad03276a3b33331939bed5cb6d9377/array_record-0.7.2-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
  elif [[ "$PYTHON_VERSION" == "cp312" ]]; then
    WHEEL_URL="https://files.pythonhosted.org/packages/36/f5/df0e0f0c804807bc0c46d0f9ac8d64dd27bba1a1097e8a9173ed9d2ec07d/array_record-0.7.2-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
  elif [[ "$PYTHON_VERSION" == "cp313" ]]; then
    WHEEL_URL="https://files.pythonhosted.org/packages/28/e5/390c49785dd1d6589c9bb6a1713843f286908ca6b52ed7f4cf79da1567c9/array_record-0.7.2-cp313-cp313-manylinux_2_17_aarch64.manylinux2014_aarch64.whl"
  fi
fi

# Try to download and install the wheel
if [[ -n "${WHEEL_URL:-}" ]]; then
  echo "Trying to download wheel from: $WHEEL_URL"
  WHEEL_NAME=$(basename "$WHEEL_URL")
  if curl -f -o "$WHEEL_NAME" "$WHEEL_URL"; then
    echo "Successfully downloaded $WHEEL_NAME, installing..."
    $PYTHON -m pip install "$WHEEL_NAME" -vv --no-deps --no-build-isolation
    SUCCESS=1
  else
    echo "Failed to download wheel from $WHEEL_URL"
  fi
else
  echo "No direct wheel URL found for platform/Python version"
fi

# Fallback: use pip to install from PyPI
if [[ $SUCCESS -eq 0 ]]; then
  echo "Falling back to install using pip from PyPI"
  $PYTHON -m pip install array_record==0.7.2 -vv --no-deps --no-build-isolation --only-binary=all --index-url https://pypi.org/simple
fi