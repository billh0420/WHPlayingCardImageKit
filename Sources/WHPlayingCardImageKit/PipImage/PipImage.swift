//
//  PipImage.swift
//  CardImageKit
//
//  Created by William Hale on 10/3/14.
//  Copyright (c) 2014 William Hale. All rights reserved.
//

import SpriteKit
import WHPlayingCardKit
import WHCrossPlatformKit

/// A structure that provides a static function to create an image of a given suit with a given height.
public struct PipImage {
    
    static let defaultPipWidth:CGFloat = 75
    static let defaultPipHeight:CGFloat = 85

    /// Creates an image of a given suit with a given height.
    /// - Parameters:
    ///   - suit: The suit for the image.
    ///   - pipHeight: The height for the image.
    /// - Returns: The image of the given suit with the given height.
    public static func imageFor(suit:Suit, pipHeight:CGFloat) -> WHImage {
        let pipWidth = (pipHeight * defaultPipWidth) / defaultPipHeight
        let rect = CGRect(x: 0, y: 0, width: pipWidth, height: pipHeight)
        let image = CrossPlatform.offscreenImageWithSize(rect.size) { context in
            if suit == Suit.clubs
            {
                PipImage.drawClubInContext(context, pipWidth:pipWidth, pipHeight:pipHeight)
            }
            else if suit == Suit.diamonds
            {
                PipImage.drawDiamondInContext(context, pipWidth:pipWidth, pipHeight:pipHeight)
            }
            else if suit == Suit.hearts
            {
                PipImage.drawHeartInContext(context, pipWidth:pipWidth, pipHeight:pipHeight)
            }
            else
            {
                PipImage.drawSpadeInContext(context, pipWidth:pipWidth, pipHeight:pipHeight)
            }
        }
        return image
    }

    fileprivate static func drawClubInContext(_ context:CGContext, pipWidth:CGFloat, pipHeight:CGFloat) {
        let inset:CGFloat = 1 // 200122 kludge
        let pipWidth2 = pipWidth - 2 * inset
        let pipHeight2 = pipHeight - 2 * inset
        let path = WHBezierPath()
        SKColor.black.set()
        let midHeight = (pipWidth2 / 4) * sqrt(3)
        let topCenter = CGPoint(x: pipWidth2 / 2, y: pipWidth2 / 4)
        let leftCenter = CGPoint(x: pipWidth2 / 4, y: midHeight + pipWidth2 / 4)
        let rightCenter = CGPoint(x: pipWidth2 - pipWidth2 / 4, y: midHeight + pipWidth2 / 4)
        //WHBezierPath(rect: CGRectMake(0, 0, pipWidth2, pipHeight2)).stroke()
        path.move(to: topCenter)
        path.addLine(to: rightCenter)
        path.addLine(to: leftCenter)
        path.close()
        path.append(WHBezierPath(ovalIn:CGRect(x: pipWidth2 / 4, y: 0, width: pipWidth2 / 2, height: pipWidth2 / 2)))
        path.append(WHBezierPath(ovalIn:CGRect(x: 0, y: midHeight, width: pipWidth2 / 2, height: pipWidth2 / 2)))
        path.append(WHBezierPath(ovalIn:CGRect(x: pipWidth2 / 2, y: midHeight, width: pipWidth2 / 2, height: pipWidth2 / 2)))
        let clubBaseWidth = pipWidth2 / 2
        path.move(to: CGPoint(x: pipWidth2 / 2 - clubBaseWidth / 2, y: pipHeight2))
        path.addCurve(to: CGPoint(x: pipWidth2 / 2, y: midHeight),
                            controlPoint1:CGPoint(x: pipWidth2 / 2, y: pipHeight2),
                            controlPoint2:CGPoint(x: pipWidth2 / 2, y: pipHeight2 / 2))
        path.addCurve(to: CGPoint(x: pipWidth2 / 2 + clubBaseWidth / 2, y: pipHeight2),
            controlPoint1:CGPoint(x: pipWidth2 / 2, y: pipHeight2 / 2),
            controlPoint2:CGPoint(x: pipWidth2 / 2, y: pipHeight2))
        path.close()
        #if os(iOS)
            path.apply(CGAffineTransform(translationX: inset, y: inset))
        #else
            path.transform(using: AffineTransform(translationByX: inset, byY: inset))
        #endif
        path.fill() // wch: use "path.stroke()" to see what is going on
    }
    
    fileprivate static func drawDiamondInContext(_ context:CGContext, pipWidth:CGFloat, pipHeight:CGFloat) {
        let inset:CGFloat = 1 // 200122 kludge
        let pipWidth2 = pipWidth - 2 * inset
        let pipHeight2 = pipHeight - 2 * inset
        let path = WHBezierPath()
        Suit.redColor.set()
        //WHBezierPath(rect: CGRectMake(0, 0, pipWidth2, pipHeight2)).stroke()
        path.move(to: CGPoint(x: pipWidth2 / 2, y: 0))
        path.addLine(to: CGPoint(x: pipWidth2, y: pipHeight2 / 2))
        path.addLine(to: CGPoint(x: pipWidth2 / 2, y: pipHeight2))
        path.addLine(to: CGPoint(x: 0, y: pipHeight2 / 2))
        path.addLine(to: CGPoint(x: pipWidth2 / 2, y: 0))
        #if os(iOS)
            path.apply(CGAffineTransform(translationX: inset, y: inset))
        #else
            path.transform(using: AffineTransform(translationByX: inset, byY: inset))
        #endif
        path.fill() // wch: use "path.stroke()" to see what is going on
    }

