//
//  ViewControllerRepresentable.swift
//  tvOSCollectionViewCompositionalLayout
//
//  Created by Nicholas Clooney on 21/8/2024.
//

import UIKit
import SwiftUI

struct ViewControllerRepresentable<ViewController: UIViewController>: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    typealias ViewControllerFactory = (Context) -> ViewController

    private let factory: ViewControllerFactory

    init(viewControllerFactory factory: @escaping ViewControllerFactory) {
        self.factory = factory
    }

    func makeUIViewController(context: Context) -> ViewController {
        factory(context)
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}
