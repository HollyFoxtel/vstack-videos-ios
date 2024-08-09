//
//  ContentView.swift
//  VideoStackPOC
//
//  Created by Rajesh Ramachandrakurup on 7/8/2024.
//

import SwiftUI

extension Color {
    static let kayoGreen = #colorLiteral(red: 0.09019607843, green: 0.4745098039, blue: 0.2980392157, alpha: 1)
}

struct ContentView: View {
    @State private var showModal = false
    var body: some View {
        Group {
            VStack {
                Button {
                    showModal = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black)
                            .frame(width: 150, height: 60)
                            .shadow(radius: 10)
                        Text("Vertical Feeds")
                            .bold()
                            .foregroundStyle(.white)
                    }
                }

            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: Color.kayoGreen))
        .fullScreenCover(isPresented: $showModal) {
            VerticalFeedView()
        }
        .onAppear {
           // parse()
        }
    }

    func parse() {
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "response", withExtension: "json")!)
        var output: [String] = []
        let object = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        for item in object["data"] as! [[String: Any]] {
            let i = item["attributes"] as! [String: Any]
            let m = i["video"] as! [String: Any]
            let j = m["video_files"] as! [[String: Any]]
            for _j in j {
                if (_j["quality"] as! String) == "hd" {
                    output.append(_j["link"] as! String)
                    break
                }
            }

        }
        print(output)
    }
}

#Preview {
    ContentView()
}
