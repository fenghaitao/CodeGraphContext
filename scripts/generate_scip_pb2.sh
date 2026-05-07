#!/usr/bin/env bash
# Generate scip_pb2.py from scip.proto using grpcio-tools' bundled protoc.
#
# Usage:
#   ./scripts/generate_scip_pb2.sh [PYTHON]
#
# PYTHON defaults to the python3 on PATH. Pass an explicit interpreter to use a
# specific venv, e.g.:
#   ./scripts/generate_scip_pb2.sh /path/to/.venv/bin/python
#
# Requirements:
#   grpcio-tools must be installed in the target Python environment:
#     uv pip install grpcio-tools
#     # or: pip install grpcio-tools

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

PROTO_SRC="$REPO_ROOT/../potpie/scip/scip.proto"
OUT_DIR="$REPO_ROOT/src/codegraphcontext/tools"

PYTHON="${1:-python3}"

if ! "$PYTHON" -c "import grpc_tools" 2>/dev/null; then
    echo "ERROR: grpcio-tools is not installed in '$PYTHON'."
    echo "       Run:  uv pip install grpcio-tools"
    exit 1
fi

if [[ ! -f "$PROTO_SRC" ]]; then
    echo "ERROR: Proto file not found: $PROTO_SRC"
    exit 1
fi

echo "Generating scip_pb2.py ..."
echo "  proto : $PROTO_SRC"
echo "  output: $OUT_DIR"

"$PYTHON" -m grpc_tools.protoc \
    -I "$(dirname "$PROTO_SRC")" \
    --python_out="$OUT_DIR" \
    "$PROTO_SRC"

echo "Done — $OUT_DIR/scip_pb2.py"
