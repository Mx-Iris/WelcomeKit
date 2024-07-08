#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public struct WelcomeConfiguration {
    public var welcomeLabelText: String?
    public var welcomeLabelFont: NSFont?
    public var welcomeLabelColor: NSColor?
    public var versionLabelText: String?
    public var versionLabelFont: NSFont?
    public var versionLabelColor: NSColor?
    public var appIconImage: NSImage?
    public var primaryAction: WelcomeAction?
    public var secondaryAction: WelcomeAction?
    public var tertiaryAction: WelcomeAction?
    public var checkShowOnLaunch: Bool
    
    public var allActions: [WelcomeAction] {
        [primaryAction, secondaryAction, tertiaryAction].compactMap { $0 }
    }
    
    public init(
        welcomeLabelText: String? = nil,
        welcomeLabelFont: NSFont? = nil,
        welcomeLabelColor: NSColor? = nil,
        versionLabelText: String? = nil,
        versionLabelFont: NSFont? = nil,
        versionLabelColor: NSColor? = nil,
        appIconImage: NSImage? = nil,
        primaryAction: WelcomeAction? = nil,
        secondaryAction: WelcomeAction? = nil,
        tertiaryAction: WelcomeAction? = nil,
        checkShowOnLaunch: Bool = true
    ) {
        self.welcomeLabelText = welcomeLabelText
        self.welcomeLabelFont = welcomeLabelFont
        self.welcomeLabelColor = welcomeLabelColor
        self.versionLabelText = versionLabelText
        self.versionLabelFont = versionLabelFont
        self.versionLabelColor = versionLabelColor
        self.appIconImage = appIconImage
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.tertiaryAction = tertiaryAction
        self.checkShowOnLaunch = checkShowOnLaunch
    }
}

#endif
