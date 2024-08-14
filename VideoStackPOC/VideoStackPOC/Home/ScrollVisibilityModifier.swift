import SwiftUI

extension View {
    @ViewBuilder
    func customOnScrollVisibilityChange(threshold: Double = 0.5, _ action: @escaping (Bool) -> Void) -> some View {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            self.onScrollVisibilityChange(threshold: threshold, action)
        } else {
            self.modifier(ScrollVisibilityModifier(threshold: threshold, action: action))
        }
    }
}

private struct ScrollVisibilityModifier: ViewModifier {
    let threshold: Double
    let action: (Bool) -> Void
    
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollVisibilityPreferenceKey.self, value: geometry.frame(in: .global))
                }
            )
            .onPreferenceChange(ScrollVisibilityPreferenceKey.self) { bounds in
                let visiblePercentage = calculateVisiblePercentage(bounds)
                let newIsVisible = visiblePercentage >= threshold
                if newIsVisible != isVisible {
                    isVisible = newIsVisible
                    action(isVisible)
                }
            }
    }
    
    private func calculateVisiblePercentage(_ bounds: CGRect) -> Double {
        let screenHeight = UIScreen.main.bounds.height
        let visibleHeight = bounds.intersection(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: screenHeight)).height
        return Double(visibleHeight / bounds.height)
    }
}

private struct ScrollVisibilityPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
