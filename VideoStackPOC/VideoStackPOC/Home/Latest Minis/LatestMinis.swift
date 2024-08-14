import SwiftUI

struct LatestMinis: View {
    var body: some View {
        TileContainer(assets: Array(MinisAsset.allCases))
    }
}

#Preview {
    LatestMinis()
}
