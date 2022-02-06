//
//  FullCardImageMaker.swift
//  WHPlayingCardImageKit
//
//  Created by William Hale on 11/24/09.
//

import SpriteKit
import WHPlayingCardKit
import WHCrossPlatformKit

/// A structure to make full card images for a given scale factor.
public struct FullCardImageMaker {

    let defaultCardSize:CGSize
    let scaleFactor:CGFloat

    // Values for poker size cards
    // Set cardImageAtlasDefaultCardSize = CGSize(width: 50, height: 70) in CardImageAtlas.
    // Set rankFontSizeFactor:CGFloat = 0.14632 * 0.9 in FullCardImageMaker.
    // Set smallPipHeightFactor:CGFloat = 0.11923 * 0.9 in FullCardImageMaker.
    
    fileprivate let rankFontSizeFactor:CGFloat = 0.14632
    fileprivate let smallPipHeightFactor:CGFloat = 0.11923
    fileprivate let pipHeightFactor:CGFloat = 0.17419
    fileprivate let rankTabYFactor:CGFloat = 0.03226
    fileprivate let cardContentTabYFactor:CGFloat = 0.1 //0.06774

    fileprivate let rankTabXFactor:CGFloat = 0.05625
    fileprivate let cardBorderCornerRadiusFactor:CGFloat = 0.08333

    /// Initializes and returns a newly allocated object to make full card images for a given scale factor.
    /// - Parameters:
    ///   - defaultCardSize: The default card size for an unscaled card image.
    ///   - scaleFactor: The scale factor for the scaled card image.
    ///
    /// The ratio of height to width for defaultCardSize should be between 5 / 4 (stubby card) and 4 / 3 (tall card) for best results.
    public init(defaultCardSize: CGSize, scaleFactor:CGFloat) {
        self.defaultCardSize = defaultCardSize
        self.scaleFactor = scaleFactor
    }

    /// Make a full card image of a card with given rank and suit.
    /// - Parameters:
    ///   - rank: The rank for card image.
    ///   - suit: The suit for card image.
    /// - Returns: The full card image of a card with given rank and suit.
    public func makeCardImageFor(rank:Rank, suit:Suit) -> WHImage {
        let cardImage:WHImage
        if rank == .jack || rank == .queen || rank == .king {
            cardImage = faceCardImageForRank(rank, suit: suit)
        }
        else {
            cardImage = createSpotCardBitmap(rank: rank, suit: suit)
        }
        return cardImage
    }
}

extension FullCardImageMaker {

    fileprivate var cardWidth:CGFloat { return defaultCardSize.width * scaleFactor }
    fileprivate var cardHeight:CGFloat { return defaultCardSize.height * scaleFactor }
    fileprivate var cardSize:CGSize { return CGSize(width: cardWidth, height: cardHeight) }
    fileprivate var rankFontSize:CGFloat { return cardHeight * rankFontSizeFactor }
    fileprivate var rankFont:WHFont { return WHFont.boldSystemFont(ofSize: rankFontSize) }
    fileprivate var rankTabX:CGFloat { return cardWidth * rankTabXFactor }
    fileprivate var rankTabY:CGFloat { return cardHeight * rankTabYFactor }

    fileprivate var cornerPipTabY:CGFloat { return rankTabY + rankFontSize }

    fileprivate var smallPipHeight:CGFloat { return cardHeight * smallPipHeightFactor }
}

extension FullCardImageMaker {

    fileprivate func getCornerPipTabX(rankImage:WHImage, smallPipImage:WHImage) -> CGFloat {
        let cornerPipTabX = rankTabX + rankImage.size.width / 2 - smallPipImage.size.width / 2
        return cornerPipTabX
    }

    fileprivate func getRankImage(rank:Rank, color:SKColor) -> WHImage {
        return RankImage.imageFor(rank: rank, font: rankFont, color: color)
    }

    fileprivate func getCardL() -> CGFloat {
        let rank: Rank = .queen
        let suit: Suit = .hearts
        let rankImage = getRankImage(rank: rank, color: suit.color)
        let smallPipImage = PipImage.imageFor(suit: suit, pipHeight: smallPipHeight)
        let cornerPipTabX = getCornerPipTabX(rankImage: rankImage, smallPipImage: smallPipImage)
        let cardL = max(rankTabX + rankImage.size.width, cornerPipTabX + smallPipImage.size.width)
        return cardL
    }
}

extension FullCardImageMaker {

