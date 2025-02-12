#!/bin/bash

# 初始化狀態碼
STATUS=0

# 檢查 nginx 配置
echo "Checking nginx configuration..."
nginx -t > /tmp/nginx-check 2>&1
NGINX_CONFIG_STATUS=$?

if [ $NGINX_CONFIG_STATUS -eq 0 ]; then
    echo "✓ Nginx configuration is valid"
else
    echo "✗ Nginx configuration check failed:"
    cat /tmp/nginx-check
    STATUS=1
fi

# 檢查 health endpoint
echo -e "\nChecking health endpoint..."
HEALTH_CHECK=$(curl -s -I localhost/health)
CURL_STATUS=$?

if [ $CURL_STATUS -eq 0 ] && echo "$HEALTH_CHECK" | grep -q "HTTP/1.1 200 OK"; then
    echo "✓ Health endpoint is responding correctly"
    
    # 檢查 Content-Type
    if echo "$HEALTH_CHECK" | grep -q "Content-Type: text/plain"; then
        echo "✓ Content-Type is correct (text/plain)"
    else
        echo "✗ Incorrect Content-Type"
        STATUS=1
    fi
else
    echo "✗ Health endpoint check failed"
    STATUS=1
fi

# 輸出詳細的健康檢查結果
if [ $STATUS -eq 0 ]; then
    echo -e "\n=== Health Check Passed ==="
else
    echo -e "\n=== Health Check Failed ==="
fi

# 返回狀態碼
exit $STATUS
