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
        button.setImage(UIImage(systemName: "house.fill"), for: .normal)
        button.tintColor = .white
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        button.layer.cornerRadius = 10
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
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "beach_landscape")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        view.backgroundColor = .white
        
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
            sidebar.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            sidebar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        sidebar.delegate = self
    }
    
    func setupHomeButton() {
        view.addSubview(homeButton)
        NSLayoutConstraint.activate([
            homeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            homeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            homeButton.heightAnchor.constraint(equalToConstant: 70),
            homeButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        homeButton.addTarget(self, action: #selector(toggleSidebar), for: .primaryActionTriggered)
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
        
        if isSidebarOpen {
            UIView.animate(withDuration: 0.3, animations: {
                self.sidebar.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.sidebar.alpha = 0
            }) { _ in
                self.sidebar.sidebarLeadingConstraint.constant = -self.sidebar.sidebarWidth
                self.sidebar.transform = .identity
                self.sidebar.alpha = 1
                self.homeButton.isHidden = false
                self.view.layoutIfNeeded()
            }
        } else {
            self.sidebar.sidebarLeadingConstraint.constant = 0
            self.view.layoutIfNeeded()
            sidebar.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            sidebar.alpha = 0
            homeButton.isHidden = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.sidebar.transform = .identity
                self.sidebar.alpha = 1
            }) { _ in
                self.sidebar.menuItems[self.sidebar.currentFocusedItemIndex].becomeFirstResponder()
            }
        }
    }
    
    @objc func handleSwipeLeft() {
        if scrollView.contentOffset.x + scrollView.frame.size.width < scrollView.contentSize.width {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + scrollView.frame.size.width, y: 0), animated: true)
        } else {
            toggleSidebar()
        }
    }
    
    @objc func handleSwipeRight() {
        toggleSidebar()
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
            if sidebar.sidebarLeadingConstraint.constant == 0 {
                sidebar.focusPreviousItem()
            }
        case .downArrow:
            if sidebar.sidebarLeadingConstraint.constant == 0 {
                sidebar.focusNextItem()
            }
        default:
            break
        }
    }
}

extension HomeViewController: SidebarDelegate {
    func sidebarItemTapped(index: Int) {
        sidebar.sidebarLeadingConstraint.constant = -sidebar.sidebarWidth
        homeButton.isHidden = false
        homeButton.becomeFirstResponder()
        toggleSidebar()
    }
}