    fileprivate func faceCardImageForRank(_ rank:Rank, suit:Suit) -> WHImage {
        var cardL = getCardL()
        let cardR = cardWidth - cardL
        var faceWidth = cardR - cardL
        var faceHeight = faceWidth * 1.6131122833458931 // Note: needed to keep aspect ratio same for face image
        if faceHeight > cardHeight * 0.8 {
            let factor = (cardHeight / faceHeight) * 0.8
            faceWidth *= factor
            faceHeight *= factor
            cardL += (cardR - cardL - faceWidth) / 2
        }
        let faceY = (cardHeight - faceHeight) / 2
        let faceRect = CGRect(x: cardL, y: faceY, width: faceWidth, height: faceHeight)

        let cardImage = CrossPlatform.offscreenImageWithSize(cardSize) { context in
            drawCardOutline(context: context)

            #if DEBUG
                //context.setStrokeColor(SKColor.red.cgColor)
                //context.stroke(faceRect)
            #endif

            do {
                let resourceName = "\(rank.longName)_of_\(suit.longName)"
                FullCardFaceDrawImage.drawCardFaceWithResourceName(resourceName, targetFrame: faceRect)
            }

            // Draw corners
            for portion in 0 ..< 2 {
                if portion == 1 {
                    // draw upside down
                    context.rotate(by: CGFloat.pi)
                    context.translateBy (x: -cardWidth, y: -cardHeight)
                }
                drawCorner(rank: rank, suit: suit)
            }
        }
        return cardImage
    }
}

extension FullCardImageMaker {

    fileprivate func createSpotCardBitmap(rank:Rank, suit:Suit) -> WHImage {
        // packFactor controls how close to pack the center spot pips
        let packFactor:CGFloat = 0.1 // packFactor of 0 is spread out; increase to pack more closely; more than 1 is too close; 0.1 is recommended
        let cardT = cardHeight * cardContentTabYFactor
        let cardB = cardHeight - cardT
        let maxPipHeight:CGFloat = (cardB - cardT) * 0.25
        let pipHeight = maxPipHeight * 0.92 // 0.92 to leave some vertical freeSpace

        let centerPipBitmap:WHImage
        if (rank == .ace && suit == .spades) { // ace of spades
            centerPipBitmap = PipImage.imageFor(suit: suit, pipHeight: 2.0 * pipHeight)
        }
        else {
            centerPipBitmap = PipImage.imageFor(suit: suit, pipHeight: pipHeight)
        }
        let pipW = centerPipBitmap.size.width
        let pipH = centerPipBitmap.size.height

        let cardL = getCardL()
        let cardR = cardWidth - cardL
        let cardXX = (cardR + cardL) / 2
        let cardYY = (cardB + cardT) / 2

        let maxPackTab = cardXX - cardL - pipW * 1.25
        let candidatePackTab = ((cardR - cardL) / 2 - pipW / 2) * packFactor * 0.3350705
        let packTab:CGFloat = min(maxPackTab, candidatePackTab)

        let cardImage = CrossPlatform.offscreenImageWithSize(cardSize) { context in
            drawCardOutline(context: context)

            #if DEBUG
            do {
                //let x = cardL //rankTabX + rankImage.size.width
                //let rect = CGRect(x: x, y: cardT, width: cardWidth - 2 * x, height: cardHeight - 2 * cardT)
                //context.setStrokeColor(SKColor.red.cgColor)
                //context.stroke(rect)
            }
            #endif

            let card8Y = (cardT + cardYY - pipH / 2) / 2
            let tab9 = (cardB - cardT - 4 * pipH) / 3

            if rank == .ace || rank == .three || rank == .five || rank == .nine {
                centerPipBitmap.draw(at: CGPoint(x: cardXX - pipW / 2, y: cardYY - pipH / 2))
            }

            if rank == .six || rank == .seven || rank == .eight {
                centerPipBitmap.draw(at: CGPoint(x: cardL + packTab, y: cardYY - pipH / 2))
                centerPipBitmap.draw(at: CGPoint(x: cardR - packTab - pipW, y: cardYY - pipH / 2))
            }

            if rank == .seven {
                centerPipBitmap.draw(at: CGPoint(x: cardXX - pipW / 2, y: card8Y))
            }

            if rank != .ace && rank != .two && rank != .three {
                centerPipBitmap.draw(at: CGPoint(x: cardL + packTab, y: cardT))
                centerPipBitmap.draw(at: CGPoint(x: cardR - packTab - pipW, y: cardT))
            }
            if rank == .two || rank == .three {
                centerPipBitmap.draw(at: CGPoint(x: cardXX - pipW / 2, y: cardT))
            }
            if (rank == .eight) {
                centerPipBitmap.draw(at: CGPoint(x: cardXX - pipW / 2, y: card8Y))
            }
            if rank == .nine || rank == .ten {
                centerPipBitmap.draw(at: CGPoint(x: cardL + packTab, y: cardT + tab9 + pipH))
                centerPipBitmap.draw(at: CGPoint(x: cardR - packTab - pipW, y: cardT + tab9 + pipH))
            }
            if rank == .ten {
                centerPipBitmap.draw(at: CGPoint(x: cardXX - pipW / 2, y: cardT + (tab9 + pipH) / 2))
            }

            // draw bottom portion
            let rotatedPipBitmap = invertedImage(image: centerPipBitmap)

            if (rank != .ace && rank != .two && rank != .three) {
                rotatedPipBitmap.draw(at: CGPoint(x: cardL + packTab,  y: cardB - pipH))
                rotatedPipBitmap.draw(at: CGPoint(x: cardR - packTab - pipW, y: cardB - pipH))
            }
            if (rank == .two || rank == .three) {
                rotatedPipBitmap.draw(at: CGPoint(x: cardXX - pipW / 2, y: cardB - pipH))
            }
            if (rank == .eight) {
                rotatedPipBitmap.draw(at: CGPoint(x: cardXX - pipW / 2, y: cardYY + pipH / 4))
            }
            if (rank == .nine || rank == .ten) {
                let y = cardB - pipH - tab9 - pipH
                rotatedPipBitmap.draw(at: CGPoint(x: cardL + packTab,  y: y))
                rotatedPipBitmap.draw(at: CGPoint(x: cardR - packTab - pipW, y: y))
            }
            if (rank == .ten) {
                rotatedPipBitmap.draw(at: CGPoint(x: cardXX - pipW / 2, y: cardB - pipH - (tab9 + pipH) / 2))
            }

            // Draw corners
            for portion in 0 ..< 2 {
                if portion == 1 {
                    // draw upside down
                    context.rotate(by: CGFloat.pi)
                    context.translateBy (x: -cardWidth, y: -cardHeight)
                }
                drawCorner(rank: rank, suit: suit)
            }
        }
        return cardImage
    }
}

