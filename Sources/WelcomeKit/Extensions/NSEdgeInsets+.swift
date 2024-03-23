#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

extension NSEdgeInsets {
    static let zero = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}

#endif
