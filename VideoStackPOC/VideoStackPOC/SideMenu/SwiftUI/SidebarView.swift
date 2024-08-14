import SwiftUI

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
