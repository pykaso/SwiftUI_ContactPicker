import SwiftUI
import Foundation

extension Color {
    enum Theme {
        static let headerBackground: Color = Color("headerBackground", bundle: Bundle.module)
        static var primaryTint: Color = Color("primaryTint", bundle: Bundle.module)
    }
}