    fileprivate static func drawHeartInContext(_ context:CGContext, pipWidth:CGFloat, pipHeight:CGFloat) {
        let inset:CGFloat = 1 // 200122 kludge
        let pipWidth2 = pipWidth - 2 * inset
        let pipHeight2 = pipHeight - 2 * inset
        let path = WHBezierPath()
        Suit.redColor.set()
        let midHeight = pipHeight2 * 0.3
        //WHBezierPath(rect: CGRect(x: 0, y: 0, width: pipWidth2, height: pipHeight2)).stroke()
        path.move(to: CGPoint(x: 0, y: midHeight))
        path.addQuadCurve(to: CGPoint(x: pipWidth2 / 4, y: 0), controlPoint:CGPoint(x: 0, y: 0))
        path.addQuadCurve(to: CGPoint(x: pipWidth2 / 2, y: midHeight), controlPoint:CGPoint(x: pipWidth2 / 2, y: 0))
        path.addQuadCurve(to: CGPoint(x: pipWidth2 - pipWidth2 / 4, y: 0), controlPoint:CGPoint(x: pipWidth2 / 2, y: 0))
        path.addQuadCurve(to: CGPoint(x: pipWidth2, y: midHeight), controlPoint:CGPoint(x: pipWidth2, y: 0))
        path.addQuadCurve(to: CGPoint(x: pipWidth2 / 2, y: pipHeight2), controlPoint:CGPoint(x: pipWidth2, y: pipHeight2 - pipHeight2 / 2))
        path.addQuadCurve(to: CGPoint(x: 0, y: midHeight), controlPoint:CGPoint(x: 0, y: pipHeight2 - pipHeight2 / 2))
        #if os(iOS)
            path.apply(CGAffineTransform(translationX: inset, y: inset))
        #else
            path.transform(using: AffineTransform(translationByX: inset, byY: inset))
        #endif
        path.fill() // wch: use "path.stroke()" to see what is going on
    }

    fileprivate static func drawSpadeInContext(_ context:CGContext, pipWidth:CGFloat, pipHeight:CGFloat) {
        let inset:CGFloat = 1 // 200122 kludge
        let pipWidth2 = pipWidth - 2 * inset
        let pipHeight2 = pipHeight - 2 * inset
        let path = WHBezierPath()
        SKColor.black.set()
        let midHeight = (pipWidth2 / 4) * sqrt(3)
        let spadeBaseHeight = (pipWidth2 / 4) * sqrt(3) + pipWidth2 / 2 // wch: align with bottom of club
        let spadePointHeight = spadeBaseHeight * 0.7
        //WHBezierPath(rect: CGRectMake(0, 0, pipWidth2, pipHeight2)).stroke()
        path.move(to: CGPoint(x: 0, y: spadePointHeight))
        path.addQuadCurve(to: CGPoint(x: pipWidth2 / 4, y: spadeBaseHeight), controlPoint:CGPoint(x: 0, y: spadeBaseHeight))
        path.addQuadCurve(to: CGPoint(x: pipWidth2 / 2, y: spadePointHeight), controlPoint:CGPoint(x: pipWidth2 / 2, y: spadeBaseHeight))
        path.addQuadCurve(to: CGPoint(x: pipWidth2 - pipWidth2 / 4, y: spadeBaseHeight), controlPoint:CGPoint(x: pipWidth2 / 2, y: spadeBaseHeight))
        path.addQuadCurve(to: CGPoint(x: pipWidth2, y: spadePointHeight), controlPoint:CGPoint(x: pipWidth2, y: spadeBaseHeight))
        path.addQuadCurve(to: CGPoint(x: pipWidth2 / 2, y: 0), controlPoint:CGPoint(x: pipWidth2, y: spadeBaseHeight - spadeBaseHeight / 2))
        path.addQuadCurve(to: CGPoint(x: 0, y: spadePointHeight), controlPoint:CGPoint(x: 0, y: spadeBaseHeight - spadeBaseHeight / 2))
        #if os(iOS)
            path.apply(CGAffineTransform(translationX: inset, y: inset))
        #else
            path.transform(using: AffineTransform(translationByX: inset, byY: inset))
        #endif
        path.fill()
        path.removeAllPoints() // wch: use "path.stroke()" to see what is going on

        path.move(to: CGPoint(x: pipWidth2 / 2 - pipWidth2 / 4, y: pipHeight2))
        path.addCurve(to: CGPoint(x: pipWidth2 / 2, y: midHeight),
            controlPoint1:CGPoint(x: pipWidth2 / 2, y: pipHeight2),
            controlPoint2:CGPoint(x: pipWidth2 / 2, y: pipHeight2 / 2))
        path.addCurve(to: CGPoint(x: pipWidth2 / 2 + pipWidth2 / 4, y: pipHeight2),
            controlPoint1:CGPoint(x: pipWidth2 / 2, y: pipHeight2 / 2),
            controlPoint2:CGPoint(x: pipWidth2 / 2, y: pipHeight2))
        path.close()
        #if os(iOS)
            path.apply(CGAffineTransform(translationX: inset, y: inset))
        #else
            path.transform(using: AffineTransform(translationByX: inset, byY: inset))
        #endif
        path.fill() // wch: use "path.stroke()" to see what is going on
    }
}
