# 多階段建置的 Next.js 16 應用程式 Dockerfile

# ==========================================
# 階段 1: 依賴安裝
# ==========================================
# FROM node:22-alpine AS deps
FROM node:24.12-trixie-slim AS deps

# 安裝 libc6-compat 以支援 Node.js 原生模組
# RUN apk add --no-cache libc6-compat

WORKDIR /app

# 複製套件管理檔案
COPY package.json pnpm-lock.yaml* ./

# 安裝 pnpm
RUN corepack enable pnpm && corepack prepare pnpm@latest --activate

# 安裝生產依賴
RUN pnpm install --frozen-lockfile --prod=false

# ==========================================
# 階段 2: 建置應用程式
# ==========================================
FROM node:24.12-trixie-slim AS builder

WORKDIR /app

# 接收建置時環境變數（NEXT_PUBLIC_* 需要在建置時提供）
ARG NEXT_PUBLIC_SUPABASE_URL
ARG NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY

# 從 deps 階段複製 node_modules
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# 啟用 pnpm
RUN corepack enable pnpm && corepack prepare pnpm@latest --activate

# 設定環境變數（內嵌到 Next.js 產物中）
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production
ENV NEXT_PUBLIC_SUPABASE_URL=$NEXT_PUBLIC_SUPABASE_URL
ENV NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=$NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY

# 建置 Next.js 應用程式
RUN pnpm build

# ==========================================
# 階段 3: 生產執行環境
# ==========================================
FROM node:24.12-trixie-slim AS runner

WORKDIR /app

# 建立非 root 使用者
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# 複製公開資源
COPY --from=builder /app/public ./public

# 設定正確的權限並複製建置產物
RUN mkdir .next
RUN chown nextjs:nodejs .next

# 複製建置產物和必要檔案
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# 設定環境變數
ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"
ENV NEXT_TELEMETRY_DISABLED=1

# 切換至非 root 使用者
USER nextjs

# 暴露埠號
EXPOSE 3000

# 健康檢查
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})" || exit 1

# 啟動應用程式
CMD ["node", "server.js"]