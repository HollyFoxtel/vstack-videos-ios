import SwiftUI

enum KayoTab: Equatable, Hashable, Identifiable {
    case shows
    case home
    case sports
    case search
    case favourites
    case library(AdditionTab?)

    var description: String {
        switch self {
        case .shows: "Shows"
        case .sports: "Sports"
        case .search: "Search"
        case .favourites: "Favourites"
        case .library(let child): "Library | \(child?.rawValue ?? "")"
        case .home: "Home"
        }
    }

    var icon: String {
        switch self {
        case .shows: return "tv"
        case .home: return "house"
        case .sports: return "sportscourt"
        case .search: return "magnifyingglass"
        case .favourites: return "star"
        case .library(let child): return child?.icon ?? "x.circle"
        }
    }

    var color: Color {
        switch self {
        case .shows: return .orange
        case .sports: return .yellow
        case .search: return .green
        case .favourites: return .pink
        case .library: return .blue
        case .home: return .yellow
        }
    }

    var id: String { description }
}

enum AdditionTab: String, Equatable, Hashable, CaseIterable, Identifiable {
    case myKayo

    var icon: String {
        switch self {
        case .myKayo: "gear"
        }
    }

    var color: Color {
        switch self {
        case .myKayo: return .red
        }
    }
    
    var id: String { rawValue }

    var description: String {
        switch self {
        case.myKayo: "My Kayo"
        }
    }
    
//    var applyModifiers: Bool { self == .movies }
//    var isPrincipalTab: Bool { self == .all }
}
