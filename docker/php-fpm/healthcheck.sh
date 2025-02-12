#!/bin/bash
output=$(SCRIPT_NAME=/status SCRIPT_FILENAME=/status REQUEST_METHOD=GET cgi-fcgi -bind -connect localhost:9000)

# 檢查命令是否成功執行
if [ $? -ne 0 ]; then
    exit 1
fi

# 檢查是否包含關鍵指標
if echo "$output" | grep -q "pool:" && \
   echo "$output" | grep -q "process manager:" && \
   echo "$output" | grep -q "idle processes:"; then
    exit 0
else
    exit 1
fi
