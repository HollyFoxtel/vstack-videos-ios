import SwiftUI

struct SportsView: View {
    let useCustomView = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                SportsHeader()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .focusSection()
                
                ViewControllerRepresentable { context in
                    InsetItemsGridViewController()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .ignoresSafeArea()
    }
}

struct SportsHeader: View {
    enum FocusedField {
        case username, password
    }

    @FocusState private var focusedField: FocusedField?
    @State private var username = "Anonymous"
    @State private var password = "sekrit"

    var body: some View {
        VStack {
            TextField("Enter your username", text: $username)
                .focused($focusedField, equals: .username)

            SecureField("Enter your password", text: $password)
                .focused($focusedField, equals: .password)
        }
        .frame(maxWidth: 300)
        .padding(EdgeInsets(top: 10, leading: 80, bottom: 10, trailing: 80))
        .onSubmit {
            if focusedField == .username {
                focusedField = .password
            } else {
                focusedField = nil
            }
        }
    }
}
