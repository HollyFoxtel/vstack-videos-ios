import SwiftUI

enum ShowAsset: String, AssetProtocol, Identifiable {
    case boxset
    case color
    case fletch
    case inside
    case netball
    case qtr
    case youkayi
    case mvp
    

    var id: Self { self }

    var title: String {
        rawValue.capitalized
    }

    var image: Image {
        Image("show_" + rawValue.lowercased())
    }

    var keywords: [String] {
        switch self {
        case .boxset:
            ["nature", "boxset", "box", "set", "b"]
        default: []
        }
    }

    static var lookupTable: [String: [ShowAsset]] {
        var result: [String: [ShowAsset]] = [:]
        for asset in allCases {
            for keyword in asset.keywords {
                result[keyword, default: []].append(asset)
            }
        }
        return result
    }
}
