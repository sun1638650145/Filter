## 利用Core ML实现图像风格迁移(Style Transfer)

### 1.简介
得力于数据规模的增长和算力的提高，机器学习的发展有了显著的突破进展（前面都是扯犊子），近年来，Apple也开始在机器学习领域有所布局，推出了Core ML和Create ML框架，谷歌也推出了TensorFlow框架，但是Core ML框架只能部署模型并不能训练模型，因此，我们需要利用TensorFlow训练我们自己需要的模型后转化为Core ML的模型。（P.S. TensorFlow有对应的TensorFlow Lite框架可以直接部署在iOS平台，但是笔者本人TensorFlow Lite的官方Demo没有运行成功，而且Core ML的底层实现是通过苹果自己的Metal实现的，理论上讲速度要比TensorFLow Lite快，所以采用了 TensorFlow + Core ML的方式）

### 2.运行环境
1. macOS 10.14.1 
2. iOS 12.4
3. TensorFlow 1.12+
4. Python 2.7.10+

### 3.实现细节

***3.1获取模型***
由于TensorFLow使用的固化的计算图模型是.pb(protobuf)文件，而Core ML使用的是 .mlmodel的文件，所以我们需要使用Apple官方提供的一个叫做[tf-coreml](https://github.com/tf-coreml/tf-coreml)的工具进行转化，它能自动将pb文件转化为mlmodel文件。

***3.2UI***
在Main.storyboard上把自己需要的OBjects拖上去，最好是做好AutoLayout，笔者才疏学浅，就根据自己手中的iPhone 8单独做的UI，注意一点Apple是个非常注重隐私的企业（这不是打广告），在iOS8那时更新了安全策略，所有涉及可能用户隐私的权限，需要在Info.plist中单独说明，不然的话，编译时是不会报错，但是运行后，使用这个功能在terminal中会有error。比如，关于相机的NSCameraUsageDescription和关于相册的NSPhotoLibraryAddUsageDescription。

***3.3实现从输入到输出的映射***
快速风格迁移的本质是建立了一种从输入到输出的映射关系，所以我们就要将摄像头或者相册得到的图片传入神经网络，由神经网络输出，因为Core ML要求喂入网络的是CVPixelBuffer，所以我们要自己处理一下，这里Apple并没有提供对应的转化API，所以我们要自己实现他。总结处理逻辑就是UIImage2CVPixelBuffer2UIImage。具体的toCVPixelBuffer和toUIImage的代码就直接看项目就好了。这里只简单说一下ViewController里的process实现
```swift
    typealias FilteringCompletion = ((UIImage?, Error?) -> ())
    func process(input: UIImage, completion: @escaping FilteringCompletion) {
        //初始化mlmodel
        let model = StarryNight()

        DispatchQueue.global().async {
            //将转化成UIImage转化为CVPixelBuffer
            guard let cvBufferInput = input.toCVPixelBuffer(width: 720, height: 720) else {
                return
            }
            //喂入神经网络处理
            guard let output = try? model.prediction(inputImage: cvBufferInput) else {
                return
            }
            //将CVpixelBuffer转化回UIImage
            guard let outputImage = UIImage(pixelBuffer: output.outputImage) else {
                return
            }
            //还原为原尺寸的UIImage
            let finalImage = outputImage.resize(to: input.size)

            DispatchQueue.main.async {
                completion(finalImage, nil)
            }
        }  
    }
```
笔者比较懒，基本上所有的异常都没有处理，都是直接return，望见谅。

###4.最后总结
笔者也是刚接触机器学习不长时间，才疏学浅，各种开发水平极其有限，如果能帮助到您，自感欣慰不已，附联系方式qq:1638650145,邮箱同号
