import UIKit

// MARK: - Erased/Reusable

struct ShowsSection {
    let reusableView: (String, UICollectionView, IndexPath) -> UICollectionReusableView
    let cells: [Cell]
}

struct Cell {
    let configure: (UICollectionView, IndexPath) -> UICollectionViewCell
    let tapped: () -> Void
}

protocol ContentDataSourceProtocol: AnyObject {
    var layoutSection: NSCollectionLayoutSection { get }
    var onUpdate: () -> Void { get set }
    var section: ShowsSection { get }
    func register(in collectionView: UICollectionView)
}

class ContentViewModel {
    var dataSources: [ContentDataSourceProtocol] {
        didSet {
            updateViewState()
        }
    }

    var layout: UICollectionViewLayout {
        let layoutSections = dataSources.map(\.layoutSection)
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { index, _ in layoutSections[index] },
            configuration: configuration
        )
        return layout
    }

    var callback: ([ShowsSection]) -> Void = { _ in }

    init(dataSources: [ContentDataSourceProtocol]) {
        self.dataSources = dataSources
        for dataSource in dataSources {
            dataSource.onUpdate = { [weak self] in
                self?.updateViewState()
            }
        }
    }

    func register(in collectionView: UICollectionView) {
        for dataSource in dataSources {
            dataSource.register(in: collectionView)
        }
    }

    func updateViewState() {
        let sections = dataSources.map(\.section)
        callback(sections)
    }
}

class ContentCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    private(set) var sections: [ShowsSection] = []

    func tappedItem(at indexPath: IndexPath) {
        sections[indexPath.section].cells[indexPath.row].tapped()
    }

    func updateSections(_ newSections: [ShowsSection]) {
        sections = newSections
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].cells.count
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        sections[indexPath.section].reusableView(kind, collectionView, indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        sections[indexPath.section].cells[indexPath.row].configure(collectionView, indexPath)
    }
}

func makeLayoutSection(
    insets: NSDirectionalEdgeInsets,
    size: CGSize,
    horizontal: Bool = true,
    spacing: CGFloat = Style.spacing,
    scrollingBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuous
) -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(size.height)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
        widthDimension: size.width == .greatestFiniteMagnitude ? .fractionalWidth(1.0) : .absolute(size.width),
        heightDimension: .estimated(size.height)
    )
    let group = horizontal ? NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitems: [item]
    ) : .vertical(
        layoutSize: groupSize,
        subitems: [item]
    )

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = insets
    section.interGroupSpacing = spacing
    section.orthogonalScrollingBehavior = scrollingBehaviour
    return section
}

// Configuration

enum Style {
    static let backgroundColor = UIColor.black
    static let spacing = CGFloat(8)
    static let filterStackHeight = CGFloat(34)
    static let filterHeaderHeight = (filterStackHeight * 2) + (spacing * 3)
}

// Specific Implementation

class ShowsViewModel {
    enum NavigationAction {
        case showDetail
    }

    let contentViewModel: ContentViewModel = .init(dataSources: [])
    let heroDataSource: ContentDataSourceProtocol
    let season1EpisodeDataSource: ContentDataSourceProtocol
    let season2EpisodeDataSource: ContentDataSourceProtocol
    let bonusEpisodeDataSource: ContentDataSourceProtocol
    let deletedScenesEpisodeDataSource: ContentDataSourceProtocol
    let movieDataSource: ContentDataSourceProtocol
    let tvShow1DataSource: ContentDataSourceProtocol
    let tvShow2DataSource: ContentDataSourceProtocol
    let tvShow3DataSource: ContentDataSourceProtocol
    var filterGroupDataSource: FilterGroupDataSource!

    func updateContentViewModel(episodeDataSource: ContentDataSourceProtocol) {
        if home {
            contentViewModel.dataSources = [
                heroDataSource,
                movieDataSource,
                tvShow1DataSource,
                tvShow2DataSource,
                tvShow3DataSource,
            ]
        } else {
            contentViewModel.dataSources = [
                heroDataSource,
                filterGroupDataSource,
                episodeDataSource,
            ]
        }
    }

    var home: Bool

