//
//  VerticalFeedView.swift
//  VideoStackPOC
//
//  Created by Rajesh Ramachandrakurup on 7/8/2024.
//

import SwiftUI

struct Feed: Codable {
    let title: String
    let description: String
    let url: URL
}

struct VerticalFeedView: View {
    @State private var feeds: [Feed] = []
    @State private var fullyVisibleIndices: Set<Int> = []

    private let manager = VideoPlayerManager()

    var body: some View {
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(0..<feeds.count, id: \.self) { i in
                        ZStack {
                            Rectangle()
                                .fill(Color.black)
                            VideoView(index: i+1, feed: feeds[i], manager: manager)
                                .containerRelativeFrame([.horizontal, .vertical])

                        }
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .preference(key: ViewOffsetKey.self, value: [ViewOffsetData(index: i, frame: geometry.frame(in: .global))])
                            }
                        )
                    }
                }
                .scrollTargetLayout()
            }
            .background(.black)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .ignoresSafeArea()
            .onPreferenceChange(ViewOffsetKey.self) { values in
                viewOffsetHandle(values: values)
            }
            .onAppear {
                loadFeeds()
            }
    }

    func loadFeeds() {
        DispatchQueue.global().async {
            let data = try! Data(contentsOf: Bundle.main.url(forResource: "feed", withExtension: "json")!)
            let output = try! JSONDecoder().decode([Feed].self, from: data)
            DispatchQueue.main.async {
                self.feeds = output
            }
        }
    }

    private func viewOffsetHandle(values: [ViewOffsetData]) {
        let screenBounds = UIScreen.main.bounds
        let visible = values.filter { $0.frame.intersects(screenBounds) && isFullyVisible($0.frame, screenBounds)  }.map { $0.index }
        let newVisibleIndices = Set(visible)

        // Items that have just appeared
        let appearedIndices = newVisibleIndices.subtracting(fullyVisibleIndices)
        for index in appearedIndices {
            print("Item \(index) appeared")
            manager.activate(url: feeds[index].url)
        }

        // Items that have just disappeared
        let disappearedIndices = fullyVisibleIndices.subtracting(newVisibleIndices)
        for index in disappearedIndices {
            print("Item \(index) disappeared")
        }
        fullyVisibleIndices = newVisibleIndices
    }

    private func isFullyVisible(_ itemFrame: CGRect, _ screenBounds: CGRect) -> Bool {
        itemFrame.minY >= screenBounds.minY && itemFrame.maxY <= screenBounds.maxY
    }
}

#Preview {
    VerticalFeedView()
}

struct ViewOffsetData: Equatable {
    let index: Int
    let frame: CGRect
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = [ViewOffsetData]
    static var defaultValue: [ViewOffsetData] = []
    static func reduce(value: inout [ViewOffsetData], nextValue: () -> [ViewOffsetData]) {
        value.append(contentsOf: nextValue())
    }
}
