/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Generic text cell
*/

import UIKit

class TextCell: UICollectionViewCell {
    let label = UIButton()
    static let reuseIdentifier = "text-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
}

extension TextCell {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.titleLabel!.adjustsFontForContentSizeCategory = true
        contentView.addSubview(label)
        label.titleLabel!.font = UIFont.preferredFont(forTextStyle: .caption1)
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
            ])
    }
}

extension TextCell {
    override func updateConfiguration(using state: UICellConfigurationState) {
        var background = defaultBackgroundConfiguration().updated(for: state)
        background.backgroundColor = UIColor.green
        background.backgroundInsets = state.isFocused ? NSDirectionalEdgeInsets(top: -5, leading: -5, bottom: -5, trailing: -5) : .zero
        background.visualEffect = UIBlurEffect(style: .light)
        background.strokeWidth = state.isFocused ? 5 : 0
        #if os(iOS)
            background.strokeColor = state.isFocused ? .black : .clear
        #else
            background.strokeColor = state.isFocused ? .white : .clear
        #endif
        background.cornerRadius = 20
        backgroundConfiguration = background
    }
}
