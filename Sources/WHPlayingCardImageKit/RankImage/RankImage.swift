//
//  RankImage.swift
//  CardImageKit
//
//  Created by William Hale on 10/4/14.
//  Copyright (c) 2014 William Hale. All rights reserved.
//

import SpriteKit
import WHPlayingCardKit
import WHCrossPlatformKit

/// A structure that provides a static function to create an image of a given rank with a given font and color.
public struct RankImage {

    /// Creates an image of a given rank with a given font and color.
    /// - Parameters:
    ///   - rank: The rank for the image.
    ///   - font: The font for the image.
    ///   - color: The color for the image.
    /// - Returns: The image of the given rank with the given font and color.
    public static func imageFor(rank:Rank, font:WHFont, color:SKColor) -> WHImage {
        let rankImage:WHImage
        if rank.name == "T" {
            let rank10Name = "T"
            let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.kern: NSNumber(-0.0)]
            let size = rank10Name.size(withAttributes: attributes)
            let basicRankImage = CrossPlatform.offscreenImageWithSize(size) { context in
                let lineWidth:CGFloat = size.width * 0.2
                let left:CGFloat = size.width * 0.1
                let top:CGFloat = size.height * 0.2
                let bottom:CGFloat = size.height - top
                context.setStrokeColor(color.cgColor)
                context.setFillColor(color.cgColor)
                context.setLineWidth(lineWidth)
                context.move(to: CGPoint(x: left, y: top))
                context.addLine(to: CGPoint(x: left, y: bottom))
                context.strokePath()
                do {
                    let offset:CGFloat = size.width * 0.4
                    let cornerRadius:CGFloat = size.width * 0.2
                    let dy = size.height * 0.01
                    let y = top + lineWidth / 2 - dy
                    let width = size.width - offset - lineWidth * 1.3
                    let height = bottom - top - lineWidth + 2 * dy
                    let rect = CGRect(x: lineWidth / 2 + offset, y: y, width: width, height: height)
                    let path = WHBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
                    path.lineWidth = lineWidth
                    path.stroke()
                }
                //do {
                //    context.setStrokeColor(SKColor.blue.cgColor)
                //    context.setLineWidth(1)
                //    context.stroke(CGRect(x: 0, y: top, width: size.width, height: bottom - top))
                //}
                //do {
                //    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                //    rank10Name.draw(in: rect, withAttributes: attributes)
                //}
            }
            rankImage = basicRankImage
        }
        else {
            let basicRankImage = rank.name.imageWithFont(font, color: color)
            //@@@@@@@@let basicRankLassoRect = basicRankImage.lassoRect(true)
            //@@@@@@@@let rankImage = basicRankImage.croppedImageToRect(basicRankLassoRect)
            rankImage = basicRankImage
        }
        return rankImage
    }
}
