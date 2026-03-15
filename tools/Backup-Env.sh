#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_NAME="$(basename "$PROJECT_ROOT")"

# Can be overridden, e.g. RCLONE_REMOTE_PATH="GoogleDrive:BackupEnv"
RCLONE_REMOTE_PATH="${RCLONE_REMOTE_PATH:-GoogleDrive:BackupEnv}"

require_command() {
	if ! command -v "$1" >/dev/null 2>&1; then
		echo "Error: missing command '$1'." >&2
		exit 1
	fi
}

echo "Checking rclone setup..."
require_command rclone
echo "rclone installed: $(rclone version | head -1)"

REMOTES="$(rclone listremotes 2>/dev/null || true)"
if [[ -z "$REMOTES" ]]; then
	echo "Error: no rclone remotes configured." >&2
	echo "Run: rclone config" >&2
	exit 1
fi

if ! grep -q '^GoogleDrive:$' <<<"$REMOTES"; then
	echo "Warning: 'GoogleDrive:' remote was not found in your rclone config." >&2
	echo "Configured remotes:" >&2
	echo "$REMOTES" >&2
	echo "Will still try to upload to: $RCLONE_REMOTE_PATH" >&2
fi

require_command tar

mapfile -t ENV_FILES < <(find "$PROJECT_ROOT" -maxdepth 1 -type f -name '.env*' | sort)
if [[ ${#ENV_FILES[@]} -eq 0 ]]; then
	echo "No .env* files found in project root: $PROJECT_ROOT"
	exit 0
fi

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
ARCHIVE_NAME="${PROJECT_NAME}-env-backup-${TIMESTAMP}.tar.gz"
TMP_DIR="$(mktemp -d)"
STAGE_DIR="$TMP_DIR/${PROJECT_NAME}-env-files"

cleanup() {
	rm -rf "$TMP_DIR"
}
trap cleanup EXIT

mkdir -p "$STAGE_DIR"

echo "Preparing files..."
for src in "${ENV_FILES[@]}"; do
	base="$(basename "$src")"
	suffix="${base#.env}"
	target_name="${PROJECT_NAME}.env${suffix}"

	cp "$src" "$STAGE_DIR/$target_name"
	echo "  $base -> $target_name"
done

echo "Creating archive: $ARCHIVE_NAME"
tar -czf "$TMP_DIR/$ARCHIVE_NAME" -C "$STAGE_DIR" .

echo "Uploading to $RCLONE_REMOTE_PATH ..."
rclone copy "$TMP_DIR/$ARCHIVE_NAME" "$RCLONE_REMOTE_PATH" --progress

echo "Upload complete. Uploaded file info:"
rclone lsl "$RCLONE_REMOTE_PATH/$ARCHIVE_NAME"

echo "Done"
