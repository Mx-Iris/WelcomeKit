#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

extension NSView {
    func addSubview(_ subview: NSView, fill: Bool) {
        addSubview(subview)
        if fill {
            subview.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: topAnchor),
                subview.leadingAnchor.constraint(equalTo: leadingAnchor),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor),
                subview.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }
    }
}

#endif
