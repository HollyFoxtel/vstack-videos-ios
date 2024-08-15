import UIKit

class ContentViewController: UIViewController, BackgroundContent {
    var dismissAction: (() -> Void)?
    private let contentLabel = UILabel()
    private let instructionLabel = UILabel()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupBackgroundImage()
        setupDismissButton()
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .primaryActionTriggered)
        
        contentLabel.text = "MainView"
        contentLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        contentLabel.textAlignment = .center
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentLabel)
        
        instructionLabel.text = "Press Key to show side menu"
        instructionLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        instructionLabel.textAlignment = .center
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionLabel)
        
        NSLayoutConstraint.activate([
            contentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentLabel.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 20),
            
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 20)
        ])
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        if context.nextFocusedView?.isDescendant(of: self.view) == true {
            UIView.animate(withDuration: 0.3) {
                self.instructionLabel.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.instructionLabel.alpha = 0.0
            }
        }
    }
}

extension ContentViewController {
    @objc func dismissTapped() {
        self.dismissAction?()
    }
}
