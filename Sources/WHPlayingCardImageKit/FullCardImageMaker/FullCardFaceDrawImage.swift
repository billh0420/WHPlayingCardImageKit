//
//  FullCardFaceDrawImage.swift
//  CardImageKit
//
//  Created by William Hale on 6/9/19.
//  Copyright © 2019 William Hale. All rights reserved.
//

import SpriteKit
import WHCrossPlatformKit

/// Errors thrown by FullCardImageMaker.
public enum DrawFullCardError: Error {
    case invalidPath
    case invalidImage
    case failed
}

class FullCardFaceDrawImage {

    class func drawCardFaceWithResourceName(_ resourceName:String, targetFrame:CGRect) {
        do {
            guard let path = Bundle.module.path(forResource: resourceName, ofType: "png") else { throw DrawFullCardError.invalidPath }
            guard let image = WHImage(contentsOfFile: path) else { throw DrawFullCardError.invalidImage }
            let dx:CGFloat = 66 * (image.size.width / 500)
            let dy:CGFloat = 66 * (image.size.width / 500)
            let cropRect = CGRect(x: dx, y: dy, width: image.size.width - 2 * dx, height:  image.size.height - 2 * dy)
            try cropImage(image: image, cropRect: cropRect, targetFrame: targetFrame)
        }
        catch {
            fatalError() // FIXME: 190610 show alert ???
        }
    }
}

#if os(iOS)

extension FullCardFaceDrawImage {

    fileprivate class func cropImage(image: WHImage, cropRect: CGRect, targetFrame: CGRect) throws {
        let scale:CGFloat = 1
        UIGraphicsBeginImageContextWithOptions(CGSize(width: cropRect.size.width / scale, height: cropRect.size.height / scale), true, 0.0)
        image.draw(at: CGPoint(x: -cropRect.origin.x / scale, y: -cropRect.origin.y / scale))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let croppedImage = croppedImage {
            croppedImage.draw(in: targetFrame)
        }
        else {
            throw DrawFullCardError.failed
        }
    }
}

#endif

#if os(OSX)

extension FullCardFaceDrawImage {

    fileprivate class func cropImage(image: WHImage, cropRect: CGRect, targetFrame: CGRect) throws {
        image.draw(in: targetFrame, from: cropRect, operation: .copy, fraction: 1, respectFlipped: true, hints: nil)
    }
}

#endif
