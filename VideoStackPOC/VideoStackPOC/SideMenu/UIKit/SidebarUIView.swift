import UIKit

protocol SidebarDelegate: AnyObject {
    func sidebarItemTapped(index: Int)
}

class Sidebar: UIView {
    let sidebarWidth: CGFloat = 250
    var sidebarLeadingConstraint: NSLayoutConstraint!
    var menuItems: [UIButton] = []
    var currentFocusedItemIndex: Int = 0
    weak var delegate: SidebarDelegate?
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        self.layer.cornerRadius = 10
        setupMenuItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMenuItems() {
        let items = [("Shows", "play.rectangle.fill"), ("Home", "house.fill"), ("Sports", "sportscourt.fill"),
                     ("Search", "magnifyingglass"), ("Favourites", "star.fill"), ("My Kayo", "gearshape.fill")]
        var previousButton: UIButton?
        
        for (index, item) in items.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(item.0, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.setImage(UIImage(systemName: item.1), for: .normal)
            button.tintColor = .white
            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.addTarget(self, action: #selector(menuItemTapped(_:)), for: .primaryActionTriggered)
            self.addSubview(button)
            menuItems.append(button)
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])
            
            if let previousButton = previousButton {
                button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: 16).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
            }
            
            previousButton = button
        }

        menuItems[currentFocusedItemIndex].becomeFirstResponder()
    }
    
    @objc func menuItemTapped(_ sender: UIButton) {
        delegate?.sidebarItemTapped(index: sender.tag)
    }
    
    func focusNextItem() {
        if currentFocusedItemIndex < menuItems.count - 1 {
            currentFocusedItemIndex += 1
            menuItems[currentFocusedItemIndex].becomeFirstResponder()
        }
    }
    
    func focusPreviousItem() {
        if currentFocusedItemIndex > 0 {
            currentFocusedItemIndex -= 1
            menuItems[currentFocusedItemIndex].becomeFirstResponder()
        }
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        if let nextFocusedView = context.nextFocusedView as? UIButton, menuItems.contains(nextFocusedView) {
            currentFocusedItemIndex = nextFocusedView.tag
        }
    }
}
