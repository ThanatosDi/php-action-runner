ARG PHP_VERSION=8.4


# 使用該變數來決定基礎映像檔
FROM php:${PHP_VERSION}-cli

# 重要：再次宣告 ARG，因為 FROM 之後 ARG 會被重置
ARG PHP_VERSION=8.4
ARG PHP_EXTENSIONS=mongodb redis sqlite3 gd bcmath
ARG RUNNER_VERSION=2.330.0

# 安裝擴充套件工具
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# 安裝 Extensions (這裡列出的要是所有版本都通用的)
RUN install-php-extensions \
    @composer \
    ${PHP_EXTENSIONS}

RUN  curl -L -o runner.tar.gz "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" &&\
    tar xzf runner.tar.gz ./externals/node24 &&\
    mkdir -p /__e &&\
    mv externals/* /__e/ &&\
    rm -rf runner.tar.gz externals

# 驗證安裝
RUN php -v && composer -V
