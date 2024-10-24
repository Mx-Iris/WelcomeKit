import AppKit

class View: NSView {
    var backgroundColor: NSColor? {
        didSet {
            needsDisplay = true
        }
    }

    var cornerRadius: CGFloat = 0 {
        didSet {
            needsDisplay = true
        }
    }

    override var wantsUpdateLayer: Bool { true }

    override func updateLayer() {
        super.updateLayer()

        layer?.backgroundColor = backgroundColor?.cgColor
        layer?.cornerRadius = cornerRadius
        layer?.masksToBounds = cornerRadius != 0
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: NSViewController {
    lazy var contentView = View()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }
}

class TableCellView: NSTableCellView {
    var backgroundColor: NSColor? {
        didSet {
            needsDisplay = true
        }
    }

    var cornerRadius: CGFloat = 0 {
        didSet {
            needsDisplay = true
        }
    }

    override var wantsUpdateLayer: Bool { true }

    override func updateLayer() {
        super.updateLayer()

        layer?.backgroundColor = backgroundColor?.cgColor
        layer?.cornerRadius = cornerRadius
        layer?.masksToBounds = cornerRadius != 0
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TrackView: View {
    var shouldTrackMouseEnteredAndExited: Bool { true }

    override func updateTrackingAreas() {
        guard shouldTrackMouseEnteredAndExited else { return }
        trackingAreas.forEach { removeTrackingArea($0) }
        let newArea = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeInKeyWindow, .inVisibleRect], owner: self, userInfo: nil)
        addTrackingArea(newArea)
    }
}

final class ScrollView: NSScrollView {
    override var wantsUpdateLayer: Bool { true }

    override var backgroundColor: NSColor {
        didSet {
            needsDisplay = true
        }
    }
    
    override func updateLayer() {
        super.updateLayer()
        layer?.backgroundColor = backgroundColor.cgColor
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        backgroundColor = .clear
        drawsBackground = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didAddSubview(_ subview: NSView) {
        if subview is NSVisualEffectView {
            subview.removeFromSuperview()
        }
        super.didAddSubview(subview)
    }
}
