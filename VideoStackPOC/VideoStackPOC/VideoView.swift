//
//  VideoView.swift
//  VideoStackPOC
//
//  Created by Rajesh Ramachandrakurup on 7/8/2024.
//

import SwiftUI
import AVKit
import Combine

struct OverlayView: View {
    @State private var isPlaying: Bool = true
    @StateObject var playerObserver: PlayerObserver
    var body: some View {
       ZStack {
           VStack {
               HStack {
                   Spacer()
                   Image(uiImage: UIImage(named: "logo")!)
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .opacity(0.5)
                       .frame(width: 50, height: 50)
                       .padding(.trailing, 15)
                       .padding(.top, 25)
               }
               Spacer()
           }
            Rectangle()
               .fill(.white.opacity(0.001))
           if !playerObserver.isPlaying {
                FeedIcon(name: "play.circle.fill")
            }
        }
    }
}

struct VideoView: View {
    let index: Int
    let feed: Feed
    let manager: VideoPlayerManager

    init(index: Int, feed: Feed, manager: VideoPlayerManager) {
        self.index = index
        self.feed = feed
        self.manager = manager
    }

    var body: some View {
        ZStack {
            CustomVideoPlayerView(player: manager.player(for: feed.url))
            OverlayView(playerObserver: PlayerObserver(player: manager.player(for: feed.url)))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    manager.toggle(url: feed.url)
                }
            HStack {
                VStack {
                    Spacer()
                    HStack {
                        Text(feed.title)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .shadow(radius: 2)
                            .padding(.bottom, 5)
                        Spacer()
                    }
                    HStack {
                        Text(feed.description)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.white)
                            .shadow(color: .black, radius: 2)
                        Spacer(minLength: 25)
                    }
                }
                Spacer()
                VStack(spacing: 25) {
                    Spacer()
                    FeedIcon(name: "bookmark.fill")
                    FeedIcon(name: "arrowshape.turn.up.right.fill")
                    FeedIcon(name: "lines.measurement.horizontal")
                }
            }
            .padding(.bottom, 35)
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    @State var value: Bool = true
    return VideoView(
        index: 1,
        feed:.init(title: "Hi", description: "A thrilling game moment captured in high definition, unforgettable.", url: URL(string: "https://videos.pexels.com/video-files/8224589/8224589-hd_720_1280_30fps.mp4")!),
        manager: VideoPlayerManager()
    )
    .background(.black)
}

struct FeedIcon: View {
    let name: String
    var body: some View {
        Image(systemName: name)
            .resizable()
            .foregroundStyle(.white)
            .shadow(radius: 2)
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
    }
}
