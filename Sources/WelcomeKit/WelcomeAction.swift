#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public struct WelcomeAction {
    public var image: NSImage?
    public var imageTintColor: NSColor?
    public var title: String?
    public var titleColor: NSColor?
    public var titleFont: NSFont?
    public var subtitle: String?
    public var subtitleColor: NSColor?
    public var subtitleFont: NSFont?
    public var action: ((Self) -> Void)?

    public init(image: NSImage? = nil, imageTintColor: NSColor? = nil, title: String? = nil, titleColor: NSColor? = nil, titleFont: NSFont? = nil, subtitle: String? = nil, subtitleColor: NSColor? = nil, subtitleFont: NSFont? = nil, action: ( (Self) -> Void)? = nil) {
        self.image = image
        self.imageTintColor = imageTintColor
        self.title = title
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.subtitle = subtitle
        self.subtitleColor = subtitleColor
        self.subtitleFont = subtitleFont
        self.action = action
    }
}

#endif
