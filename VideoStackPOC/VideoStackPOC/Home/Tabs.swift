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
