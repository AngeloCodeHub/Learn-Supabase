# 安裝
# bun install -g opencode-ai
# bunx oh-my-opencode install --no-tui --claude=no --gemini=no --copilot=no
# bun add -g typescript-language-server
# bun install -g @fission-ai/openspec@latest
# bun add -g skills

ln -sT /root/.bun/install/global/node_modules/typescript-language-server/lib/cli.mjs \
	/usr/local/bin/typescript-language-server

ln -sT /root/.bun/install/global/node_modules/@fission-ai/openspec/bin/openspec.js \
	/usr/local/bin/openspec

ln -sT /root/.bun/install/global/node_modules/skills/bin/cli.mjs \
	/usr/local/bin/skills

export PATH="/root/.bun/install/global/node_modules/opencode-ai/bin:$PATH"
export PATH="/root/.cache/oh-my-opencode/bin:$PATH"
