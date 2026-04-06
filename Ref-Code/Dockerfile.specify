# 使用官方 uv image 作為基礎
FROM ghcr.io/astral-sh/uv:debian

# 設定工作目錄（可選但推薦）
WORKDIR /home

# 使用 uv 來安裝 GitHub Spec-kit
RUN uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# 確保 uv tool 的安裝位置在 PATH 中
ENV PATH="/root/.local/bin:$PATH"

# 你可以加入其他設定
# 例如設定預設命令
CMD ["specify", "--help"]
