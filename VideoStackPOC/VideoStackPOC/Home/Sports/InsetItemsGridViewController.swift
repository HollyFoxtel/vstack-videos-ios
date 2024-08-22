/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A list with inset item content described by compositional layout
*/

import UIKit

class InsetItemsGridViewController: UIViewController {

    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Inset Items Grid"
        configureHierarchy()
        configureDataSource()
    }
}

/// Data & Loading
extension InsetItemsGridViewController {
    func loadData(into dateSource: UICollectionViewDiffableDataSource<Int, Int>) {
        dataSource.apply(
            // oneSectionSnapshot(),
            twoSectionsSnapshot(),
            animatingDifferences: false
        )
    }

    func twoSectionsSnapshot() -> NSDiffableDataSourceSnapshot<Int, Int> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()

        snapshot.appendSections([1])
        snapshot.appendItems(Array(0...49))
        snapshot.appendSections([2])
        snapshot.appendItems(Array(50...99))

        return snapshot
    }

    func oneSectionSnapshot() -> NSDiffableDataSourceSnapshot<Int, Int> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()

        snapshot.appendSections([1])
        snapshot.appendItems(Array(0...99))

        return snapshot
    }
}

/// Layout
extension InsetItemsGridViewController {

    /// - Tag: Inset
    func createLayout() -> UICollectionViewLayout {
        oneRowLayout()
    }

    /// doesn't work
    func twoRowsLayoutV2() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     repeatingSubitem: item,
                                                     count: 2)

        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        // scroll horizontally
        section.orthogonalScrollingBehavior = .groupPaging

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    /// doesn't work
    func twoRowsLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])


        let section = NSCollectionLayoutSection(group: group)


        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func oneRowLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(0.2))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])

            let section = NSCollectionLayoutSection(group: group)

            // scroll horizontally
            section.orthogonalScrollingBehavior = .groupPaging

            return section
        }

    }
}

extension InsetItemsGridViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
    }
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.label.setTitle("\(identifier)", for: .normal)
            cell.contentView.backgroundColor = .cornflowerBlue
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.label.titleLabel!.textAlignment = .center
            cell.label.titleLabel!.font = UIFont.preferredFont(forTextStyle: .title1)
        }

        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }

        loadData(into: dataSource)
    }
}
