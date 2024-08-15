import SwiftUI
import UIKit

struct SideMenuControllerRepresentable: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = HomeCustomViewController()
        viewController.dismissAction = {
            presentationMode.wrappedValue.dismiss()
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct SplitViewControllerRepresentable: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = HomeSplitViewController(style: .doubleColumn)
        viewController.dismissAction = {
            presentationMode.wrappedValue.dismiss()
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct LSideMenuDemo: View {
    let useCustomView = false
    
    var body: some View {
        if useCustomView {
            SideMenuControllerRepresentable()
        } else {
            SplitViewControllerRepresentable()
        }
    }
}
