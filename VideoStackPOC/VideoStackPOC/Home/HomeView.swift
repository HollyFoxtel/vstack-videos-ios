import SwiftUI

struct HomeView: View {
    @State var selection: String = KayoTab.shows.id
    
    var body: some View {
        TabView(selection: $selection) {
            PlaceHolderView(tab: KayoTab.search)
                .tabItem { Label(KayoTab.search.description, systemImage: KayoTab.search.icon) }
                .tag(KayoTab.search.id)
                .toolbar(.hidden, for: .tabBar)
            
            HomeContentView()
                .tabItem { Label(KayoTab.home.description, systemImage: KayoTab.home.icon) }
                .tag(KayoTab.home.id)
                .toolbar(.hidden, for: .tabBar)
            
            ShowsViewRepresentable()
                .ignoresSafeArea()
                .tabItem { Label(KayoTab.shows.description, systemImage: KayoTab.shows.icon) }
                .tag(KayoTab.shows.id)
                .toolbar(.hidden, for: .tabBar)
            
            PlaceHolderView(tab: KayoTab.sports)
                .tabItem { Label(KayoTab.sports.description, systemImage: KayoTab.sports.icon) }
                .tag(KayoTab.sports.id)
                .toolbar(.hidden, for: .tabBar)
            
            VerticalFeedView()
                .tabItem { Label(KayoTab.favourites.description, systemImage: KayoTab.favourites.icon) }
                .tag(KayoTab.favourites.id)
                .toolbar(.hidden, for: .tabBar)
            
            Section("Settings") {
                PlaceHolderView(tab: KayoTab.myKayo)
                    .tabItem { Label(KayoTab.myKayo.description, systemImage: KayoTab.myKayo.icon) }
                    .tag(KayoTab.myKayo.id)
                    .toolbar(.hidden, for: .tabBar)
            }
        }.adaptiveSidebar(selectedItem: $selection)
    }
}

struct PlaceHolderView: View {
    let title: String
    let icon: String
    let color: Color
    
    init(tab: TabItemProtocol) {
        title = tab.description
        icon = tab.icon
        color = tab.color
    }
    
    var body: some View  {
        Label(title, systemImage: icon)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color.opacity(0.4))
    }
}
