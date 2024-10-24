import AppKit

class HoverButton: NSButton {
    var hoveringImage: NSImage?

    var notHoveringImage: NSImage? {
        didSet {
            if style == .xcode14 {
                image = notHoveringImage
            }
        }
    }

    let style: WelcomeStyle

    var isHovering: Bool = false

    init(style: WelcomeStyle) {
        self.style = style
        super.init(frame: .zero)
        addTrackingArea()
        if style == .xcode15 {
            image = NSImage(systemSymbolName: "xmark.circle.fill", accessibilityDescription: "Close")
            symbolConfiguration = .init(pointSize: 13, weight: .regular)
            contentTintColor = .tertiaryLabelColor
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addTrackingArea() {
        addTrackingArea(NSTrackingArea(rect: .zero, options: [.mouseEnteredAndExited, .mouseMoved, .activeAlways, .inVisibleRect], owner: self, userInfo: nil))
    }

    override func mouseMoved(with event: NSEvent) {
        isHovering = true
        needsDisplay = true
        if style == .xcode14 {
            if image !== hoveringImage {
                image = hoveringImage
            }
        } else {
            NSAnimationContext.runAnimationGroup {
                $0.allowsImplicitAnimation = true
                contentTintColor = .secondaryLabelColor
            }
        }
    }

    override func mouseEntered(with event: NSEvent) {
        isHovering = true
        needsDisplay = true
        if style == .xcode14 {
            image = hoveringImage
        } else {
            NSAnimationContext.runAnimationGroup {
                $0.allowsImplicitAnimation = true
                contentTintColor = .secondaryLabelColor
            }
        }
    }

    override func mouseExited(with event: NSEvent) {
        isHovering = false
        needsDisplay = true
        if style == .xcode14 {
            image = notHoveringImage
        } else {
            NSAnimationContext.runAnimationGroup {
                $0.allowsImplicitAnimation = true
                contentTintColor = .tertiaryLabelColor
            }
        }
    }
}
