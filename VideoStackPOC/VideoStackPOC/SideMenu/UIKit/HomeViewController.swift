import UIKit

class HomeViewController: UIViewController {
    let sidebarWidth: CGFloat = 250
    var sidebarLeadingConstraint: NSLayoutConstraint!
    var dismissAction: (() -> Void)?
    
    let sidebar: Sidebar = {
        let view = Sidebar()
        return view
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let homeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Home", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        view.clipsToBounds = true
        
        setupScrollView()
        setupSidebar()
        setupHomeButton()
        setupDismissButton()
        setupFocusGuide()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    func setupFocusGuide() {
        let focusGuideToDissmis = UIFocusGuide()
        let focusGuideToHome = UIFocusGuide()
        view.addLayoutGuide(focusGuideToDissmis)
        view.addLayoutGuide(focusGuideToHome)

        focusGuideToDissmis.leadingAnchor.constraint(equalTo: homeButton.trailingAnchor).isActive = true
        focusGuideToDissmis.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor).isActive = true
        focusGuideToDissmis.centerYAnchor.constraint(equalTo: homeButton.centerYAnchor).isActive = true
        focusGuideToDissmis.heightAnchor.constraint(equalToConstant: 1).isActive = true
        focusGuideToDissmis.preferredFocusEnvironments = [dismissButton]
        
        focusGuideToHome.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor).isActive = true
        focusGuideToHome.leadingAnchor.constraint(equalTo: homeButton.trailingAnchor).isActive = true
        focusGuideToHome.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor).isActive = true
        focusGuideToHome.heightAnchor.constraint(equalToConstant: 1).isActive = true
        focusGuideToHome.preferredFocusEnvironments = [homeButton]
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupSidebar() {
        view.addSubview(sidebar)
        sidebar.sidebarLeadingConstraint = sidebar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -sidebar.sidebarWidth)
        NSLayoutConstraint.activate([
            sidebar.sidebarLeadingConstraint,
            sidebar.widthAnchor.constraint(equalToConstant: sidebar.sidebarWidth),
            sidebar.topAnchor.constraint(equalTo: view.topAnchor),
            sidebar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupHomeButton() {
        view.addSubview(homeButton)
        NSLayoutConstraint.activate([
            homeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            homeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
        homeButton.addTarget(self, action: #selector(toggleSidebar), for: .touchUpInside)
    }
    
    func setupDismissButton() {
        view.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .primaryActionTriggered)
        
    }
    
    @objc func dismissTapped() {
        self.dismissAction?()
    }
    
    @objc func toggleSidebar() {
        let isSidebarOpen = sidebar.sidebarLeadingConstraint.constant == 0
        sidebar.sidebarLeadingConstraint.constant = isSidebarOpen ? -sidebar.sidebarWidth : 0
        homeButton.isHidden = !isSidebarOpen
        if !isSidebarOpen {
            sidebar.menuItems[sidebar.currentFocusedItemIndex].becomeFirstResponder()
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleSwipeLeft() {
        if scrollView.contentOffset.x + scrollView.frame.size.width < scrollView.contentSize.width {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + scrollView.frame.size.width, y: 0), animated: true)
        } else {
            sidebar.sidebarLeadingConstraint.constant = 0
            homeButton.isHidden = true
            sidebar.menuItems[sidebar.currentFocusedItemIndex].becomeFirstResponder()
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func handleSwipeRight() {
        sidebar.sidebarLeadingConstraint.constant = -sidebar.sidebarWidth
        homeButton.isHidden = false
        homeButton.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleSidebarItemTapped() {
        sidebar.sidebarLeadingConstraint.constant = -sidebar.sidebarWidth
        homeButton.isHidden = false
        homeButton.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        super.pressesBegan(presses, with: event)
        
        guard let press = presses.first else { return }
        
        switch press.type {
        case .leftArrow:
            handleSwipeLeft()
        case .rightArrow:
            handleSwipeRight()
        case .upArrow:
            sidebar.focusPreviousItem()
        case .downArrow:
            sidebar.focusNextItem()
        default:
            break
        }
    }
}
