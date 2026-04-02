# !/bin/bash
# Update all agents and tools

# GitHub Copilot
copilot -v
copilot update

# claude update
claude -v
claude upgrade

# OpenAI Codex
npm outdated @openai/codex -g
npm update @openai/codex -g

# Gemini CLI
npm outdated @google/gemini-cli -g
npm update @google/gemini-cli -g

# Qwen Code
npm outdated @qwen-code/qwen-code -g
npm update @qwen-code/qwen-code -g

# skills
pnpm outdated skills -g
pnpm update skills -g

# openspec
bun outdated @fission-ai/openspec -g
bun i @fission-ai/openspec -g
