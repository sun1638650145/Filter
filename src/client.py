# http://47.94.217.140:8051/v1/models/FilterEngine:predict
import json
import requests
import numpy as np
import tensorflow as tf
from time import time
from matplotlib import pyplot as plt


def load_image(content_image_path, style_image_path):
    """加载图片并进行预处理"""

    img_list = []
    img_list.append(plt.imread(content_image_path))
    img_list.append(plt.imread(style_image_path))

    processed_list = []
    for i in img_list:
        process_img = i.astype(np.float32)[np.newaxis, ...] / 255.
        process_img = tf.image.resize(process_img, (256, 256))
        process_img = np.asarray(process_img).tolist()

        processed_list.append(process_img)
    return processed_list


if __name__ == '__main__':
    # 时间戳1
    time0 = time()
    img_list = load_image(content_image_path='image/content.jpeg',
                          style_image_path='image/style.jpg')

    # 时间戳2
    time1 = time()
    data = json.dumps({
        "inputs": {
            "placeholder": img_list[0],
            "placeholder_1": img_list[1],
        }
    }, indent=4)
    headers = {"content-type": "application/json"}
    json_response = requests.post(
        url='http://47.94.217.140:8051/v1/models/FilterEngine:predict',
        data=data,
        headers=headers
    ).text
    # 时间戳3
    time2 = time()
    tensor = np.asarray(json.loads(json_response)['outputs'])
    image = tensor[0]
    plt.imshow(image)
    plt.imsave('./pic.jpg', np.asarray(image).astype(float))
    plt.show()

    # 时间戳4
    time3 = time()

    print("loadimage-time:", time1-time0)
    print("process-time:", time2-time1)
    print("show-time:", time3-time2)
    print("total-time:", time3-time0)