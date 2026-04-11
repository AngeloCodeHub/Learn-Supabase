#!/usr/bin/env bash
# Update all agents and tools

set -euo pipefail

log() {
	echo "[INFO] $*"
}

done_msg() {
	echo "[DONE] $* update completed."
}

require_cmd() {
	local cmd="$1"
	if ! command -v "$cmd" >/dev/null 2>&1; then
		echo "[WARN] '$cmd' not found, skip this step."
		return 1
	fi
	return 0
}

update_copilot() {
	require_cmd copilot || return 0
	log "Updating GitHub Copilot..."
	copilot -v
	copilot update
	done_msg "GitHub Copilot"
}

update_claude() {
	require_cmd claude || return 0
	log "Updating Claude..."
	claude -v
	claude upgrade
	done_msg "Claude"
}

update_npm_pkg() {
	local label="$1"
	local pkg="$2"
	require_cmd npm || return 0
	log "Updating ${label} (${pkg})..."
	npm outdated "$pkg" -g || true
	npm update "$pkg" -g
	done_msg "$label"
}

update_pnpm_pkg() {
	local label="$1"
	local pkg="$2"
	require_cmd pnpm || return 0
	log "Updating ${label} (${pkg})..."
	pnpm outdated "$pkg" -g || true
	pnpm update "$pkg" -g
	done_msg "$label"
}

update_bun_pkg() {
	local label="$1"
	local pkg="$2"
	require_cmd bun || return 0
	log "Updating ${label} (${pkg})..."
	bun outdated "$pkg" -g || true
	bun add "$pkg" -g
	done_msg "$label"
}

log "Start updating all agents/tools..."
update_copilot
update_claude
update_npm_pkg "OpenAI Codex" "@openai/codex"
update_npm_pkg "Gemini CLI" "@google/gemini-cli"
update_npm_pkg "Qwen Code" "@qwen-code/qwen-code"
# update_pnpm_pkg "Skills" "skills"
# update_bun_pkg "OpenSpec" "@fission-ai/openspec"
log "All update tasks finished."
