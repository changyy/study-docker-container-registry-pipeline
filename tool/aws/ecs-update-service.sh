#!/bin/bash

# 設定嚴格模式
set -e

# 檢查 AWS CLI 是否存在
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed"
    exit 1
fi

# 檢查 AWS 憑證是否存在
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "Error: AWS_ACCESS_KEY_ID is not set"
    exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "Error: AWS_SECRET_ACCESS_KEY is not set"
    exit 1
fi

if [ -z "$AWS_DEFAULT_REGION" ]; then
    echo "Error: AWS_DEFAULT_REGION is not set"
    exit 1
fi

# 檢查環境變數
if [ -z "$ECS_DEPLOY_ENABLE" ] || [ "$ECS_DEPLOY_ENABLE" != "true" ]; then
    echo "SKIP: ECS deployment is disabled (ECS_DEPLOY_ENABLE=${ECS_DEPLOY_ENABLE:-not set})"
    exit 0
fi

if [ -z "$ECS_CLUSTER" ]; then
    echo "Error: ECS_CLUSTER is not set"
    exit 1
fi

if [ -z "$ECS_SERVICE" ]; then
    echo "Error: ECS_SERVICE is not set"
    exit 1
fi

# 檢查服務狀態
echo "Checking service status..."
SERVICE_STATUS=$(aws ecs describe-services --cluster $ECS_CLUSTER --services $ECS_SERVICE | jq '.services | .[] | .events')

if [ -z "$SERVICE_STATUS" ] || [ "$SERVICE_STATUS" == "null" ]; then
    echo "Error: Failed to get service status or no events found"
    exit 1
else
    echo "Current service events:"
    echo "$SERVICE_STATUS"
fi

# 等待服務穩定
echo "Waiting for service to be stable..."
if ! aws ecs wait services-stable --cluster $ECS_CLUSTER --services $ECS_SERVICE; then
    echo "Error: Service is not in a stable state"
    exit 1
fi
echo "Status is OK"

# 更新服務
echo "Updating service..."
if ! aws ecs update-service --cluster $ECS_CLUSTER --service $ECS_SERVICE --force-new-deployment; then
    echo "Error: Failed to update service"
    exit 1
fi

# 等待部署完成
echo "Waiting for deployment to complete..."
if ! aws ecs wait services-stable --cluster $ECS_CLUSTER --services $ECS_SERVICE; then
    echo "Error: Deployment failed to stabilize"
    exit 1
fi
echo "Deploy Done"

# 檢查服務狀態
echo "Checking service status..."
SERVICE_STATUS=$(aws ecs describe-services --cluster $ECS_CLUSTER --services $ECS_SERVICE | jq '.services | .[] | .events')

if [ -z "$SERVICE_STATUS" ] || [ "$SERVICE_STATUS" == "null" ]; then
    echo "Error: Failed to get service status or no events found"
    exit 1
else
    echo "Current service events:"
    echo "$SERVICE_STATUS"
fi
