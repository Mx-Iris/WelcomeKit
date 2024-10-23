#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

extension NSTableView {
    func makeView<CellView: NSTableCellView>(ofClass cls: CellView.Type, owner: Any?) -> CellView {
        if let reuseView = makeView(withIdentifier: .init(String(describing: CellView.self)), owner: owner) as? CellView {
            return reuseView
        } else {
            let cellView = CellView()
            cellView.identifier = .init(String(describing: CellView.self))
            return cellView
        }
    }
}



#endif