    init(home: Bool, navigationActionHandler: @escaping (NavigationAction) -> Void) {
        self.home = home
        let season1 = Identified<EpisodeGroup>(
            id: "ep1",
            content: EpisodeGroup(
                items: [
                    .init(
                        id: "ep1_it1",
                        content: .init(
                            color: .purple,
                            title: "Episode 1",
                            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
                        )
                    ),
                    .init(
                        id: "ep1_it2",
                        content: .init(
                            color: .red,
                            title: "Episode 2",
                            description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
                        )
                    ),
                    .init(
                        id: "ep1_it3",
                        content: .init(
                            color: .blue,
                            title: "Episode 3",
                            description: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
                        )
                    ),
                    .init(
                        id: "ep1_it4",
                        content: .init(
                            color: .systemPink,
                            title: "Episode 4",
                            description: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                        )
                    ),
                    .init(
                        id: "ep1_it5",
                        content: .init(
                            color: .systemMint,
                            title: "Episode 5",
                            description: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo."
                        )
                    ),
                ]
            )
        )
        let season2 = Identified<EpisodeGroup>(
            id: "ep2",
            content: EpisodeGroup(
                items: [
                    .init(
                        id: "ep2_it1",
                        content: .init(
                            color: .orange,
                            title: "Episode 1",
                            description: "Lorem ipsum dolor."
                        )
                    ),
                    .init(
                        id: "ep2_it2",
                        content: .init(
                            color: .yellow,
                            title: "Episode 2",
                            description: "Ut enim ad minim."
                        )
                    ),
                    .init(
                        id: "ep2_it3",
                        content: .init(
                            color: .cyan,
                            title: "Episode 3",
                            description: "Duis aute irure."
                        )
                    ),
                ]
            )
        )
        let bonus = Identified<EpisodeGroup>(
            id: "bn1",
            content: EpisodeGroup(
                items: [
                    .init(
                        id: "bn1_it1",
                        content: .init(
                            color: .gray,
                            title: "Bonus 1",
                            description: "Lorem ipsum dolor."
                        )
                    ),
                    .init(
                        id: "bn2_it2",
                        content: .init(
                            color: .gray,
                            title: "Bonus 2",
                            description: "Ut enim ad minim."
                        )
                    ),
                    .init(
                        id: "bn3_it3",
                        content: .init(
                            color: .gray,
                            title: "Bonus 3",
                            description: "Duis aute irure."
                        )
                    ),
                ]
            )
        )
        let deletedScenes = Identified<EpisodeGroup>(
            id: "ds1",
            content: EpisodeGroup(
                items: [
                    .init(
                        id: "ds1_it1",
                        content: .init(
                            color: .magenta,
                            title: "Deleted Scene 1",
                            description: "Lorem ipsum dolor."
                        )
                    ),
                    .init(
                        id: "ds2_it2",
                        content: .init(
                            color: .magenta,
                            title: "Deleted Scene 2",
                            description: "Ut enim ad minim."
                        )
                    ),
                    .init(
                        id: "ds3_it3",
                        content: .init(
                            color: .magenta,
                            title: "Deleted Scene 3",
                            description: "Duis aute irure."
                        )
                    ),
                ]
            )
        )
        heroDataSource = HeroGroupDataSource { target in
            print("HeroGroup navigation to \(target)")
        }
        season1EpisodeDataSource = EpisodeGroupDataSource(episodeGroup: season1) { target in
            print("Season1 navigation to \(target)")
        }
        season2EpisodeDataSource = EpisodeGroupDataSource(episodeGroup: season2) { target in
            print("Season2 navigation to \(target)")
        }
        bonusEpisodeDataSource = EpisodeGroupDataSource(episodeGroup: bonus) { target in
            print("Bonus navigation to \(target)")
        }
        deletedScenesEpisodeDataSource = EpisodeGroupDataSource(episodeGroup: deletedScenes) { target in
            print("Deleted scenes navigation to \(target)")
        }
        movieDataSource = MovieGroupDataSource { target in
            print("MovieGroup navigation to \(target)")
        }
        tvShow1DataSource = TvShowGroupDataSource { target in
            print("TvShowGroup navigation to \(target)")
            navigationActionHandler(.showDetail)
        }
        tvShow2DataSource = TvShowGroupDataSource { target in
            print("TvShowGroup navigation to \(target)")
            navigationActionHandler(.showDetail)
        }
        tvShow3DataSource = TvShowGroupDataSource { target in
            print("TvShowGroup navigation to \(target)")
            navigationActionHandler(.showDetail)
        }
        filterGroupDataSource = FilterGroupDataSource { target in
            print("FilterGroup navigation to \(target)")
        }
        filterGroupDataSource.changeHandlers.append { filterGroup in
            let subFilter = filterGroup.filters
                .first(where: \.content.isSelected)?
                .content
                .subFilters
                .first(where: \.content.isSelected)
            guard let subFilter else { return }
            switch subFilter.id.id {
            case "hr1_f1_sf1":
                self.updateContentViewModel(episodeDataSource: self.season1EpisodeDataSource)
            case "hr1_f2_sf1":
                self.updateContentViewModel(episodeDataSource: self.bonusEpisodeDataSource)
            case "hr1_f2_sf2":
                self.updateContentViewModel(episodeDataSource: self.deletedScenesEpisodeDataSource)
            default:
                self.updateContentViewModel(episodeDataSource: self.season2EpisodeDataSource)
            }
        }
        updateContentViewModel(episodeDataSource: season1EpisodeDataSource)
    }
}

class ShowsViewController: UIViewController, UICollectionViewDelegate {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private lazy var dataSource = ContentCollectionViewDataSource()
    private let viewModel: ShowsViewModel
    private lazy var filterView = FilterHeader()

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = Style.backgroundColor
        view.addSubview(collectionView)
        collectionView.backgroundColor = Style.backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        if !viewModel.home {
            filterView.translatesAutoresizingMaskIntoConstraints = false
            filterView.alpha = 0
            view.addSubview(filterView)
            NSLayoutConstraint.activate([
                filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                filterView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                filterView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                filterView.heightAnchor.constraint(equalToConstant: Style.filterHeaderHeight),
            ])

            filterView.backgroundColor = Style.backgroundColor
            viewModel.filterGroupDataSource.configureStatic(filterView)
        }
        collectionView.collectionViewLayout = viewModel.contentViewModel.layout
        viewModel.contentViewModel.register(in: collectionView)

