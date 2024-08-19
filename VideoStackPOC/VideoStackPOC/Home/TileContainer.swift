import SwiftUI

struct TileContainer<Asset: AssetProtocol>: View {
    let assets: [Asset]
    
    @FocusState private var focusedIndex: Asset.ID?
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 40) {
                    ForEach(assets) { asset in
                        Button {} label: {
                            asset.image
                                .resizable()
                                .aspectRatio(768 / 432, contentMode: .fit)
                                .containerRelativeFrame(.horizontal, count: 5, spacing: 50)
                        }
                        .focused($focusedIndex, equals: asset.id)
                        .id(asset.id)
                    }
                }
            }
            .scrollClipDisabled()
            .buttonStyle(.borderless)
            .onChange(of: focusedIndex) { newID in
                withAnimation {
                    scrollProxy.scrollTo(newID, anchor: .leading)
                }
            }
        }
    }
}
