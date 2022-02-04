//
//  PartialCardImageMaker.swift
//  CardImageKit
//  
//  Created by William Hale on 10/6/14.
//  Copyright (c) 2014 William Hale. All rights reserved.
//

import SpriteKit
import WHPlayingCardKit
import WHCrossPlatformKit

/// A structure to make partial card images for a given default card size and scale factor.
public struct PartialCardImageMaker {

    let defaultCardSize:CGSize
    let scaleFactor:CGFloat

    /// Initializes and returns a newly allocated object to make partial card images for a given default card size and scale factor.
    /// - Parameters:
    ///   - defaultCardSize: The default card size for an unscaled card image.
    ///   - scaleFactor: The scale factor for the scaled card image.
    public init(defaultCardSize: CGSize, scaleFactor:CGFloat) {
        self.defaultCardSize = defaultCardSize
        self.scaleFactor = scaleFactor
    }

    /// Make a partial card image of a card with given rank and suit.
    /// - Parameters:
    ///   - rank: The rank for card image.
    ///   - suit: The suit for card image.
    /// - Returns: The partial card image of a card with given rank and suit.
    public func makeCardImageFor(rank:Rank, suit:Suit) -> WHImage {
        let cardSize = CGSize(width: defaultCardSize.width * scaleFactor, height: defaultCardSize.height * scaleFactor)
        let cardWidth:CGFloat = cardSize.width
        let cardHeight:CGFloat = cardSize.height
        let cardBorderCornerRadius = cardHeight * 0.0857143

        let cornerPipHeight:CGFloat = (3 * cardWidth) / 14
        let centerPipHeight:CGFloat = cardWidth / 2
        let rankFontSize:CGFloat = (2 * cardHeight) / 7
        let rankFont = WHFont.boldSystemFont(ofSize: rankFontSize)
        let rankImage = RankImage.imageFor(rank: rank, font: rankFont, color: suit.color)
        let cornerPipImage = PipImage.imageFor(suit: suit, pipHeight: cornerPipHeight)
        let centerPipImage = PipImage.imageFor(suit: suit, pipHeight: centerPipHeight)

        let rect = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)

        let cardImage = CrossPlatform.offscreenImageWithSize(rect.size) { context in
            context.setAllowsAntialiasing(true)
            context.clear(rect)

            let cardOutlineStrokeWidth = cardWidth * CardBackImage.cardOutlineStrokeWidthFactor
            let strokeRect = rect.insetBy(dx: cardOutlineStrokeWidth, dy: cardOutlineStrokeWidth)
            let strokePath = WHBezierPath(roundedRect: strokeRect, cornerRadius: cardBorderCornerRadius)
            strokePath.lineWidth = cardOutlineStrokeWidth

            // background
            context.setFillColor(SKColor.white.cgColor)
            strokePath.fill()

            // border
            context.setStrokeColor(SKColor.black.cgColor)
            strokePath.stroke()

            // card
            let rankImageRect = CGRect(origin: CGPoint.zero, size: rankImage.size)
            let cornerPipImageRect = CGRect(origin: CGPoint.zero, size: cornerPipImage.size)
            let centerPipImageRect = CGRect(origin: CGPoint.zero, size: centerPipImage.size)
            let row1:CGFloat = 0
            let row2:CGFloat = row1 + rankImageRect.size.height
            let col1:CGFloat = cardWidth * 0.053571428571428568
            let centerPipCol = cardWidth / 2 - centerPipImage.size.width / 2
            let centerPipRow = cardHeight / 2 - centerPipImage.size.height / 2 + rankImage.size.height / 4
            rankImage.draw(in: rankImageRect.offsetBy(dx: col1, dy: row1))
            cornerPipImage.draw(in: cornerPipImageRect.offsetBy(dx: col1, dy: row2))
            centerPipImage.draw(in: centerPipImageRect.offsetBy(dx: centerPipCol, dy: centerPipRow))
        }

        return cardImage
    }
}
