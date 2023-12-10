import AppKit

public protocol WelcomeActionModel {
    var iconImage: NSImage { get }
    var title: String { get }
    var detail: String { get }
}
