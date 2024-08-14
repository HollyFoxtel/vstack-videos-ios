import SwiftUI

protocol TabItemProtocol {
    var description: String { get }
    
    var icon: String {  get }

    var color: Color { get }
}

enum KayoTab: Equatable, Hashable, Identifiable, CaseIterable, TabItemProtocol {
    case shows
    case home
    case sports
    case search
    case favourites
    case myKayo

    var description: String {
        switch self {
        case .shows: "Shows"
        case .sports: "Sports"
        case .search: "Search"
        case .favourites: "Favourites"
        case .myKayo: "My Kayo"
        case .home: "Home"
        }
    }

    var icon: String {
        switch self {
        case .shows: return "play.tv.fill"
        case .home: return "house.fill"
        case .sports: return "sportscourt.fill"
        case .search: return "magnifyingglass"
        case .favourites: return "star"
        case .myKayo: return "gear"
        }
    }

    var color: Color {
        switch self {
        case .shows: return .orange
        case .sports: return .yellow
        case .search: return .green
        case .favourites: return .pink
        case .myKayo: return .purple
        case .home: return .yellow
        }
    }

    var id: String { description }
}

extension TabItemProtocol {
    var toMenuItem: MenuItem {
        .init(id: description, name: description, icon: icon)
    }
}

struct AdaptiveSidebarModifier: ViewModifier {
    @Binding var selectedItem: String
    @State private var columnVisibility = NavigationSplitViewVisibility.detailOnly
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(tvOS 18.0, *) {
            content
                .tabViewStyle(.sidebarAdaptable)
        } else {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                SidebarView(selectedItem: $selectedItem)
            } detail: {
                content
            }
            .navigationSplitViewStyle(.prominentDetail)
            .onMoveCommand { direction in
                handleMoveCommand(direction)
            }.onAppear {
                columnVisibility = .detailOnly
            }
        }
    }
    
    private func handleMoveCommand(_ direction: MoveCommandDirection) {
        switch direction {
        case .left:
            if columnVisibility == .detailOnly {
                columnVisibility = .all
            }
        case .right:
            if columnVisibility == .all {
                columnVisibility = .detailOnly
            }
        default:
            break
        }
    }
}

extension View {
    func adaptiveSidebar(selectedItem: Binding<String>) -> some View {
        self.modifier(AdaptiveSidebarModifier(selectedItem: selectedItem))
    }
}

struct SidebarView: View {
    @Binding var selectedItem: String
    @FocusState private var focusedItem: String?
    
    let menuItems: [MenuItem] = KayoTab.allCases.map { $0.toMenuItem }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(menuItems) { item in
                    HStack {
                        Image(systemName: item.icon)
                            .foregroundColor(.white)
                        Text(item.name)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(backgroundFor(item))
                    .cornerRadius(10)
                    .scaleEffect(focusedItem == item.id ? 1.1 : 1.0)
                    .animation(.easeInOut, value: focusedItem)
                    .focusable()
                    .focused($focusedItem, equals: item.id)
                    .onTapGesture {
                        selectedItem = item.id
                    }
                }
            }
            .padding()
        }
        .onChange(of: focusedItem) { newValue in
            if let newValue {
                selectedItem = newValue
            }
        }
    }
    
    func backgroundFor(_ item: MenuItem) -> Color {
        if focusedItem?.description == item.id {
            return .blue
        } else if selectedItem.description == item.id {
            return .gray
        } else {
            return .clear
        }
    }
}

struct MenuItem: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
}

