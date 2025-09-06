#!/usr/bin/env bash
set -euo pipefail

ROOT=${1:?Please provide the root folder as the first argument}

# Safety: prevent running with empty string or system root
if [[ "$ROOT" == "" || "$ROOT" == "/" ]]; then
    echo "Error: invalid root folder: '$ROOT'" >&2
    exit 1
fi

rm -rf "$ROOT"/code/{types,mixedtypes,enumerations}/*
cp -R target/* "$ROOT"/code/
cp -R "$ROOT"/code/internal/resources/{content_files,readme_files}/* "$ROOT"/code/
