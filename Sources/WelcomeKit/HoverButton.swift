import AppKit

class HoverButton: NSButton {
    var hoveringImage: NSImage?

    var notHoveringImage: NSImage? {
        didSet {
            image = notHoveringImage
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addTrackingArea()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addTrackingArea()
    }

    private func addTrackingArea() {
        addTrackingArea(NSTrackingArea(rect: .zero, options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect], owner: self, userInfo: nil))
    }

    override func mouseEntered(with event: NSEvent) {
        image = hoveringImage
    }

    override func mouseExited(with event: NSEvent) {
        image = notHoveringImage
    }
}
