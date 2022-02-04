//
//  CardBackImage.swift
//  CardImageKit
//
//  Created by William Hale on 10/6/14.
//  Copyright (c) 2014 William Hale. All rights reserved.
//

import SpriteKit
import WHCrossPlatformKit

/// A structure that provides a static function to create an image of the back of a playing card with a given size, fill color, and background color.
public struct CardBackImage {

    public static let cardBackgroundColor = SKColor.white
    public static let cardOutlineStrokeWidthFactor:CGFloat = 0.013392857142857142

    /// Creates an image of the back of a playing card with a given size, fill color, and background color.
    /// - Parameters:
    ///   - cardSize: The size of the playing card.
    ///   - fillColor: The fill color of the back design.
    ///   - backgroundColor: The background color of the back of the playing card.
    /// - Returns: The image of the back of a playing card with a given size, fill color, and background color.
    public static func makeCardBackImage(cardSize:CGSize, fillColor:SKColor, backgroundColor:SKColor) -> WHImage {
        let cardWidth:CGFloat = cardSize.width
        let cardHeight:CGFloat = cardSize.height
        let cardBorderCornerRadius = cardHeight * 0.0857143

        let rect = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)

        let cardBackImage = CrossPlatform.offscreenImageWithSize(rect.size) { context in
            context.setAllowsAntialiasing(true)
            context.clear(rect)

            let cardOutlineStrokeWidth = cardWidth * cardOutlineStrokeWidthFactor
            let strokeRect = rect.insetBy(dx: cardOutlineStrokeWidth, dy: cardOutlineStrokeWidth)
            let strokePath = WHBezierPath(roundedRect: strokeRect, cornerRadius: cardBorderCornerRadius)
            strokePath.lineWidth = cardOutlineStrokeWidth

            // background
            context.setFillColor(backgroundColor.cgColor)
            strokePath.fill()

            // border
            context.setStrokeColor(SKColor.black.cgColor)
            strokePath.stroke()

            // Draw back design
            let borderMargin = 0.1 * cardWidth
            let insetCardRect = rect.insetBy(dx: borderMargin, dy: borderMargin)
            context.setFillColor(fillColor.cgColor)
            context.fill(insetCardRect);
        }

        return cardBackImage
    }
}
