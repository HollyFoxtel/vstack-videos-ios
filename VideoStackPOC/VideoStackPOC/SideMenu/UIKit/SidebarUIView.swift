import UIKit

class Sidebar: UIView {
    let sidebarWidth: CGFloat = 250
    var sidebarLeadingConstraint: NSLayoutConstraint!
    var menuItems: [UIButton] = []
    var currentFocusedItemIndex: Int = 0
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .darkGray
        setupMenuItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMenuItems() {
        let items = ["Home", "Search", "Library", "Settings"]
        var previousButton: UIButton?
        
        for (index, item) in items.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(item, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.addTarget(self, action: #selector(menuItemTapped(_:)), for: .primaryActionTriggered)
            self.addSubview(button)
            menuItems.append(button)
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
            ])
            
            if let previousButton = previousButton {
                button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: 16).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: self.topAnchor, constant: 100).isActive = true
            }
            
            previousButton = button
        }
    }
    
    @objc func menuItemTapped(_ sender: UIButton) {
        // 处理点击事件
//        NotificationCenter.default.post(name: .sidebarItemTapped, object: nil)
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
}
