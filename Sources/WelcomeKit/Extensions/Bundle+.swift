#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

extension Bundle {
    var appName: String {
        infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
    }

    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
}

#endif
