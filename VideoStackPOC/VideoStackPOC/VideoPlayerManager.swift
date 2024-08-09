//
//  VideoPlayerManager.swift
//  VideoStackPOC
//
//  Created by Rajesh Ramachandrakurup on 7/8/2024.
//

import Foundation
import SwiftUI
import AVKit
import Combine

final class VideoPlayerManager: ObservableObject {
    var players: [URL: AVQueuePlayer] = [:]
    var loopPlayer: AVPlayerLooper?
    var currentUrl: URL?

    func player(for url: URL) -> AVQueuePlayer {
        if let player = players[url] {
            player.pause()
            player.isMuted = true
            return player
        } else {
            let item = AVPlayerItem(url: url)
            let player = AVQueuePlayer(playerItem: item)
            players[url] = player
            player.pause()
            player.isMuted = true
            return player
        }
    }

    func activate(url: URL) {
        if url == currentUrl { return }
        if let currentUrl {
            players[currentUrl]?.pause()
        }
        loopPlayer = nil
        guard let player = players[url], let item = player.currentItem else { return }
        loopPlayer = AVPlayerLooper(player: player, templateItem: item)
        player.play()
        player.isMuted = false
        currentUrl = url
    }

    func toggle(url: URL) {
        if players[url]?.rate == 0.0 {
            players[url]?.play()
        } else {
            players[url]?.pause()
        }
    }
}


class PlayerObserver: ObservableObject {
    @Published var isPlaying: Bool = false

    private var player: AVPlayer
    private var observer: NSKeyValueObservation?

    init(player: AVPlayer) {
        self.player = player
        self.observer = player.observe(\.rate, options: [.new]) { [weak self] player, change in
            self?.isPlaying = player.rate != 0
        }
    }

    deinit {
        observer?.invalidate()
    }
}
