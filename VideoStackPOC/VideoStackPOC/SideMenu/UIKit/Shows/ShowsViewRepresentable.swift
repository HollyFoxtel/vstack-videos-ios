import SwiftUI
import UIKit

struct ShowsViewRepresentable: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> some UIViewController {
        
        let vm = HomeViewModel(home: true) { _ in
//            self?.showDetail()
        }
        
        let viewController = ShowsViewController(viewModel: vm)
//        viewController.dismissAction = {
//            presentationMode.wrappedValue.dismiss()
//        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
