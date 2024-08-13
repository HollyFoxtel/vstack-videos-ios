import SwiftUI

struct HomeView: View {
    @State var selection: KayoTab = .home
    let tabs: [KayoTab] = [.search, .home, .shows, .sports, .favourites]

    var body: some View {
        TabView(selection: $selection) {
            ForEach(tabs) { tab in
                Tab(tab.description, systemImage: tab.icon, value: tab) {
                    tab.detail()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            
            TabSection("Settings") {
                  ForEach(AdditionTab.allCases) { libraryTab in
                      Tab(libraryTab.description,
                          systemImage: libraryTab.icon,
                          value: KayoTab.library(libraryTab)
                      ) {
                          libraryTab.detail()
                      }
                  }
              }
            
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

extension KayoTab {
    func detail() -> AnyView {
        switch self {
        case .home: return HomeContentView().eraseToAnyView()
        case .favourites: return VerticalFeedView().eraseToAnyView()
        default:
            return Label(description, systemImage: icon)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(color.opacity(0.4))
                .eraseToAnyView()
        }
    }
}

extension AdditionTab {
    func detail() -> some View {
        Label("Additional | \(rawValue)", systemImage: icon)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color.opacity(0.4))
    }
}