        // Do any additional setup after loading the view.
        viewModel.contentViewModel.callback = { [weak self] sections in
            self?.dataSource.updateSections(sections)
            self?.collectionView.reloadData()
        }
        viewModel.contentViewModel.updateViewState()
    }

    init(viewModel: ShowsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        true
    }

    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        return true
    }

    func collectionView(_: UICollectionView, shouldSelectItemAt _: IndexPath) -> Bool {
        true
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource.tappedItem(at: indexPath)
    }

    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        [collectionView]
    }

    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with _: UIFocusAnimationCoordinator) {
        if let previousIndexPath = context.previouslyFocusedIndexPath,
           let cell = collectionView.cellForItem(at: previousIndexPath)
        {
            cell.contentView.layer.borderWidth = 0.0
            cell.contentView.layer.shadowRadius = 0.0
            cell.contentView.layer.shadowOpacity = 0
        }

        if let indexPath = context.nextFocusedIndexPath,
           let cell = collectionView.cellForItem(at: indexPath)
        {
            cell.contentView.layer.borderWidth = 8.0
            cell.contentView.layer.borderColor = UIColor.white.cgColor
            cell.contentView.layer.shadowColor = UIColor.white.cgColor
            cell.contentView.layer.shadowRadius = 10.0
            cell.contentView.layer.shadowOpacity = 0.9
            cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
            collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        filterView.alpha = scrollView.contentOffset.y >= 300 ? 1 : 0
    }
}

// Domain

struct Identifier<T>: Equatable, Hashable {
    let id: String
}

struct Identified<T: Equatable>: Equatable {
    let id: Identifier<T>
    var content: T
}

extension Identified {
    init(id: String, content: T) {
        self.id = .init(id: id)
        self.content = content
    }
}

// MARK: - HeroGroup

struct HeroGroup: Equatable {
    let items: [Identified<Item>]

    struct Item: Equatable {
        struct View: Equatable {
            let color: UIColor
            let title: String
        }

        let views: [View]
    }
}

class FocusableView: UIView {
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        if context.nextFocusedView == self {
            layer.borderWidth = 4
            layer.borderColor = UIColor.white.cgColor
        } else {
            layer.borderWidth = 0
        }
    }
}

class HeroCell: UICollectionViewCell {
    private var models: [HeroGroup.Item.View] = []
    private lazy var pageControl = UIPageControl()
    private lazy var label = UILabel()
    private var leftFocusGuide: UIFocusGuide!
    private var focusableView: FocusableView!
    
    var index = 0 {
        didSet {
            UIView.transition(with: contentView, duration: 0.3) {
                self.focusableView.backgroundColor = self.models[self.index].color
                self.label.text = self.models[self.index].title
                self.pageControl.currentPage = self.index
                self.updateFoucus()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        focusableView = FocusableView()
        focusableView.isUserInteractionEnabled = true
        focusableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(focusableView)
    }
    
    @objc private func swipedLeft() {
        index = (index + 1) % pageControl.numberOfPages
    }

    @objc private func swipedRight() {
        if index > 0 {
            index = index - 1
        } else {
            index = pageControl.numberOfPages - 1
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupFocusableView()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.shadowColor = .black
        label.shadowOffset = .init(width: 2, height: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        focusableView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: focusableView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: focusableView.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: focusableView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(lessThanOrEqualTo: focusableView.trailingAnchor, constant: -10),
        ])
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        focusableView.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: focusableView.bottomAnchor, constant: -16),
            pageControl.centerXAnchor.constraint(equalTo: focusableView.centerXAnchor),
        ])
    }

    func configure(with item: HeroGroup.Item) {
        models = item.views
        pageControl.numberOfPages = item.views.count
        pageControl.isUserInteractionEnabled = false
        label.text = item.views.first?.title
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        leftSwipeGesture.direction = .left
        focusableView.addGestureRecognizer(leftSwipeGesture)
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        rightSwipeGesture.direction = .right
        focusableView.addGestureRecognizer(rightSwipeGesture)
        focusableView.isUserInteractionEnabled = true
        index = 0
    }
    
    override var canBecomeFocused: Bool {
        return false
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        [focusableView]
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let press = presses.first else {
            super.pressesBegan(presses, with: event)
            return
        }
        
        switch press.type {
        case .leftArrow:
            if index > 0 {
                swipedRight()
            } else {
                super.pressesBegan(presses, with: event)
            }
        case .rightArrow:
            if index < models.count - 1 {
                swipedLeft()
            } else {
                super.pressesBegan(presses, with: event)
            }
        default:
            super.pressesBegan(presses, with: event)
        }
    }
    
    private func setupFocusGuide() {
        leftFocusGuide = UIFocusGuide()
        contentView.addLayoutGuide(leftFocusGuide)
        
        leftFocusGuide.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        leftFocusGuide.trailingAnchor.constraint(equalTo: focusableView.leadingAnchor).isActive = true
        leftFocusGuide.widthAnchor.constraint(equalToConstant: 1).isActive = true
        leftFocusGuide.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        leftFocusGuide.preferredFocusEnvironments = [focusableView]
    }
    
    private func setupFocusableView() {
        NSLayoutConstraint.activate([
            focusableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            focusableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            focusableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            focusableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        setupFocusGuide()
    }
    
    private func updateFoucus() {
        let isEnableFocusGuide = index != 0
        leftFocusGuide.isEnabled = isEnableFocusGuide
    }
}

extension ShowsSection {
    static func heroGroup(
        _ heroGroup: Identified<HeroGroup>,
        onItemTapped: @escaping (Identifier<HeroGroup.Item>) -> Void
    ) -> ShowsSection {
        .init(reusableView: { _, _, _ in
            .init(frame: .zero)
        }, cells: heroGroup.content.items.map { item in
            .hero(
                item,
                onTapped: onItemTapped
            )
        })
    }
}

extension Cell {
    static func hero(
        _ hero: Identified<HeroGroup.Item>,
        onTapped: @escaping (Identifier<HeroGroup.Item>) -> Void
    ) -> Cell {
        .init { collectionView, indexPath in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCell", for: indexPath) as? HeroCell else {
                return .init()
            }
            cell.configure(with: hero.content)
            return cell
        } tapped: {
            onTapped(hero.id)
        }
    }
}

