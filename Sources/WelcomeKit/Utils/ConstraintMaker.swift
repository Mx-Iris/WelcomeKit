#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

extension NSView: ConstraintMaker {}

protocol ConstraintMaker: NSView {}

extension ConstraintMaker {
    func makeConstraints(@ArrayBuilder<NSLayoutConstraint> _ constraintsBuilder: (_ make: Self) -> [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraintsBuilder(self))
    }
}


#endif
