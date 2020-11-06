import SwiftUI
import Foundation

extension Color {
    enum Theme {
        static let headerBackground: Color = Color("headerBackground", bundle: Bundle.module)
        static var primaryTint: Color = Color("primaryTint", bundle: Bundle.module)
    }
}

#if SWIFT_PACKAGE

#else
class BundleLocator {}

extension Bundle {
    static var module: Bundle {
        Bundle.init(for: BundleLocator.self)
    }
}
#endif
