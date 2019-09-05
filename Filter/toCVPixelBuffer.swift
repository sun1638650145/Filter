//
//  toCVPixelBuffer.swift
//  Filter
//
//  Created by 孙瑞琦 on 2019/8/23.
//  Copyright © 2019 孙瑞琦. All rights reserved.
//

import UIKit
import VideoToolbox

extension UIImage {
    
    public func toCVPixelBuffer() -> CVPixelBuffer? {
        return toCVPixelBuffer(width: Int(self.size.width), height: Int(self.size.height))
    }
    
    public func toCVPixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        return toCVPixelBuffer(width: width, height: height, pixelFormatType: kCVPixelFormatType_32ARGB, colorSpace: CGColorSpaceCreateDeviceRGB(), alphaInfo: .noneSkipFirst)

    }
    
    //将UIImage转换为CVPixelBuffer
    func toCVPixelBuffer(width: Int, height: Int, pixelFormatType: OSType, colorSpace: CGColorSpace, alphaInfo: CGImageAlphaInfo) -> CVPixelBuffer? {
        
        var PixelBuffer: CVPixelBuffer?
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, pixelFormatType, attrs as CFDictionary, &PixelBuffer)
        
        guard status == kCVReturnSuccess, let pixelBuffer = PixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        guard let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: colorSpace, bitmapInfo: alphaInfo.rawValue) else {
            return nil
        }
        
        UIGraphicsPushContext(context)
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1, y: -1)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
    
    //构造器
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        if let cgImage = cgImage {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }

}
