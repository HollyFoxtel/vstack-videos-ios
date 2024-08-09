//
//  CustomVideoPlayerView.swift
//  VideoStackPOC
//
//  Created by Rajesh Ramachandrakurup on 7/8/2024.
//

import SwiftUI
import AVKit

struct CustomVideoPlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        PlayerUIView(player: player)
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Handle updates if needed
    }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()

    init(player: AVPlayer) {
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        super.init(frame: .zero)
        layer.addSublayer(playerLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
