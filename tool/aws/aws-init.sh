#!/bin/bash

# 初始化預設值
AWS_DEFAULT_REGION="ap-northeast-1"
CSV_FILE=""

# 解析參數
while [[ $# -gt 0 ]]; do
    case $1 in
        --region)
            AWS_DEFAULT_REGION="$2"
            shift 2
            ;;
        *.csv)
            CSV_FILE="$1"
            shift
            ;;
        *)
            echo "不支援的參數: $1"
            exit 1
            ;;
    esac
done

# 驗證 CSV 內容的函數
validate_and_export_csv() {
    _file="$1"
    # 檢查檔案是否存在
    if [[ ! -f "$_file" ]]; then
        return 1
    fi
    
    # 讀取第一行並檢查格式
    _header=$(head -n 1 "$_file")
    
    # 檢查是否包含 "Access key ID" 關鍵字
    if ! echo "$_header" | grep -q "Access key ID"; then
        return 1
    fi
    
    # 檢查是否有兩欄
    _column_count=$(echo "$_header" | awk -F',' '{print NF}')
    if [[ $_column_count -ne 2 ]]; then
        return 1
    fi
    
    # 讀取並設定環境變數
    _creds=$(head -n 2 "$_file" | tail -n 1 | awk -F',' '{print $1,$2}')
    export AWS_ACCESS_KEY_ID=$(echo "$_creds" | cut -d' ' -f1)
    export AWS_SECRET_ACCESS_KEY=$(echo "$_creds" | cut -d' ' -f2)
    export AWS_DEFAULT_REGION="$AWS_DEFAULT_REGION"
    
    echo "已設定 AWS 憑證："
    echo "Region: $AWS_DEFAULT_REGION"
    echo "Access Key ID: ${AWS_ACCESS_KEY_ID:0:5}..."
    echo "Secret Access Key: ${AWS_SECRET_ACCESS_KEY:0:5}..."
    
    return 0
}

# 主要邏輯
if [[ -n "$CSV_FILE" ]]; then
    # 如果指定了 CSV 檔案
    if ! validate_and_export_csv "$CSV_FILE"; then
        echo "錯誤：指定的 CSV 檔案 '$CSV_FILE' 格式不正確或不存在"
        exit 1
    fi
else
    # 搜尋當前目錄下的 CSV 檔案
    _found=0
    while IFS= read -r _file; do
        if validate_and_export_csv "$_file"; then
            _found=1
            break
        fi
    done < <(find . -maxdepth 1 -name "*.csv")
    
    if [[ $_found -eq 0 ]]; then
        echo "錯誤：在當前目錄下找不到有效的 AWS 憑證 CSV 檔案"
        exit 1
    fi
fi
