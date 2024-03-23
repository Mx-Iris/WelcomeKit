import AppKit


class ProjectsViewController: ViewController {
    
    
    var recentProjectURLs: [URL] = []
    
    var usesRecentDocumentURLs: Bool = true
    
    var didSelect: (Int) -> Void = { _ in }
    
    var didDoubleClick: (Int) -> Void = { _ in }
    
    var urls: [URL] {
        if usesRecentDocumentURLs {
            return NSDocumentController.shared.recentDocumentURLs
        } else {
            return recentProjectURLs
        }
    }
    

//    lazy var visualEffectView: NSVisualEffectView = .init().then {
//        $0.material = .underWindowBackground
//        $0.blendingMode = .behindWindow
//        $0.state = .followsWindowActiveState
//    }

    lazy var scrollView: NSScrollView = .init().then {
        $0.documentView = tableView
        $0.drawsBackground = false
        $0.automaticallyAdjustsContentInsets = false
    }

//    lazy var dataSource: NSTableViewDiffableDataSource<Columns, URL> = .init(tableView: tableView) {
//        tableView, tableColumn, row, projectURL in
//
//    }

    lazy var tableView: NSTableView = .init().then {
        $0.addTableColumn(NSTableColumn(identifier: .init("DefalutTableColumn")))
        $0.headerView = nil
        $0.backgroundColor = .clear
        $0.intercellSpacing = .init(width: 10, height: 0)
        $0.style = .sourceList
        $0.rowHeight = 44
        $0.doubleAction = #selector(onDoubleClick)
        $0.menu = NSMenu().then {
            $0.addItem(withTitle: "Show in Finder", action: #selector(showInFinderAction(_:)), keyEquivalent: "")
        }
    }
    
    @objc func showInFinderAction(_ sender: NSMenuItem) {
        let selectedRow = tableView.selectedRow
        guard selectedRow >= 0, selectedRow < urls.count else { return }
        NSWorkspace.shared.activateFileViewerSelecting([urls[selectedRow]])
    }
    
    override func loadView() {
        view = scrollView
//        visualEffectView.frame = .init(x: 500, y: 0, width: 300, height: 460)
//        visualEffectView.addSubview(scrollView)
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        scrollView.makeConstraints { make in
//            make.topAnchor.constraint(equalTo: view.topAnchor)
//            make.leftAnchor.constraint(equalTo: view.leftAnchor)
//            make.rightAnchor.constraint(equalTo: view.rightAnchor)
//            make.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc func onDoubleClick() {
        didDoubleClick(tableView.clickedRow)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

extension ProjectsViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        urls.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(ofClass: ProjectCellView.self, owner: nil)
        let projectURL = urls[row]
        let properties = try? projectURL.resourceValues(forKeys: [.localizedNameKey, .effectiveIconKey])
        cell.iconImageView.image = properties?.effectiveIcon as? NSImage
        cell.titleLabel.stringValue = properties?.localizedName ?? ""
        cell.detailLabel.stringValue = projectURL.path
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        didSelect(tableView.selectedRow)
    }
}

extension NSEdgeInsets {
    static let zero = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}

extension NSTableView {
    func makeView<CellView: NSTableCellView>(ofClass cls: CellView.Type, owner: Any?) -> CellView {
        if let reuseView = makeView(withIdentifier: .init(String(describing: CellView.self)), owner: owner) as? CellView {
            return reuseView
        } else {
            let cellView = CellView()
            cellView.identifier = .init(String(describing: CellView.self))
            return CellView()
        }
    }
}
