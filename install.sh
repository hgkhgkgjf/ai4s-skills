#!/usr/bin/env bash
#
# Install AI4S skills into your Claude Code skills directory.
#
#   ./install.sh                      # install ALL skills
#   ./install.sh literature-survey    # install specific skill(s)
#   SKILLS_DIR=./.claude/skills ./install.sh   # install into a project dir
#
# By default skills go to ~/.claude/skills (available in every session).
# Set SKILLS_DIR to install project-locally instead.

set -euo pipefail

SRC="$(cd "$(dirname "$0")/skills" && pwd)"
DEST="${SKILLS_DIR:-$HOME/.claude/skills}"

# Which skills to install: the args given, or all of them.
if [ "$#" -gt 0 ]; then
  names=("$@")
else
  names=()
  for d in "$SRC"/*/; do names+=("$(basename "$d")"); done
fi

mkdir -p "$DEST"
installed=0
for n in "${names[@]}"; do
  if [ -d "$SRC/$n" ]; then
    rm -rf "${DEST:?}/$n"
    cp -R "$SRC/$n" "$DEST/$n"
    echo "  ✓ $n"
    installed=$((installed + 1))
  else
    echo "  ✗ $n (not found — skipped)"
  fi
done

echo ""
echo "Installed $installed skill(s) into: $DEST"
echo "Restart Claude Code (or reload skills) to pick them up."
