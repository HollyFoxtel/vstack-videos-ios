import UIKit

class HomeSplitViewController: UISplitViewController {
    private var isMenuVisible = false
    private var widthFraction = 0.17
    var dismissAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredDisplayMode = .secondaryOnly
        // Here: We make side menu floating
        self.preferredSplitBehavior = .overlay
        self.preferredPrimaryColumnWidthFraction = widthFraction
        
        let menuViewController = MenuViewController()
        let contentViewController = ContentViewController()
        contentViewController.dismissAction = dismissAction
        self.setViewController(menuViewController, for: .primary)
        self.setViewController(contentViewController, for: .secondary)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let press = presses.first else {
            super.pressesBegan(presses, with: event)
            return
        }
        
        if press.type.rawValue == 2080 {
            if !isMenuVisible {
                showMenu()
            }
            return
        }
        
        switch press.type {
        case .leftArrow:
            if !isMenuVisible {
                showMenu()
            }
        case .rightArrow:
            if isMenuVisible {
                hideMenu()
            }
        default:
            super.pressesBegan(presses, with: event)
        }
    }
    
    func showMenu() {
        UIView.animate(withDuration: 0.3) {
            self.preferredDisplayMode = .oneOverSecondary
            self.preferredPrimaryColumnWidthFraction = self.widthFraction
        }
        isMenuVisible = true
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.3) {
            self.preferredDisplayMode = .secondaryOnly
        }
        isMenuVisible = false
    }
}
