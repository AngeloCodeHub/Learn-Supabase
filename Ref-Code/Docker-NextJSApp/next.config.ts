import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* config options here */
  // output: 'export',
  // 啟用 standalone 模式供 Docker 使用
  output: 'standalone',
};

export default nextConfig;
