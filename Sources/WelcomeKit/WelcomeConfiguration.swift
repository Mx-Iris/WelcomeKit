#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public enum WelcomeStyle {
    case xcode14
    case xcode15

    var actionTableViewHeight: CGFloat {
        switch self {
        case .xcode14:
            138
        case .xcode15:
            132
        }
    }

    var actionTableViewCellHeight: CGFloat {
        switch self {
        case .xcode14:
            46
        case .xcode15:
            36
        }
    }

    var actionTableViewSpacing: CGFloat {
        switch self {
        case .xcode14:
            0
        case .xcode15:
            8
        }
    }

    var windowStyleMask: NSWindow.StyleMask {
        switch self {
        case .xcode14:
            [.titled, .fullSizeContentView]
        case .xcode15:
            [.borderless]
        }
    }

    var windowRect: CGRect {
        switch self {
        case .xcode14:
            .init(x: 0, y: 0, width: 800, height: 460)
        case .xcode15:
            .init(x: 0, y: 0, width: 740, height: 460)
        }
    }

    var projectViewWidth: CGFloat {
        switch self {
        case .xcode14:
            307
        case .xcode15:
            280
        }
    }

    var appImageViewTopSpacing: CGFloat {
        switch self {
        case .xcode14:
            40
        case .xcode15:
            52
        }
    }

    var windowCornerRadius: CGFloat {
        switch self {
        case .xcode14:
            0
        case .xcode15:
            8
        }
    }

    var welcomeLabelDefaultFont: NSFont {
        switch self {
        case .xcode14:
            .systemFont(ofSize: 36, weight: .regular)
        case .xcode15:
            .systemFont(ofSize: 30, weight: .bold)
        }
    }

    var versionLabelDefaultFont: NSFont {
        switch self {
        case .xcode14:
            .systemFont(ofSize: 13, weight: .light)
        case .xcode15:
            .systemFont(ofSize: 13)
        }
    }

    func welcomeLabelDefaultText(forName name: String) -> String {
        switch self {
        case .xcode14:
            "Welcome to \(name)"
        case .xcode15:
            name
        }
    }
}

public struct WelcomeConfiguration {
    public var style: WelcomeStyle
    public var welcomeLabelText: String?
    public var welcomeLabelFont: NSFont?
    public var welcomeLabelColor: NSColor?
    public var versionLabelText: String?
    public var versionLabelFont: NSFont?
    public var versionLabelColor: NSColor?
    public var appIconImage: NSImage?
    public var appIconImageShadow: NSShadow?
    public var primaryAction: WelcomeAction?
    public var secondaryAction: WelcomeAction?
    public var tertiaryAction: WelcomeAction?
    public var checkShowOnLaunch: Bool

    public var allActions: [WelcomeAction] {
        [primaryAction, secondaryAction, tertiaryAction].compactMap { $0 }
    }

    public init(
        style: WelcomeStyle = .xcode14,
        welcomeLabelText: String? = nil,
        welcomeLabelFont: NSFont? = nil,
        welcomeLabelColor: NSColor? = nil,
        versionLabelText: String? = nil,
        versionLabelFont: NSFont? = nil,
        versionLabelColor: NSColor? = nil,
        appIconImage: NSImage? = nil,
        appIconImageShadow: NSShadow? = nil,
        primaryAction: WelcomeAction? = nil,
        secondaryAction: WelcomeAction? = nil,
        tertiaryAction: WelcomeAction? = nil,
        checkShowOnLaunch: Bool = true
    ) {
        self.style = style
        self.welcomeLabelText = welcomeLabelText
        self.welcomeLabelFont = welcomeLabelFont
        self.welcomeLabelColor = welcomeLabelColor
        self.versionLabelText = versionLabelText
        self.versionLabelFont = versionLabelFont
        self.versionLabelColor = versionLabelColor
        self.appIconImage = appIconImage
        self.appIconImageShadow = appIconImageShadow
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.tertiaryAction = tertiaryAction
        self.checkShowOnLaunch = checkShowOnLaunch
    }
}

#endif
