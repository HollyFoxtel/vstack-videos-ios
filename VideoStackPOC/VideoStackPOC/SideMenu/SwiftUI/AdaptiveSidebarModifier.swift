import SwiftUI

extension View {
    func adaptiveSidebar(selectedItem: Binding<String>) -> some View {
        self.modifier(AdaptiveSidebarModifier(selectedItem: selectedItem))
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

extension TabItemProtocol {
    var toMenuItem: MenuItem {
        .init(id: description, name: description, icon: icon)
    }
}