class HeroGroupDataSource: ContentDataSourceProtocol {
    enum NavigationTarget {
        case showHero(Identifier<HeroGroup.Item>)
    }

    var onUpdate: () -> Void = {}
    var layoutSection: NSCollectionLayoutSection {
        let layoutSection = makeLayoutSection(
            insets: .zero,
            size: .init(width: CGFloat.greatestFiniteMagnitude, height: 300),
            spacing: 0,
            scrollingBehaviour: .paging
        )
        layoutSection.visibleItemsInvalidationHandler = { items, offset, _ in
            for item in items {
                item.transform = CGAffineTransform.identity.translatedBy(x: 0, y: max(offset.y, 0))
                item.zIndex = 0
                item.alpha = 1.0 - (offset.y / item.frame.height)
            }
        }
        return layoutSection
    }

    private var onNavigate: (NavigationTarget) -> Void
    private var heroGroup: Identified<HeroGroup>

    init(onNavigate: @escaping (NavigationTarget) -> Void) {
        self.onNavigate = onNavigate
        heroGroup = Identified<HeroGroup>(
            id: "hr1",
            content: HeroGroup(
                items: [
                    Identified<HeroGroup.Item>(
                        id: "hr1_it1",
                        content: .init(
                            views: [
                                .init(
                                    color: .purple,
                                    title: "Purple"
                                ),
                                .init(
                                    color: .brown,
                                    title: "Brown"
                                ),
                                .init(
                                    color: .orange,
                                    title: "Orange"
                                ),
                                .init(
                                    color: .darkGray,
                                    title: "Dark Gray"
                                ),
                            ]
                        )
                    ),
                ]
            )
        )
    }

    func register(in collectionView: UICollectionView) {
        collectionView.register(HeroCell.self, forCellWithReuseIdentifier: "HeroCell")
    }

    var section: ShowsSection {
        ShowsSection.heroGroup(heroGroup) { [weak self] id in
            self?.onNavigate(.showHero(id))
        }
    }
}

// MARK: - FilterGroup

struct FilterGroup: Equatable {
    struct Filter: Equatable {
        struct SubFilter: Equatable {
            let title: String
            var isSelected: Bool
        }

        let title: String
        let subFilters: [Identified<SubFilter>]
        var isSelected: Bool
    }

    let filters: [Identified<Filter>]
}

class FilterHeader: UICollectionReusableView {
    class ScrollableStackView: UIScrollView {
        private lazy var contentView = UIView()
        private lazy var stackView = UIStackView()

        var selectedFilter: (Identifier<FilterGroup.Filter>) -> Void = { _ in }
        var selectedSubFilter: (Identifier<FilterGroup.Filter.SubFilter>) -> Void = { _ in }

        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            contentView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(contentView)
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                contentView.widthAnchor.constraint(equalTo: widthAnchor),
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
                contentView.heightAnchor.constraint(equalToConstant: Style.filterStackHeight),
            ])

            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = Style.spacing
            stackView.distribution = .fillProportionally
            contentView.addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
                stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        }

        private func subFilterSelected(_ subFilter: Identifier<FilterGroup.Filter.SubFilter>, at index: Int) {
            selectedSubFilter(subFilter)
            stackView.arrangedSubviews.compactMap { $0 as? UIButton }.enumerated().forEach { x, button in
                button.isSelected = x == index
            }
        }

        func configure(with group: FilterGroup) {
            for arrangedSubview in stackView.arrangedSubviews {
                arrangedSubview.removeFromSuperview()
                stackView.removeArrangedSubview(arrangedSubview)
            }
            stackView.addArrangedSubview(UIView())
            for filter in group.filters {
                let button = UIButton(frame: .zero, primaryAction: .init(handler: { [weak self] _ in
                    self?.selectedFilter(filter.id)
                }))
                var buttonConfiguration = UIButton.Configuration.gray()
                buttonConfiguration.cornerStyle = .small
                buttonConfiguration.title = filter.content.title
                buttonConfiguration.baseForegroundColor = .white
                button.configuration = buttonConfiguration
                button.configurationUpdateHandler = { button in
                    switch button.state {
                    case [.selected, .highlighted], .selected, .highlighted:
                        button.configuration?.baseForegroundColor = .white
                    default:
                        button.configuration?.baseForegroundColor = .lightGray
                    }
                }
                button.isSelected = filter.content.isSelected
                stackView.addArrangedSubview(button)
            }
            stackView.addArrangedSubview(UIView())
        }

        func configure(with filter: FilterGroup.Filter) {
            for arrangedSubview in stackView.arrangedSubviews {
                arrangedSubview.removeFromSuperview()
                stackView.removeArrangedSubview(arrangedSubview)
            }
            stackView.addArrangedSubview(UIView())
            for subFilter in filter.subFilters {
                let button = UIButton(frame: .zero, primaryAction: .init(handler: { [weak self] _ in
                    self?.selectedSubFilter(subFilter.id)
                }))
                var buttonConfiguration = UIButton.Configuration.gray()
                buttonConfiguration.cornerStyle = .small
                buttonConfiguration.title = subFilter.content.title
                buttonConfiguration.baseForegroundColor = .white
                button.configuration = buttonConfiguration
                button.configurationUpdateHandler = { button in
                    switch button.state {
                    case [.selected, .highlighted], .selected, .highlighted:
                        button.configuration?.baseForegroundColor = .white
                    default:
                        button.configuration?.baseForegroundColor = .lightGray
                    }
                }
                button.isSelected = subFilter.content.isSelected
                stackView.addArrangedSubview(button)
            }
            stackView.addArrangedSubview(UIView())
        }
    }

    private lazy var stackView = UIStackView(arrangedSubviews: [filters, subFilters])
    private lazy var filters = ScrollableStackView()
    private lazy var subFilters = ScrollableStackView()

    var onFilterSelected: (Identifier<FilterGroup.Filter>) -> Void = { _ in }
    var onSubFilterSelected: (Identifier<FilterGroup.Filter.SubFilter>) -> Void = { _ in }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        filters.selectedFilter = { [weak self] filter in
            self?.onFilterSelected(filter)
        }
        filters.translatesAutoresizingMaskIntoConstraints = false
        addSubview(filters)
        subFilters.selectedSubFilter = { [weak self] subFilter in
            self?.onSubFilterSelected(subFilter)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Style.spacing
        stackView.distribution = .fillEqually
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Style.spacing),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Style.spacing),
        ])
    }

    func configure(with group: FilterGroup) {
        filters.configure(with: group)
        subFilters.configure(with: group.filters.filter(\.content.isSelected).first!.content)
    }
}

