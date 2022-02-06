//
//  String+Extension.swift
//  WHPlayingCardImageKit
//
//  Created by William Hale on 1/28/22.
//

import SpriteKit
import WHCrossPlatformKit

extension String {

    /// Creates an image of this string with a given font and color.
    /// - Parameters:
    ///   - font: The font.
    ///   - color: The foreground color.
    /// - Returns: The image of this string with the given font and color.
    public func imageWithFont(_ font:WHFont, color:SKColor) -> WHImage {
        let size = self.size(withAttributes: [NSAttributedString.Key.font: font])
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let image = CrossPlatform.offscreenImageWithSize(size) { context in
            self.draw(in: rect, withAttributes:[NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor:color])
        }
        return image
    }

    /// Draws this string with the font and color at the specified point in the current graphics context.
    /// - Parameters:
    ///   - point: The point in the current graphics context where you want to start drawing the string.
    ///   - font: The font.
    ///   - color: The foreground color.
    public func drawAtPoint(_ point:CGPoint, font:WHFont, color:SKColor) {
        self.draw(at: point, withAttributes:[NSAttributedString.Key.font:font, NSAttributedString.Key.foregroundColor:color])
    }
}

extension String {

    /// Calculate the size of the smallest rectangle enclosing this string with the given font.
    /// - Parameter font: The font.
    /// - Returns: The size of the smallest rectangle enclosing this string with the given font.
    public func lassoSizeWithFont(_ font:WHFont) -> CGSize {
        let fontAscender:CGFloat = font.ascender
        let fontDescender:CGFloat = font.descender
        let fontHeight2:CGFloat = fontAscender - fontDescender
        let fontWidth2:CGFloat = self.size(withAttributes: [NSAttributedString.Key.font: font]).width
        let result = CGSize(width: fontWidth2, height: fontHeight2) // wch: note that sizeWithFont rounds width
        return result
    }
}
