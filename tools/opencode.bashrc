# 安裝
# bun install -g opencode-ai
# bunx oh-my-opencode install --no-tui --claude=no --gemini=no --copilot=no
# bun add -g typescript-language-server

ln -sT /root/.bun/install/global/node_modules/typescript-language-server/lib/cli.mjs \
	/usr/local/bin/typescript-language-server

export PATH="/root/.bun/install/global/node_modules/opencode-ai/bin:$PATH"
export PATH="/root/.cache/oh-my-opencode/bin:$PATH"
