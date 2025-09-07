#!/usr/bin/env bash
#
# apply-new-build.sh - Apply new build artifacts to a target code directory
#
# DESCRIPTION:
#   This script copies build artifacts from the target/ directory to a specified
#   root folder's code directory, replacing types, mixedtypes, and enumerations.
#
# USAGE:
#   ./scripts/apply-new-build.sh <ROOT_FOLDER>
#
# EXAMPLES:
#   # Apply build to specific path
#   ./scripts/apply-new-build.sh /path/to/openminds-matlab
#
# REQUIREMENTS:
#   - target/ directory must exist in current working directory
#   - ROOT_FOLDER/code/ directory structure must exist
#   - ROOT_FOLDER/code/internal/resources/ directories must exist
#
set -euo pipefail

ROOT=${1:?Please provide the root folder as the first argument}

# Show help if requested
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    echo "Usage: $0 <ROOT_FOLDER>"
    echo ""
    echo "Apply new build artifacts to a target code directory"
    echo ""
    echo "Examples:"
    echo "  $0 /path/to/matlab-code    # Apply to specific path"
    echo ""
    exit 0
fi

# Safety: prevent running with empty string or system root
if [[ "$ROOT" == "" || "$ROOT" == "/" ]]; then
    echo "Error: invalid root folder: '$ROOT'" >&2
    exit 1
fi

rm -rf "$ROOT"/code/{types,mixedtypes,enumerations}/*
cp -R target/* "$ROOT"/code/
cp -R "$ROOT"/code/internal/resources/{content_files,readme_files}/* "$ROOT"/code/
