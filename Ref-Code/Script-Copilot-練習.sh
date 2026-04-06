# - "claude-sonnet-4.6"
# - "claude-sonnet-4.5"
# - "claude-haiku-4.5"
# - "claude-opus-4.6"
# - "claude-opus-4.6-fast"
# - "claude-opus-4.5"
# - "claude-sonnet-4"
# - "gpt-5.4"
# - "gpt-5.3-codex"
# - "gpt-5.2-codex"
# - "gpt-5.2"
# - "gpt-5.1"
# - "gpt-5.4-mini"
# - "gpt-5-mini"
# - "gpt-4.1"

# 直接下指令
Prompt="Hello~你能幫助我做什麼？"
# 給一份指引文件
Prompt=$(cat ./tools/Update-Agents.sh)
Model="gpt-5.3-codex"

copilot -p "$Prompt 這是一份升級Agent軟體的script，請幫我優化並加上update完成時 echo 提示" \
	--model $Model \
	--allow-all-tools \
	--allow-all-urls \
	--share ./shared.md

# 如果你想要一個簡單的指令來使用 copilot，可以定義一個函數，例如：
co() {
	copilot --model gpt-5-mini --allow-all-tools -s -p "$@"
}
