//
//  CardImageAtlas.swift
//  WHPlayingCardImageKit
//
//  Created by William Hale on 2/1/17.
//

import SpriteKit
import WHPlayingCardKit
import WHCrossPlatformKit

/// A class that has an atlas of card images keyed by card name.
/// The atlas of card images will also have the card back image keyed by "back".
public class CardImageAtlas {

    /// The recommended default card size.
    ///
    /// The recommended cardImageAtlasDefaultCardSize is CGSize(width: 56, height: 70).
    ///
    /// Values for poker size cards:
    /// * Set cardImageAtlasDefaultCardSize = CGSize(width: 50, height: 70) in CardImageAtlas.
    /// * Set rankFontSizeFactor:CGFloat = 0.14632 * 0.9 in FullCardImageMaker.
    /// * Set smallPipHeightFactor:CGFloat = 0.11923 * 0.9 in FullCardImageMaker.
    public static let cardImageAtlasDefaultCardSize = CGSize(width: 56, height: 70)

    /// A boolean that indicates whether to load full card images or partial card images.
    public var isUseFullCardImage:Bool

    /// An atlas of card images keyed by card name.
    ///
    /// There will also be a card back image keyed by "back".
    public var dictionary:Dictionary<String, WHImage>

    deinit {
        #if DEBUG
            print("deinit CardImageAtlas")
        #endif
    }

    /// Creates a card image atlas.
    /// - Parameter isUseFullCardImage: A boolean that indicates whether to load full card images or partial card images.
    public init(isUseFullCardImage:Bool) {
        self.isUseFullCardImage = isUseFullCardImage
        self.dictionary = [:]
    }
}

extension CardImageAtlas {

    /// Load the dictionary in the background with scaled card images keyed by card name of the given cards (whose packId is 0).
    /// The scaled image of a card back with key "back"  will also be loaded.
    /// - Parameters:
    ///   - cards: The cards (whose packId is 0) for which their scaled card images will be loaded into the dictionary keyed by card name.
    ///   - defaultCardSize: The default card size for an unscaled card image.
    ///   - scaleFactor: The scale factor for the scaled card image.
    public func backgroundLoadCardImages(cards:[Card], defaultCardSize:CGSize, scaleFactor:CGFloat) { // 170709
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let this = self else { return }
            let cardImageDictionary = this.createCardImageDictionary(cards: cards, defaultCardSize: defaultCardSize, scaleFactor: scaleFactor)
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                for (cardName, cardImage) in cardImageDictionary {
                    this.dictionary[cardName] = cardImage
                }
                #if DEBUG
                    print("backgroundLoadCardImages done!")
                #endif
            }
        }
    }
}

extension CardImageAtlas {
    fileprivate func createCardImageDictionary(cards:[Card], defaultCardSize:CGSize, scaleFactor:CGFloat) -> Dictionary<String, WHImage> { // 170709
        var cardImageDictionary:Dictionary<String, WHImage> = [:]
        if isUseFullCardImage {
            let fullCardImageMaker = FullCardImageMaker(defaultCardSize: defaultCardSize, scaleFactor: scaleFactor)
            for card in cards.filter({$0.packId == 0}) {
                let cardImage = fullCardImageMaker.makeCardImageFor(rank: card.rank, suit: card.suit)
                cardImageDictionary[card.name] = cardImage
            }
        }
        else {
            let partialCardImageMaker = PartialCardImageMaker(defaultCardSize: defaultCardSize, scaleFactor: scaleFactor)
            for card in cards.filter({$0.packId == 0}) {
                let cardImage = partialCardImageMaker.makeCardImageFor(rank: card.rank, suit: card.suit)
                cardImageDictionary[card.name] = cardImage
            }
        }
        if let cardImage = cardImageDictionary.first?.value {
            let cardSize = cardImage.size
            let cardBackgroundColor = CardBackImage.cardBackgroundColor
            cardImageDictionary["back"] = CardBackImage.makeCardBackImage(cardSize: cardSize, fillColor: .blue, backgroundColor: cardBackgroundColor)
        }
        return cardImageDictionary
    }
}

extension CardImageAtlas {

    /// Create a card back image of the given card size.
    /// - Parameters:
    ///   - cardSize: The size for the card back image.
    /// - Returns: The card back image of the given card size.
    public static func cardBackImageForCardSize(_ cardSize:CGSize) -> WHImage {
        let cardBackgroundColor = CardBackImage.cardBackgroundColor
        let cardBackImage =  CardBackImage.makeCardBackImage(cardSize: cardSize, fillColor: .blue, backgroundColor: cardBackgroundColor)
        return cardBackImage
    }

    /// Create a card image of a card with given defaultCardSize, scaleFactor, and isUseFullCardImage.
    /// - Parameters:
    ///   - card: The card.
    ///   - defaultCardSize: The default card size for an unscaled card image.
    ///   - scaleFactor: The scale factor for the scaled card image.
    ///   - isUseFullCardImage: A boolean that indicates whether to create a full card image or a partial card image.
    /// - Returns: The scaled card image of the card.
    ///
    /// You can use this static method to create card images one by one instead of keeping an atlas of card images.
    public static func cardImageForCard(_ card:Card, defaultCardSize:CGSize, scaleFactor:CGFloat, isUseFullCardImage:Bool) -> WHImage {
        let cardImage:WHImage
        if isUseFullCardImage {
            let fullCardImageMaker = FullCardImageMaker(defaultCardSize: defaultCardSize, scaleFactor: scaleFactor)
            cardImage = fullCardImageMaker.makeCardImageFor(rank: card.rank, suit: card.suit)
        }
        else {
            let partialCardImageMaker = PartialCardImageMaker(defaultCardSize: defaultCardSize, scaleFactor: scaleFactor)
            cardImage = partialCardImageMaker.makeCardImageFor(rank: card.rank, suit: card.suit)
        }
        return cardImage
    }
}
