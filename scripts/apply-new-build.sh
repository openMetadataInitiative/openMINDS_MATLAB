#!/usr/bin/env bash
#
# apply-new-build.sh - Apply new build artifacts to a target code directory
#
# DESCRIPTION:
#   Replaces the generated classes of the openMINDS MATLAB toolbox with the
#   contents of the target/ directory, then restores the hand-written readme
#   and contents files that live among them.
#
#   The build tree is shaped like its destination, model version first, so
#   applying a build is one copy.
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
#   - ROOT_FOLDER/code/generated/resources/ must exist
#   - ROOT_FOLDER/code/internal/resources/ must hold the content_files and
#     readme_files that are restored on top of the generated classes
#
set -euo pipefail

# Show help if requested, before the argument is required
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

ROOT=${1:?Please provide the root folder as the first argument}

# Safety: prevent running against the system root
if [[ "$ROOT" == "/" ]]; then
    echo "Error: invalid root folder: '$ROOT'" >&2
    exit 1
fi

if [[ ! -d "target" ]]; then
    echo "Error: no target/ directory here. Run 'python build.py' first." >&2
    exit 1
fi

GENERATED_DIR="$ROOT/code/generated/resources"
OVERLAY_DIR="$ROOT/code/internal/resources"

if [[ ! -d "$GENERATED_DIR" ]]; then
    echo "Error: expected the generated classes at '$GENERATED_DIR'." >&2
    exit 1
fi

for overlay in content_files readme_files; do
    if [[ ! -d "$OVERLAY_DIR/$overlay" ]]; then
        echo "Error: expected the '$overlay' overlay at '$OVERLAY_DIR'." >&2
        exit 1
    fi
done

# Every model version is replaced, so a version the model has dropped does not
# linger in the toolbox
rm -rf "${GENERATED_DIR:?}"/*
cp -R target/. "$GENERATED_DIR"/

# Restore the hand-written files that live among the generated classes. Both
# overlays are laid out like their destination, so each is one copy.
for overlay in content_files readme_files; do
    cp -R "$OVERLAY_DIR/$overlay"/. "$GENERATED_DIR"/
done
