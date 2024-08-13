import SwiftUI

struct LatestMinis: View {
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 40) {
                ForEach(MinisAsset.allCases) { asset in
                    Button {} label: {
                        asset.image
                            .resizable()
                            .aspectRatio(768 / 432, contentMode: .fit)
                            .containerRelativeFrame(.horizontal, count: 5, spacing: 50)
                    }
                }
            }
        }
        .scrollClipDisabled()
        .buttonStyle(.borderless)
    }
}

#Preview {
    LatestMinis()
}
