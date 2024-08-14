import SwiftUI

enum MinisAsset: String, AssetProtocol, Identifiable {
    case nelly
    case panthers
    case rabbitohs
    case raiders
    case features
    case retro
    case topplayer

    var id: Self { self }

    var title: String {
        rawValue.capitalized
    }

    var image: Image {
        Image("mini_" + rawValue.lowercased())
    }

    var keywords: [String] {
        switch self {
        case .nelly:
            ["nature", "nelly", "n", "mvp", "n"]
        default: []
        }
    }

    static var lookupTable: [String: [Self]] {
        var result: [String: [Self]] = [:]
        for asset in allCases {
            for keyword in asset.keywords {
                result[keyword, default: []].append(asset)
            }
        }
        return result
    }
}
