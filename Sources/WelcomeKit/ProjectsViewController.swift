import AppKit

class ProjectsViewController: ViewController {
    let configuration: WelcomeConfiguration

    init(configuration: WelcomeConfiguration) {
        self.configuration = configuration
        super.init()
    }

    var recentProjectURLs: [URL] = []

    var usesRecentDocumentURLs: Bool = true

    var didSelect: (Int) -> Void = { _ in }

    var didDoubleClick: (Int) -> Void = { _ in }

    private var urls: [URL] {
        if usesRecentDocumentURLs {
            return NSDocumentController.shared.recentDocumentURLs
        } else {
            return recentProjectURLs
        }
    }

    lazy var visualEffectView = NSVisualEffectView().then {
        $0.blendingMode = .behindWindow
        $0.material = .underWindowBackground
    }
    
    lazy var scrollView: ScrollView = .init().then {
        $0.documentView = tableView
        $0.backgroundColor = configuration.style.projectViewBackgroundColor
        $0.automaticallyAdjustsContentInsets = false
    }

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

    lazy var placeholderLabel = NSTextField(labelWithString: "No Recent Projects").then {
        $0.font = .systemFont(ofSize: 16.5)
        $0.textColor = .secondaryLabelColor
        $0.isHidden = true
    }

    @objc func showInFinderAction(_ sender: NSMenuItem) {
        let selectedRow = tableView.selectedRow
        guard selectedRow >= 0, selectedRow < urls.count else { return }
        NSWorkspace.shared.activateFileViewerSelecting([urls[selectedRow]])
    }

    override func loadView() {
        view = visualEffectView
        visualEffectView.addSubview(scrollView, fill: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addSubview(placeholderLabel)
        placeholderLabel.makeConstraints { make in
            make.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
            make.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        }
    }

    @objc func onDoubleClick() {
        didDoubleClick(tableView.clickedRow)
    }

    func reloadData() {
        placeholderLabel.isHidden = !urls.isEmpty
        tableView.reloadData()
    }
}

extension ProjectsViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        urls.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell: ProjectCellView
        if let reuseView = tableView.makeView(withIdentifier: .init(String(describing: ProjectCellView.self)), owner: nil) as? ProjectCellView {
            cell = reuseView
        } else {
            let cellView = ProjectCellView(style: configuration.style)
            cellView.identifier = .init(String(describing: ProjectCellView.self))
            cell = cellView
        }
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
