#!/bin/bash
# TensorFlow Serving服务器配置脚本apt

# 添加Google的TensorFlow Serving源
echo "deb [arch=amd64] http://storage.googleapis.com/tensorflow-serving-apt stable tensorflow-model-server tensorflow-model-server-universal" | sudo tee /etc/apt/sources.list.d/tensorflow-serving.list
# 添加gpg key
curl https://storage.googleapis.com/tensorflow-serving-apt/tensorflow-serving.release.pub.gpg | sudo apt-key add -
sudo apt-get update
# 安装tfserving服务
sudo apt-get install tensorflow-model-server

# $1 端口（自定）
# $2 模型名称（自定）
# $3 saved_model的绝对路径
echo "URI:http://47.94.217.140:$1/v1/models/$2:predict"
tensorflow_model_server \
--rest_api_port=$1 \
--model_name=$2 \
--model_base_path=$3