extension ShowsSection {
    static func filterGroup(
        _ filterGroup: Identified<FilterGroup>,
        onFilterSelected: @escaping (Identifier<FilterGroup.Filter>) -> FilterGroup,
        onSubFilterSelected: @escaping (Identifier<FilterGroup.Filter.SubFilter>) -> FilterGroup
    ) -> ShowsSection {
        .init(reusableView: { kind, collectionView, indexPath in
            guard let filterHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilterHeader", for: indexPath) as? FilterHeader else {
                return .init(frame: .zero)
            }
            filterHeader.configure(with: filterGroup.content)
            filterHeader.onFilterSelected = { id in
                filterHeader.configure(with: onFilterSelected(id))
            }
            filterHeader.onSubFilterSelected = { id in
                filterHeader.configure(with: onSubFilterSelected(id))
            }
            return filterHeader
        }, cells: [])
    }
}

class FilterGroupDataSource: ContentDataSourceProtocol {
    enum NavigationTarget {
        case showSubFilter(Identifier<FilterGroup.Filter.SubFilter>)
    }

    var changeHandlers: [(FilterGroup) -> Void] = []
    var onUpdate: () -> Void = {}
    var layoutSection: NSCollectionLayoutSection {
        let layoutSection = makeLayoutSection(
            insets: .init(top: Style.spacing, leading: 0, bottom: 0, trailing: 0),
            size: .init(width: CGFloat.greatestFiniteMagnitude, height: 1)
        )
        layoutSection.boundarySupplementaryItems = [
            .init(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(Style.filterHeaderHeight)
                ),
                elementKind: "Header",
                alignment: .top
            ),
        ]
        return layoutSection
    }

    private var onNavigate: (NavigationTarget) -> Void
    private(set) var filterGroup: Identified<FilterGroup>

    init(onNavigate: @escaping (NavigationTarget) -> Void) {
        self.onNavigate = onNavigate
        filterGroup = Identified<FilterGroup>(
            id: "fg1",
            content: FilterGroup(
                filters: [
                    .init(
                        id: "hr1_f1",
                        content: .init(
                            title: "Seasons",
                            subFilters: [
                                .init(
                                    id: "hr1_f1_sf1",
                                    content: .init(
                                        title: "Season 1",
                                        isSelected: true
                                    )
                                ),
                                .init(
                                    id: "hr1_f1_sf2",
                                    content: .init(
                                        title: "Season 2",
                                        isSelected: false
                                    )
                                ),
                            ],
                            isSelected: true
                        )
                    ),
                    .init(
                        id: "hr1_f2",
                        content: .init(
                            title: "Extras",
                            subFilters: [
                                .init(
                                    id: "hr1_f2_sf1",
                                    content: .init(
                                        title: "Bonus",
                                        isSelected: true
                                    )
                                ),
                                .init(
                                    id: "hr1_f2_sf2",
                                    content: .init(
                                        title: "Deleted Scenes",
                                        isSelected: false
                                    )
                                ),
                            ],
                            isSelected: false
                        )
                    ),
                ]
            )
        )
    }

    func register(in collectionView: UICollectionView) {
        collectionView.register(FilterHeader.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: "FilterHeader")
    }

    func configureStatic(_ filterHeader: FilterHeader) {
        filterHeader.configure(with: filterGroup.content)
        changeHandlers.append { [weak filterHeader] filterGroup in
            filterHeader?.configure(with: filterGroup)
        }
        filterHeader.onFilterSelected = { [weak self] id in
            self?.toggleSelection(id)
        }
        filterHeader.onSubFilterSelected = { [weak self] id in
            self?.toggleSelection(id)
            self?.onNavigate(.showSubFilter(id))
        }
    }

    var section: ShowsSection {
        ShowsSection.filterGroup(filterGroup) { [weak self] id in
            guard let self else { return .init(filters: []) }
            self.toggleSelection(id)
            return self.filterGroup.content
        } onSubFilterSelected: { [weak self] id in
            guard let self else { return .init(filters: []) }
            self.toggleSelection(id)
            self.onNavigate(.showSubFilter(id))
            return self.filterGroup.content
        }
    }

    private func toggleSelection(_ id: Identifier<FilterGroup.Filter.SubFilter>) {
        filterGroup = .init(
            id: filterGroup.id,
            content: FilterGroup(
                filters: filterGroup.content.filters.map { filter in
                    .init(
                        id: filter.id,
                        content: .init(
                            title: filter.content.title,
                            subFilters: filter.content.subFilters.map { subFilter in
                                .init(
                                    id: subFilter.id,
                                    content: .init(
                                        title: subFilter.content.title,
                                        isSelected: id == subFilter.id
                                    )
                                )
                            },
                            isSelected: filter.content.isSelected
                        )
                    )
                }
            )
        )
        onChange()
    }

    private func onChange() {
        for changeHandler in changeHandlers {
            changeHandler(filterGroup.content)
        }
        onUpdate()
    }

    private func toggleSelection(_ id: Identifier<FilterGroup.Filter>) {
        filterGroup = .init(
            id: filterGroup.id,
            content: FilterGroup(
                filters: filterGroup.content.filters.map { filter in
                    .init(
                        id: filter.id,
                        content: .init(
                            title: filter.content.title,
                            subFilters: filter.content.subFilters.enumerated().map { index, subFilter in
                                .init(
                                    id: subFilter.id,
                                    content: .init(
                                        title: subFilter.content.title,
                                        isSelected: index == 0
                                    )
                                )
                            },
                            isSelected: id == filter.id
                        )
                    )
                }
            )
        )
        onChange()
    }
}

