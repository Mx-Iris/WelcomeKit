import AppKit

protocol RecentViewControllerDelegate: AnyObject {
    func recentViewController(_ recentViewController: RecentViewController, didSelectRecentProjectAt index: Int)
    func recentViewController(_ recentViewController: RecentViewController, didDoblueClickRecentProjectAt index: Int)
}

class RecentViewController: ViewController {
    enum Columns: String, CaseIterable {
        case recentProject

        var interfaceIdentifier: NSUserInterfaceItemIdentifier {
            .init(rawValue)
        }
    }

    weak var delegate: RecentViewControllerDelegate?

    lazy var visualEffectView: NSVisualEffectView = .init().then {
        $0.material = .underWindowBackground
        $0.blendingMode = .behindWindow
        $0.state = .followsWindowActiveState
    }

    lazy var scrollView: NSScrollView = .init().then {
        $0.documentView = tableView
        $0.automaticallyAdjustsContentInsets = false
        $0.contentView.drawsBackground = false
    }

    lazy var dataSource: NSTableViewDiffableDataSource<Columns, URL> = .init(tableView: tableView) {
        tableView, tableColumn, row, projectURL in
        var cell = tableView.makeView(withIdentifier: tableColumn.identifier, owner: self) as? RecentProjectCellView
        if cell == nil {
            cell = RecentProjectCellView()
        }
        let properties = try? projectURL.resourceValues(forKeys: [.localizedNameKey, .effectiveIconKey])
        cell?.iconImageView.image = properties?.effectiveIcon as? NSImage
        cell?.titleLabel.stringValue = properties?.localizedName ?? ""
        cell?.detailLabel.stringValue = projectURL.path
        return cell!
    }

    lazy var tableView: NSTableView = .init().then {
        $0.addTableColumn(NSTableColumn(identifier: Columns.recentProject.interfaceIdentifier))
        $0.headerView = nil
        $0.backgroundColor = .clear
        $0.intercellSpacing = .init(width: 10, height: 0)
        $0.style = .inset
        $0.rowHeight = 44
        $0.doubleAction = #selector(onDoubleClick)
        $0.menu = NSMenu().then {
            $0.addItem(withTitle: "Show in Finder", action: #selector(showInFinderAction(_:)), keyEquivalent: "")
        }
    }
    
    @objc func showInFinderAction(_ sender: NSMenuItem) {
        guard let url = dataSource.itemIdentifier(forRow: tableView.selectedRow) else { return }
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
    
    override func loadView() {
        view = visualEffectView
        visualEffectView.frame = .init(x: 500, y: 0, width: 300, height: 460)
        visualEffectView.addSubview(scrollView)
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        scrollView.makeConstraints { make in
            make.topAnchor.constraint(equalTo: view.topAnchor)
            make.leftAnchor.constraint(equalTo: view.leftAnchor)
            make.rightAnchor.constraint(equalTo: view.rightAnchor)
            make.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    func reloadData(for urls: [URL]) {
        var snapshot = NSDiffableDataSourceSnapshot<Columns, URL>()
        snapshot.appendSections([.recentProject])
        snapshot.appendItems(urls, toSection: .recentProject)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc func onDoubleClick() {
        delegate?.recentViewController(self, didDoblueClickRecentProjectAt: tableView.clickedRow)
    }
}

extension RecentViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        delegate?.recentViewController(self, didSelectRecentProjectAt: tableView.selectedRow)
    }
}

extension NSEdgeInsets {
    static let zero = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}
