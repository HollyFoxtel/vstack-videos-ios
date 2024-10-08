import SwiftUI

let info = "All eyes are on the Dees after a tumultuous 12 months. Plus AFL greats Jordan Lewis, Jack Riewoldt, David King and Leigh Montagna preview a big Round 23."

struct HomeContentView: View {
    @State private var belowFold = false
    @State private var showUIKitModal = false
    
    private var showcaseHeight: CGFloat = 800
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 36) {
                    // The header/showcase view.
                    VStack(alignment: .leading) {
                        Spacer()
                        
                        Text("TODAY 4:30PM")
                            .font(.system(size: 28, weight: .light))
                        
                        VStack(alignment: .leading, spacing:  -10) {
                            Text("AFL 360: ")
                                .font(.largeTitle)
                                .bold()
                            Text("August 14")
                                .font(.largeTitle)
                                .bold()
                        }
                        Text(info)
                            .font(.system(size: 25, weight: .light))
                            .frame(width: 560)
                        
                        HStack {
                            Button(action: {}) {
                                Text("Starting Soon")
                                    .font(.system(size: 24, weight: .light))
                            }
                            .disabled(true)
                            
                            Button(action: {
                                showUIKitModal.toggle()
                            }) {
                                Text("More Info...")
                                    .font(.system(size: 24, weight: .light))
                            }
                        }
                        .padding(.bottom, 80)
                        
                        Spacer()
                    }
                    // Stretch the trailing edge to the width of the screen.
                    .frame(maxWidth: .infinity, alignment: .leading)
                    // Then place a focus target over that entire area.
                    .focusSection()
                    // Use 80% of the container's vertical space.
                    .containerRelativeFrame(.vertical, alignment: .topLeading) {
                        length, _ in length * 0.8
                    }
                    .customOnScrollVisibilityChange { visible in
                        // When the header scrolls more than 50% offscreen,
                        // toggle to the below-the-fold state.
                        withAnimation {
                            belowFold = !visible
                        }
                    }
                    
                    Section("Show") {
                        ShowChannels()
                    }
                    
                    Section("Live & Upcoming") {
                        LiveChannels()
                    }
                    
                    Section("Latest Minis") {
                        LatestMinis()
                    }
                }
                // Use this vertical stack's content views to determine scroll
                // targeting.
                .scrollTargetLayout()
            }
            .background(alignment: .top) {
                // Draw the background, which changes when the view moves below
                // the fold.
                HeroHeaderView(belowFold: belowFold)
            }
            .scrollTargetBehavior(
                // This is a custom scroll target behavior that uses the
                // expected height of the showcase view.
                FoldSnappingScrollTargetBehavior(
                    aboveFold: !belowFold, showcaseHeight: showcaseHeight))
            // Disable scroll clipping so the scroll view doesn't clip the
            // raised focus effects.
            .scrollClipDisabled()
            .frame(maxHeight: .infinity, alignment: .top)
            .fullScreenCover(isPresented: $showUIKitModal) {
                LSideMenuDemo()
                    .ignoresSafeArea()
            }
            
        }
    }
}

#Preview {
    HomeContentView()
}
