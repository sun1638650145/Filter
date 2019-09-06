//
//  ViewController.swift
//  Filter
//
//  Created by 孙瑞琦 on 2019/8/18.
//  Copyright © 2019 孙瑞琦. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    @IBAction func openCamera() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        let picker = UIImagePickerController()
        
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func openLibrary() {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = false //允许用户编辑选定的静止图像
        picker.sourceType = .photoLibrary //控制器的类型
        picker.delegate = self //配置代理
        
        present(picker, animated: true, completion: nil)//显示当前的UIViewController，animated是否包含动画
    }
    
    typealias FilteringCompletion = ((UIImage?, Error?) -> ())
    func process(input: UIImage, completion: @escaping FilteringCompletion) {

        let model = StarryNight()

        DispatchQueue.global().async {
            guard let cvBufferInput = input.toCVPixelBuffer(width: 720, height: 720) else {
                return
            }
            
            guard let output = try? model.prediction(inputImage: cvBufferInput) else {
                return
            }

            guard let outputImage = UIImage(pixelBuffer: output.outputImage) else {
                return
            }

            let finalImage = outputImage.resize(to: input.size)

            DispatchQueue.main.async {
                completion(finalImage, nil)
            }
        }
    }
    
    //调整Button可访问状态
    @objc func changeButtonStatus() {
        submitButton.isEnabled = true
    }
    
    @IBAction func submitter() {
        
        submitButton.isEnabled = false
        
        guard let image = self.imageView.image else {
            return
        }
        
        //每隔延时3s才提交，避免闪退
        self.perform(#selector(changeButtonStatus),with: nil,afterDelay: 3)
        
        self.process(input: image) {filteredImage, error in
            if let filteredImage = filteredImage {
                self.imageView.image = filteredImage
            }
        }
        
    }
    
    @IBAction func saver(_ sender: AnyObject) {
        
        guard let image = self.imageView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

//拓展 协议调用相册或者相机图片
extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //选择静止图像
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //从InfoKey字典里的originalIamge检索出Image，向下造型成UIIamge
        if let delegateUIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = delegateUIImage
            self.imageView.backgroundColor = .clear
        }
        
        self.dismiss(animated: true, completion: nil)//释放当前的UIViewController
    }
    
}
