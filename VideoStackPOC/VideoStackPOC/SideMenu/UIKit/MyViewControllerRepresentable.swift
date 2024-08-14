import SwiftUI
import UIKit

struct SideMenuControllerRepresentable: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = HomeViewController()
        viewController.dismissAction = {
               presentationMode.wrappedValue.dismiss()
           }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

