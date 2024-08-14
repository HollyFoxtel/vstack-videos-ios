import SwiftUI

struct LiveChannels: View {
    var body: some View {
        TileContainer(assets: Array(LiveAsset.allCases))
    }
}

#Preview {
    LiveChannels()
}