class EpisodeGroupDataSource: ContentDataSourceProtocol {
    enum NavigationTarget {
        case showEpisode(Identifier<EpisodeGroup.Item>)
    }

    var onUpdate: () -> Void = {}
    var layoutSection: NSCollectionLayoutSection {
        let layoutSection = makeLayoutSection(
            insets: .init(top: Style.spacing, leading: Style.spacing, bottom: 0, trailing: Style.spacing),
            size: .init(width: CGFloat.greatestFiniteMagnitude, height: 44),
            horizontal: false,
            scrollingBehaviour: .none
        )
        return layoutSection
    }

    private var onNavigate: (NavigationTarget) -> Void
    private var episodeGroup: Identified<EpisodeGroup>

    init(episodeGroup: Identified<EpisodeGroup>, onNavigate: @escaping (NavigationTarget) -> Void) {
        self.onNavigate = onNavigate
        self.episodeGroup = episodeGroup
    }

    func register(in collectionView: UICollectionView) {
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: "EpisodeCell")
    }

    var section: ShowsSection {
        ShowsSection.episodeGroup(episodeGroup) { [weak self] id in
            self?.onNavigate(.showEpisode(id))
        }
    }
}

// MARK: - EpisodeGroup

struct EpisodeGroup: Equatable {
    let items: [Identified<Item>]

    struct Item: Equatable {
        let color: UIColor
        let title: String
        let description: String
    }
}

class EpisodeCell: UICollectionViewCell {
    private lazy var snapshot = UIView()
    private lazy var stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
    private lazy var titleLabel = UILabel()
    private lazy var descriptionLabel = UILabel()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        snapshot.layer.cornerRadius = 3
        snapshot.layer.masksToBounds = true
        snapshot.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(snapshot)
        NSLayoutConstraint.activate([
            snapshot.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            snapshot.topAnchor.constraint(equalTo: contentView.topAnchor),
            snapshot.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            snapshot.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            snapshot.heightAnchor.constraint(equalTo: snapshot.widthAnchor, multiplier: 0.75),
        ])

        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: snapshot.trailingAnchor, constant: Style.spacing),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Style.spacing),
        ])

        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 16)

        descriptionLabel.textColor = .lightGray
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
    }

    func configure(with item: EpisodeGroup.Item) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        snapshot.backgroundColor = item.color
    }
}

extension ShowsSection {
    static func episodeGroup(
        _ episodeGroup: Identified<EpisodeGroup>,
        onItemTapped: @escaping (Identifier<EpisodeGroup.Item>) -> Void
    ) -> ShowsSection {
        .init(reusableView: { _, _, _ in
            .init(frame: .zero)
        }, cells: episodeGroup.content.items.map { item in
            .episode(
                item,
                onTapped: onItemTapped
            )
        })
    }
}

extension Cell {
    static func episode(
        _ episode: Identified<EpisodeGroup.Item>,
        onTapped: @escaping (Identifier<EpisodeGroup.Item>) -> Void
    ) -> Cell {
        .init { collectionView, indexPath in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCell", for: indexPath) as? EpisodeCell else {
                return .init()
            }
            cell.configure(with: episode.content)
            return cell
        } tapped: {
            onTapped(episode.id)
        }
    }
}

// MARK: - MovieGroup

struct MovieGroup: Equatable {
    let items: [Identified<Item>]

    struct Item: Equatable {
        let title: String
        var isFavourite: Bool
    }
}

class MovieCell: UICollectionViewCell {
    private lazy var label = UILabel()
    private lazy var favouriteButton = UIButton()

    var onFavouriteTapped: () -> Void = {}

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        contentView.backgroundColor = .red
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        favouriteButton.addTarget(self, action: #selector(tappedFavourite), for: .touchUpInside)
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favouriteButton)
        NSLayoutConstraint.activate([
            favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            favouriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            favouriteButton.heightAnchor.constraint(equalToConstant: 44),
            favouriteButton.widthAnchor.constraint(equalToConstant: 44),
        ])
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.shadowColor = .black
        label.shadowOffset = .init(width: 2, height: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
        ])
    }

    func configure(with model: MovieGroup.Item) {
        label.text = model.title
        favouriteButton.tag = model.isFavourite ? 2 : 1
        favouriteButton.setImage(model.isFavourite ? .remove : .add, for: .normal)
    }

    @objc private func tappedFavourite() {
        favouriteButton.tag = favouriteButton.tag == 1 ? 2 : 1
        favouriteButton.setImage(favouriteButton.tag == 2 ? .remove : .add, for: .normal)
        onFavouriteTapped()
    }
}