extension FullCardImageMaker {

    fileprivate func drawCardOutline(context: CGContext) {
        let rect = CGRect(origin: .zero, size: cardSize)
        let cardOuterStrokeWidth = getCardOuterStrokeWidth(cardWidth: cardWidth)
        let cardBorderCornerRadius = cardWidth * cardBorderCornerRadiusFactor
        let strokeRect = rect.insetBy(dx: cardOuterStrokeWidth, dy: cardOuterStrokeWidth)
        let strokePath = WHBezierPath(roundedRect: strokeRect, cornerRadius: cardBorderCornerRadius)
        strokePath.lineWidth = cardOuterStrokeWidth

        // background
        context.setAllowsAntialiasing(true)
        context.clear(rect)
        context.setFillColor(SKColor.white.cgColor)
        strokePath.fill()

        // border
        context.setStrokeColor(SKColor.black.cgColor)
        strokePath.stroke()
    }

    fileprivate func drawCorner(rank: Rank, suit: Suit) {
        let rankImage = getRankImage(rank: rank, color: suit.color)
        rankImage.draw(at: CGPoint(x: rankTabX, y: rankTabY))

        let smallPipImage = PipImage.imageFor(suit: suit, pipHeight: smallPipHeight)
        let cornerPipTabX = getCornerPipTabX(rankImage: rankImage, smallPipImage: smallPipImage)
        smallPipImage.draw(at: CGPoint(x: cornerPipTabX, y: cornerPipTabY))
    }
}

extension FullCardImageMaker {

    fileprivate func getCardOuterStrokeWidth(cardWidth:CGFloat) -> CGFloat {
        return cardWidth * 0.01
    }

    fileprivate func invertedImage(image:WHImage) -> WHImage {
        let rect = CGRect(origin: .zero, size: image.size)
        let width = image.size.width
        let height = image.size.height
        let result = CrossPlatform.offscreenImageWithSize(image.size) { context in
            context.setAllowsAntialiasing(true)
            context.clear(rect)
            context.rotate(by: CGFloat.pi)
            image.draw(at: CGPoint(x: -width, y: -height))
        }
        return result // FIXME: stub
    }
}
