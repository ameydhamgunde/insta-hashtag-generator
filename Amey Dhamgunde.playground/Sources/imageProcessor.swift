//
//  imageProcessor.swift
//
//  Created by Amey Dhamgunde on 2019-03-18.
//  Copyright © 2019 Amey Dhamgunde. All rights reserved.
//  
//  This struct contains a method that is used to convert from CGImage to CVPixelBuffer, the latter being an accepted argument by the GoogLeNetPlaces ML model.
//

import CoreVideo
import UIKit

public struct imageProcessor {
    
    /**
        Converts the CGImage input into a CVPixelBuffer output
        - parameters:
            - image: the image to be converted as CGImage
        - returns: a converted image in the format CVPixelBuffer
     */
    
    public static func pixelBuffer (image: CGImage) -> CVPixelBuffer? {
        
        
        let frameSize = CGSize(width: image.width, height: image.height)
        
        var pixelBuffer:CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width), Int(frameSize.height), kCVPixelFormatType_32BGRA , nil, &pixelBuffer)
        
        if status != kCVReturnSuccess {
            return nil
            
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        
        context?.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
        
    }
    
}
