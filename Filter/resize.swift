
//
//  resize.swift
//  Filter
//
//  Created by 孙瑞琦 on 2019/8/24.
//  Copyright © 2019 孙瑞琦. All rights reserved.
//

import UIKit

extension UIImage {
    
    //将CGSize还原为原尺寸的UIImage
    func resize(to size:CGSize) -> UIImage? {
        
        let cgImage = self.cgImage!
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bitsPerComponent = 8
        let bytesPerPixel = cgImage.bitsPerPixel / bitsPerComponent
        let destBytesPerRow = destWidth * bytesPerPixel
        
        guard let context = CGContext(data: nil, width: destWidth, height: destHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: destBytesPerRow, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue) else {
            return nil
        }
        
        context.interpolationQuality = .high
        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
        
        return context.makeImage().flatMap { UIImage(cgImage: $0)}
    }
}
