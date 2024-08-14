import SwiftUI

struct ShowChannels: View {
    var body: some View {
        TileContainer(assets: Array(ShowAsset.allCases))
    }
}

#Preview {
    ShowChannels()
}
