import SwiftUI

protocol AssetProtocol: CaseIterable, Identifiable {
    var image: Image { get }
}

enum LiveAsset: String, AssetProtocol {
    case foxRed
    case foxGreen
    case espn
    case news
    case racing
    case sports
    case w

    var id: Self { self }

    var title: String {
        rawValue.capitalized
    }

    var image: Image {
        Image("live_" + rawValue.lowercased())
    }

    var keywords: [String] {
        switch self {
        case .foxRed, .foxGreen:
            ["fox", "r", "live", "gril", "f"]
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