extension ShowsSection {
    static func movieGroup(
        _ movieGroup: Identified<MovieGroup>,
        onTapped: @escaping (Identifier<MovieGroup>) -> Void,
        onItemTapped: @escaping (Identifier<MovieGroup.Item>) -> Void,
        onItemFavouriteTapped: @escaping (Identifier<MovieGroup.Item>) -> Void
    ) -> ShowsSection {
        .init(reusableView: { _, _, _ in
            .init(frame: .zero)
        }, cells: movieGroup.content.items.map { item in
            .movie(
                item,
                onTapped: onItemTapped,
                onFavouriteTapped: onItemFavouriteTapped
            )
        })
    }
}

extension Cell {
    static func movie(
        _ movie: Identified<MovieGroup.Item>,
        onTapped: @escaping (Identifier<MovieGroup.Item>) -> Void,
        onFavouriteTapped: @escaping (Identifier<MovieGroup.Item>) -> Void
    ) -> Cell {
        .init { collectionView, indexPath in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
                return .init()
            }
            cell.configure(with: movie.content)
            cell.onFavouriteTapped = {
                onFavouriteTapped(movie.id)
            }
            return cell
        } tapped: {
            onTapped(movie.id)
        }
    }
}

class MovieGroupDataSource: ContentDataSourceProtocol {
    enum NavigationTarget {
        case showMovieGroup(Identifier<MovieGroup>)
        case showMovie(Identifier<MovieGroup.Item>)
    }

    var onUpdate: () -> Void = {}
    var layoutSection: NSCollectionLayoutSection {
        let layoutSection = makeLayoutSection(
            insets: .init(top: Style.spacing, leading: Style.spacing, bottom: 0, trailing: Style.spacing),
            size: .init(width: 160, height: 240)
        )
        return layoutSection
    }

    private var onNavigate: (NavigationTarget) -> Void
    private var movieGroup: Identified<MovieGroup>

    init(onNavigate: @escaping (NavigationTarget) -> Void) {
        self.onNavigate = onNavigate
        movieGroup = Identified<MovieGroup>(
            id: "mv1",
            content: MovieGroup(
                items: [
                    Identified<MovieGroup.Item>(
                        id: "mv1_it1",
                        content: .init(
                            title: "Movie1",
                            isFavourite: false
                        )
                    ),
                    Identified<MovieGroup.Item>(
                        id: "mv1_it2",
                        content: .init(
                            title: "Movie2",
                            isFavourite: true
                        )
                    ),
                    Identified<MovieGroup.Item>(
                        id: "mv1_it3",
                        content: .init(
                            title: "Movie3",
                            isFavourite: false
                        )
                    ),
                ]
            )
        )
    }

    func register(in collectionView: UICollectionView) {
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
    }

    var section: ShowsSection {
        ShowsSection.movieGroup(movieGroup) { [weak self] id in
            self?.onNavigate(.showMovieGroup(id))
        } onItemTapped: { [weak self] id in
            self?.onNavigate(.showMovie(id))
        } onItemFavouriteTapped: { [weak self] id in
            self?.toggleFavourite(id)
        }
    }

    private func toggleFavourite(_ id: Identifier<MovieGroup.Item>) {
        movieGroup = .init(
            id: movieGroup.id,
            content: MovieGroup(
                items: movieGroup.content.items.map { match in
                    guard match.id == id else {
                        return match
                    }
                    print("Toggled movie \(id) to \(!match.content.isFavourite)")
                    return .init(
                        id: id,
                        content: .init(
                            title: match.content.title,
                            isFavourite: !match.content.isFavourite
                        )
                    )
                }
            )
        )
        onUpdate()
    }
}

// MARK: - TvShowGroup

struct TvShowGroup: Equatable {
    let title: String
    let items: [Identified<Item>]

    struct TvShow: Equatable {
        let title: String
        var isFavourite: Bool
    }

    enum Item: Equatable {
        case tvShow(TvShow)
        case viewAll
    }
}

class ViewAllCell: UICollectionViewCell {
    private lazy var label = UILabel()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        label.text = "View All"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.shadowColor = .black
        label.shadowOffset = .init(width: 2, height: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
        ])
    }
}

class TvShowCell: UICollectionViewCell {
    private lazy var label = UILabel()
    private lazy var favouriteButton = UIButton()

    var onFavouriteTapped: () -> Void = {}

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        contentView.backgroundColor = .blue
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        favouriteButton.addTarget(self, action: #selector(tappedFavourite), for: .touchUpInside)
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(favouriteButton)
        NSLayoutConstraint.activate([
            favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            favouriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            favouriteButton.heightAnchor.constraint(equalToConstant: 44),
            favouriteButton.widthAnchor.constraint(equalToConstant: 44),
        ])
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        label.shadowColor = .black
        label.shadowOffset = .init(width: 2, height: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10),
        ])
    }

    func configure(with model: TvShowGroup.TvShow) {
        label.text = model.title
        favouriteButton.tag = model.isFavourite ? 2 : 1
        favouriteButton.setImage(model.isFavourite ? .remove : .add, for: .normal)
    }

    @objc private func tappedFavourite() {
        favouriteButton.tag = favouriteButton.tag == 1 ? 2 : 1
        favouriteButton.setImage(favouriteButton.tag == 2 ? .remove : .add, for: .normal)
        onFavouriteTapped()
    }
}

