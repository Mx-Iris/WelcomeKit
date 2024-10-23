import AppKit

extension NSView {
    public var edgesAnchor: NSLayoutEdgesAnchor {
        .init(leadingAnchor: leadingAnchor, trailingAnchor: trailingAnchor, topAnchor: topAnchor, bottomAnchor: bottomAnchor)
    }
}

public final class NSLayoutEdgesAnchor: NSObject {
    private let leadingAnchor: NSLayoutXAxisAnchor

    private let trailingAnchor: NSLayoutXAxisAnchor

    private let topAnchor: NSLayoutYAxisAnchor

    private let bottomAnchor: NSLayoutYAxisAnchor

    fileprivate init(leadingAnchor: NSLayoutXAxisAnchor, trailingAnchor: NSLayoutXAxisAnchor, topAnchor: NSLayoutYAxisAnchor, bottomAnchor: NSLayoutYAxisAnchor) {
        self.leadingAnchor = leadingAnchor
        self.trailingAnchor = trailingAnchor
        self.topAnchor = topAnchor
        self.bottomAnchor = bottomAnchor
        super.init()
    }

    public func constraint(equalTo anchor: NSLayoutEdgesAnchor) -> [NSLayoutConstraint] {
        [
            topAnchor.constraint(equalTo: anchor.topAnchor),
            bottomAnchor.constraint(equalTo: anchor.bottomAnchor),
            leadingAnchor.constraint(equalTo: anchor.leadingAnchor),
            trailingAnchor.constraint(equalTo: anchor.trailingAnchor),
        ]
    }

    public func constraint(greaterThanOrEqualTo anchor: NSLayoutEdgesAnchor) -> [NSLayoutConstraint] {
        [
            topAnchor.constraint(greaterThanOrEqualTo: anchor.topAnchor),
            bottomAnchor.constraint(greaterThanOrEqualTo: anchor.bottomAnchor),
            leadingAnchor.constraint(greaterThanOrEqualTo: anchor.leadingAnchor),
            trailingAnchor.constraint(greaterThanOrEqualTo: anchor.trailingAnchor),
        ]
    }

    public func constraint(lessThanOrEqualTo anchor: NSLayoutEdgesAnchor) -> [NSLayoutConstraint] {
        [
            topAnchor.constraint(lessThanOrEqualTo: anchor.topAnchor),
            bottomAnchor.constraint(lessThanOrEqualTo: anchor.bottomAnchor),
            leadingAnchor.constraint(lessThanOrEqualTo: anchor.leadingAnchor),
            trailingAnchor.constraint(lessThanOrEqualTo: anchor.trailingAnchor),
        ]
    }

    public func constraint(equalTo anchor: NSLayoutEdgesAnchor, constant c: CGFloat) -> [NSLayoutConstraint] {
        [
            topAnchor.constraint(equalTo: anchor.topAnchor, constant: c),
            bottomAnchor.constraint(equalTo: anchor.bottomAnchor, constant: c),
            leadingAnchor.constraint(equalTo: anchor.leadingAnchor, constant: c),
            trailingAnchor.constraint(equalTo: anchor.trailingAnchor, constant: c),
        ]
    }

    public func constraint(greaterThanOrEqualTo anchor: NSLayoutEdgesAnchor, constant c: CGFloat) -> [NSLayoutConstraint] {
        [
            topAnchor.constraint(greaterThanOrEqualTo: anchor.topAnchor, constant: c),
            bottomAnchor.constraint(greaterThanOrEqualTo: anchor.bottomAnchor, constant: c),
            leadingAnchor.constraint(greaterThanOrEqualTo: anchor.leadingAnchor, constant: c),
            trailingAnchor.constraint(greaterThanOrEqualTo: anchor.trailingAnchor, constant: c),
        ]
    }

    public func constraint(lessThanOrEqualTo anchor: NSLayoutEdgesAnchor, constant c: CGFloat) -> [NSLayoutConstraint] {
        [
            topAnchor.constraint(lessThanOrEqualTo: anchor.topAnchor, constant: c),
            bottomAnchor.constraint(lessThanOrEqualTo: anchor.bottomAnchor, constant: c),
            leadingAnchor.constraint(lessThanOrEqualTo: anchor.leadingAnchor, constant: c),
            trailingAnchor.constraint(lessThanOrEqualTo: anchor.trailingAnchor, constant: c),
        ]
    }

    public func anchorWithOffset(to otherAnchor: NSLayoutEdgesAnchor) -> [NSLayoutDimension] {
        [
            topAnchor.anchorWithOffset(to: otherAnchor.topAnchor),
            bottomAnchor.anchorWithOffset(to: otherAnchor.bottomAnchor),
            leadingAnchor.anchorWithOffset(to: otherAnchor.leadingAnchor),
            trailingAnchor.anchorWithOffset(to: otherAnchor.trailingAnchor),
        ]
    }
}
