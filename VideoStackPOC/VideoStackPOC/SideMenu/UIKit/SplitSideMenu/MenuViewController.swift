import UIKit

class MenuViewController: UIViewController {
    private let stackView = UIStackView()
    private let menuItems: [MenuItem] = KayoTab.allCases.map { $0.toMenuItem }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -30)
        ])
        
        for item in menuItems {
            let button = UIButton(type: .system)
            button.setTitle(item.name, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.setImage(UIImage(systemName: item.icon), for: .normal)
            button.tintColor = .white
            button.contentHorizontalAlignment = .left
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            button.addTarget(self, action: #selector(menuItemTapped(_:)), for: .primaryActionTriggered)
            button.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(button)

            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalTo: stackView.widthAnchor)
            ])

            button.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    }
    
    @objc private func menuItemTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
    }
}