class TvShowHeader: UICollectionReusableView {
    private lazy var titleLabel = UILabel()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        backgroundColor = Style.backgroundColor
        titleLabel.textColor = .lightGray
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.spacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.spacing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Style.spacing),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Style.spacing),
        ])
    }

    func configure(with group: TvShowGroup) {
        titleLabel.text = group.title + " (\(group.items.count))"
    }
}

extension Cell {
    static func tvShow(
        _ tvShow: Identified<TvShowGroup.Item>,
        onTapped: @escaping (Identifier<TvShowGroup.Item>) -> Void,
        onFavouriteTapped: @escaping (Identifier<TvShowGroup.Item>) -> Void
    ) -> Cell {
        .init { collectionView, indexPath in
            switch tvShow.content {
            case let .tvShow(item):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TvShowCell", for: indexPath) as? TvShowCell else {
                    return .init()
                }
                cell.configure(with: item)
                cell.onFavouriteTapped = {
                    onFavouriteTapped(tvShow.id)
                }
                return cell
            case .viewAll:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllCell", for: indexPath) as? ViewAllCell else {
                    return .init()
                }
                return cell
            }

        } tapped: {
            onTapped(tvShow.id)
        }
    }
}

extension ShowsSection {
    static func tvShowGroup(
        _ tvShowGroup: Identified<TvShowGroup>,
        onTapped: @escaping (Identifier<TvShowGroup>) -> Void,
        onItemTapped: @escaping (Identifier<TvShowGroup.Item>) -> Void,
        onItemFavouriteTapped: @escaping (Identifier<TvShowGroup.Item>) -> Void
    ) -> ShowsSection {
        .init(reusableView: { kind, collectionView, indexPath in
            guard let tvShowHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TvShowHeader", for: indexPath) as? TvShowHeader else {
                return .init(frame: .zero)
            }
            tvShowHeader.configure(with: tvShowGroup.content)
            return tvShowHeader
        }, cells: tvShowGroup.content.items.map { item in
            .tvShow(
                item,
                onTapped: onItemTapped,
                onFavouriteTapped: onItemFavouriteTapped
            )
        })
    }
}

class TvShowGroupDataSource: ContentDataSourceProtocol {
    enum NavigationTarget {
        case showTvShowGroup(Identifier<TvShowGroup>)
        case showTvShow(Identifier<TvShowGroup.Item>)
    }

    var onUpdate: () -> Void = {}
    var layoutSection: NSCollectionLayoutSection {
        let layoutSection = makeLayoutSection(
            insets: .init(top: 0, leading: Style.spacing, bottom: Style.spacing, trailing: Style.spacing),
            size: .init(width: 240, height: 160)
        )
        layoutSection.boundarySupplementaryItems = [
            .init(
                layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44)),
                elementKind: "Header",
                alignment: .top
            ),
        ]
        return layoutSection
    }

    private var onNavigate: (NavigationTarget) -> Void
    private var tvShowGroup: Identified<TvShowGroup>

    init(onNavigate: @escaping (NavigationTarget) -> Void) {
        self.onNavigate = onNavigate
        tvShowGroup = Identified<TvShowGroup>(
            id: "sr1",
            content: TvShowGroup(
                title: "TvShowGroup",
                items: [
                    Identified<TvShowGroup.Item>(
                        id: "sr1_it1",
                        content: .tvShow(
                            .init(
                                title: "TvShow1",
                                isFavourite: true
                            )
                        )
                    ),
                    Identified<TvShowGroup.Item>(
                        id: "sr1_it2",
                        content: .tvShow(
                            .init(
                                title: "TvShow2",
                                isFavourite: false
                            )
                        )
                    ),
                    Identified<TvShowGroup.Item>(
                        id: "sr1_it3",
                        content: .tvShow(
                            .init(
                                title: "TvShow3",
                                isFavourite: false
                            )
                        )
                    ),
                    Identified<TvShowGroup.Item>(
                        id: "sr1_view_all",
                        content: .viewAll
                    ),
                ]
            )
        )
    }

    func register(in collectionView: UICollectionView) {
        collectionView.register(TvShowHeader.self, forSupplementaryViewOfKind: "Header", withReuseIdentifier: "TvShowHeader")
        collectionView.register(TvShowCell.self, forCellWithReuseIdentifier: "TvShowCell")
        collectionView.register(ViewAllCell.self, forCellWithReuseIdentifier: "ViewAllCell")
    }

    var section: ShowsSection {
        ShowsSection.tvShowGroup(tvShowGroup) { [weak self] id in
            self?.onNavigate(.showTvShowGroup(id))
        } onItemTapped: { [weak self] id in
            self?.onNavigate(.showTvShow(id))
        } onItemFavouriteTapped: { [weak self] id in
            self?.toggleFavourite(id)
        }
    }

    private func toggleFavourite(_ id: Identifier<TvShowGroup.Item>) {
        tvShowGroup = .init(
            id: tvShowGroup.id,
            content: TvShowGroup(
                title: tvShowGroup.content.title,
                items: tvShowGroup.content.items.map { match in
                    guard match.id == id else {
                        return match
                    }
                    switch match.content {
                    case .viewAll: return match
                    case let .tvShow(show):
                        print("Toggled series \(id) to \(!show.isFavourite)")
                        return .init(
                            id: id,
                            content: .tvShow(
                                .init(
                                    title: show.title,
                                    isFavourite: show.isFavourite
                                )
                            )
                        )
                    }
                }
            )
        )
        onUpdate()
    }
}
