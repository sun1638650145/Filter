import os
import numpy as np
import tensorflow as tf
from time import time
from tensorflow_hub import load
from matplotlib import pyplot as plt
os.environ['TFHUB_CACHE_DIR'] = './tfhub'


def load_image(content_image_path, style_image_path, show=False):
    """加载图片并进行预处理"""

    img_list = []
    img_list.append(plt.imread(content_image_path))
    img_list.append(plt.imread(style_image_path))

    if show is True:
        plt.figure()
        for i in range(2):
            plt.subplot(1, 2, i+1)
            plt.imshow(img_list[i])
        plt.show()

    processed_list = []
    for i in img_list:
        process_img = i.astype(np.float32)[np.newaxis, ...] / 255.
        processed_list.append(tf.image.resize(process_img, (256, 256)))
    return processed_list


if __name__ == '__main__':
    # 时间戳1
    time0 = time()
    img_list = load_image(content_image_path='image/content.jpeg',
                          style_image_path='image/style.jpg')

    # 时间戳2
    time1 = time()
    model = load('tfhub/2')
    outputs = model(tf.constant(img_list[0]), tf.constant(img_list[1]))
    # 时间戳3
    time2 = time()

    stylized_image = outputs[0]
    plt.imshow(stylized_image[0])
    plt.imsave('./pic.jpg', np.asarray(stylized_image[0]))
    plt.show()
    # 时间戳4
    time3 = time()

    print("loadimage-time:", time1-time0)
    print("model-time:", time2-time1)
    print("show-time:", time3-time2)
    print("total-time:", time3-time0)