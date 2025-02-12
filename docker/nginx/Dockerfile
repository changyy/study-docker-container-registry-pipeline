FROM nginx:alpine

# 安裝 envsubst
RUN apk add --no-cache bash gettext

# 移除默認配置
RUN rm /etc/nginx/conf.d/default.conf

# 複製配置模板
COPY docker/nginx/templates/app.conf.template /etc/nginx/templates/

# 啟動腳本
COPY docker/nginx/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# 測試 nginx 健康
COPY docker/nginx/healthcheck.sh /usr/local/bin/healthcheck.sh
RUN chmod 777 /usr/local/bin/healthcheck.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
