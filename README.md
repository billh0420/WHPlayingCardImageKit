# WHPlayingCardImageKit


A swift package to make 52 playing card images for a given scale factor.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbillh0420%2FWHPlayingCardImageKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/billh0420/WHPlayingCardImageKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbillh0420%2FWHPlayingCardImageKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/billh0420/WHPlayingCardImageKit)

## Features
- [x] The card images can be created scaled.
- [x] A card back image can be created scaled.
- [x] All card images can be created in the background.
- [x] The package is cross platform.

## Installation
To install the `WHPlayingCardImageKit` package, use the following guidelines of Apple to add package dependency to your Xcode project.

To add a package dependency to your Xcode project, select File > Add Packages and enter its repository URL.
You can also navigate to your target’s General pane, and in the “Frameworks, Libraries, and Embedded Content” section, click the + button,
select Add Other, and choose Add Package Dependency.

You can also navigate to your project's pane, select "Package Dependencies", click the + button,
enter the repository URL into the Search field, and choose Add Package Dependency.

## Usage examples
### Creating one card image

```swift

import Foundation
import WHPlayingCardImageKit
import WHCrossPlatformKit

func createCardImageQS() -> WHImage {
    let defaultCardSize = CardImageAtlas.cardImageAtlasDefaultCardSize
    let scaleFactor:CGFloat = 2.5
    let fullCardImageMaker = FullCardImageMaker(defaultCardSize: defaultCardSize, scaleFactor: scaleFactor)
    let cardImageQS = fullCardImageMaker.makeCardImageFor(rank: .queen, suit: .spades)
    return cardImageQS
}
```

### Creating a pinochle deck and its card images

```swift

import Foundation
import WHPlayingCardImageKit
import WHCrossPlatformKit

func createPinochleDeck() -> [Card] {
    var pinochleDeck:[Card] = []
    let pinochleRanks:[Rank] = [.nine, .jack, .queen, .king, .ten, .ace]
    for suit in Suit.all4Suits {
        for rank in pinochleRanks {
            for packId in 0 ..< 2 {
                let card = Card(rank: rank, suit: suit, packId: packId)
                pinochleDeck.append(card)
            }
        }
    }
    return pinochleDeck
}

// Note only 24 images are created.
// The same card from different packs can share the same common card image.
func createPinochleCardImageAtlas(pinochleDeck: [Card], scaleFactor: CGFloat) -> Dictionary<String, WHImage> {
    var pinochleCardImageAtlas:[String: WHImage] = [:]
    let defaultCardSize = CardImageAtlas.cardImageAtlasDefaultCardSize
    let fullCardImageMaker = FullCardImageMaker(defaultCardSize: defaultCardSize, scaleFactor: scaleFactor)
    for card in pinochleDeck {
        if card.packId == 0 {
            let cardImage = fullCardImageMaker.makeCardImageFor(rank: card.rank, suit: card.suit)
            pinochleCardImageAtlas[card.name] = cardImage
        }
    }
    return pinochleCardImageAtlas
}
```
