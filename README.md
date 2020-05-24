## 利用TF-Serving实现任意图像风格迁移(Arbitrary Image Stylization)

###  1.简介

使用TF-Serving构建一个图像风格迁移的API

### 2.使用方法

* 服务器端使用config.sh可一键配置，如果不是Debian之外的LInux发行版需要自行更改，如果想使用Docker也自行更改

* 以Python为例，API的请求格式是

  ```python
  data = json.dumps({
    "inputs": {
      "placeholder": img_list[0],# 原始图片0-1归一化
      "placeholder_1": img_list[1],# 风格图片0-1归一化
    }
  })
  headers = {"content-type": "application/json"}
  json_response = requests.post(
      url='http://47.94.217.140:8051/v1/models/FilterEngine:predict',
      data=data,
      headers=headers
  ).text
  ```

### 3.注意

* 模型训练的时候使用0-1归一化，所以要求发送数据进行0-1归一化，返回图片如不能正常显示在每个像素值乘以255即可
* 服务器预训练模型下载请前往tfhub中国站