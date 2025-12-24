# PHP Action Runner

基於 GitHub Actions Runner 的 PHP 執行環境 Docker 映像檔，預先安裝多種常用 PHP 擴充套件，適用於 CI/CD 自動化流程。

## 功能特色

- **多版本 PHP 支援**：提供 PHP 8.1、8.2、8.3、8.4 版本
- **多平台架構**：同時支援 `linux/amd64` 與 `linux/arm64`
- **Laravel 開發友善**：預裝 Laravel 專案常用擴充套件
- **自動更新**：每日自動檢查基底映像更新並重新建置
- **Composer 內建**：已預裝最新版 Composer

## 快速開始

### 拉取映像檔

```bash
# 拉取特定 PHP 版本
docker pull ghcr.io/thanatosdi/php-action-runner:8.4

# 拉取特定日期版本
docker pull ghcr.io/thanatosdi/php-action-runner:8.4-20251224
```

### 可用標籤

| 標籤格式 | 說明 |
|---------|------|
| `8.1`, `8.2`, `8.3`, `8.4` | 各 PHP 版本的最新映像 |
| `8.x-YYYYMMDD` | 特定日期的版本（例如 `8.4-20251224`）|

## 預裝軟體

### PHP 擴充套件

| 類別 | 擴充套件 |
|------|---------|
| 核心 | cli, fpm, common |
| Web | xml, xmlrpc, curl, gd, imagick |
| 開發 | dev |
| 通訊 | imap, mbstring, soap |
| 效能 | opcache, bcmath |
| 資料庫 | mongodb, redis, sqlite3, memcached |
| 其他 | zip |

### 其他工具

- Composer（最新版）
- Git
- curl
- unzip

## 在 GitHub Actions 使用

### 作為自架 Runner 映像

此映像基於 [myoung34/github-runner](https://github.com/myoung34/docker-github-actions-runner)，可直接作為自架 GitHub Actions Runner 使用：

```yaml
services:
  runner:
    image: ghcr.io/thanatosdi/php-action-runner:8.4
    environment:
      REPO_URL: https://github.com/your-org/your-repo
      RUNNER_TOKEN: ${{ secrets.RUNNER_TOKEN }}
```

### 在工作流程中使用

```yaml
jobs:
  test:
    runs-on: self-hosted
    container:
      image: ghcr.io/thanatosdi/php-action-runner:8.4
    steps:
      - uses: actions/checkout@v4
      - name: Install dependencies
        run: composer install
      - name: Run tests
        run: php artisan test
```

## 本地建置

如需自行建置映像檔：

```bash
# 建置預設版本 (PHP 8.4)
docker build -t php-action-runner .

# 建置指定 PHP 版本
docker build --build-arg PHP_VERSION=8.3 -t php-action-runner:8.3 .
```

## 專案結構

```
.
├── Dockerfile                          # Docker 映像定義檔
├── .github/
│   └── workflows/
│       └── setup-php.yml               # CI/CD 自動建置工作流程
└── README.md                           # 本文件
```

## 自動建置流程

此專案使用 GitHub Actions 自動建置並推送至 GitHub Container Registry：

1. **觸發條件**
   - 推送 `Dockerfile` 或 `setup-php.yml` 異動時
   - 手動觸發 (workflow_dispatch)
   - 每日排程 (UTC 00:00)

2. **建置策略**
   - 矩陣建置：4 個 PHP 版本 × 2 個平台架構 = 8 個並行建置
   - 智慧更新：僅在基底映像 24 小時內有更新時才重新建置
   - 可透過設定 `IGNORE_CHECK_RUNNER_VERSION` 變數強制建置

3. **映像合併**
   - 使用 Docker Buildx imagetools 合併多架構映像
   - 產生統一的 manifest list 供跨平台使用

## 授權條款

MIT License
