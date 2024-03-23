import AppKit

final class WelcomeViewController: ViewController {
    
    var configuration: WelcomeConfiguration = .init() {
        didSet {
            reloadData()
        }
    }
    
    func reloadData() {
        welcomeLabel.do {
            $0.stringValue = configuration.welcomeLabelText ?? "Welcome to \(Bundle.main.appName)"
            $0.textColor = configuration.welcomeLabelColor ?? .labelColor
            $0.font = configuration.welcomeLabelFont ?? .systemFont(ofSize: 36, weight: .regular)
            
        }
        versionLabel.do {
            $0.stringValue = configuration.versionLabelText ?? "Version \(Bundle.main.appVersion)"
            $0.textColor = configuration.versionLabelColor ?? .secondaryLabelColor
            $0.font = configuration.versionLabelFont ?? .systemFont(ofSize: 13, weight: .light)
        }
        appImageView.image = configuration.appIconImage ?? NSApplication.shared.applicationIconImage
        
        actionTableView.reloadData()
    }
    
    lazy var appImageView: NSImageView = .init()

    lazy var welcomeLabel: NSTextField = .init(labelWithString: "")

    lazy var versionLabel: NSTextField = .init(labelWithString: "")

    lazy var actionTableView: NSTableView = .init().then {
        $0.rowHeight = 46
        $0.intercellSpacing = .zero
        $0.style = .plain
        $0.selectionHighlightStyle = .none
        $0.addTableColumn(NSTableColumn(identifier: .init("DefaultTableColumn")))
        $0.dataSource = self
        $0.delegate = self
        $0.action = #selector(actionTableViewDidClick(_:))
    }

    lazy var showOnLaunchCheckbox: NSButton = .init(checkboxWithTitle: "Show this window when \(Bundle.main.appName) launches", target: self, action: #selector(showOnLaunchCheckboxAction(_:))).then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.state = .on
    }

    lazy var closeButton: HoverButton = .init().then {
        $0.hoveringImage = Bundle.module.image(forResource: "close_hover")
        $0.notHoveringImage = Bundle.module.image(forResource: "close")
        $0.target = self
        $0.action = #selector(closeButtonAction(_:))
        $0.isBordered = false
    }

    override func loadView() {
        view = View(frame: .init(x: 0, y: 0, width: 500, height: 460))
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        reloadData()
        NSTrackingArea(rect: .zero, options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect], owner: self, userInfo: nil).do {
            view.addTrackingArea($0)
        }
    }

    func setup() {
        view.addSubview(closeButton)
        view.addSubview(appImageView)
        view.addSubview(welcomeLabel)
        view.addSubview(versionLabel)
        view.addSubview(actionTableView)
        view.addSubview(showOnLaunchCheckbox)
        closeButton.makeConstraints { make in
            make.topAnchor.constraint(equalTo: view.topAnchor, constant: 12)
            make.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12)
        }

        appImageView.makeConstraints { make in
            make.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
            make.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        }

        welcomeLabel.makeConstraints { make in
            make.topAnchor.constraint(equalTo: appImageView.bottomAnchor, constant: 2)
            make.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        }

        versionLabel.makeConstraints { make in
            make.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 6)
            make.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        }

        actionTableView.makeConstraints { make in
            make.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 54)
            make.rightAnchor.constraint(equalTo: view.rightAnchor)
            make.heightAnchor.constraint(equalToConstant: 138)
            make.bottomAnchor.constraint(equalTo: showOnLaunchCheckbox.topAnchor, constant: -30)
        }

        showOnLaunchCheckbox.makeConstraints { make in
            make.leftAnchor.constraint(equalTo: actionTableView.leftAnchor)
            make.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        }
    }

//    @objc func welcomeActionCellonClick(_ sender: NSClickGestureRecognizer) {
//        guard let cell = sender.view as? WelcomeActionCellView, let index = cellViews.firstIndex(where: {
//            $0 === cell
//        }) else { return }
//
//        delegate?.welcomeViewController(self, didClickCellAt: index)
//    }
//
//    func reloadData(for models: [WelcomeActionModel]) {
//        cellViews.forEach { cell in
//            vStackView.removeArrangedSubview(cell)
//            cell.gestureRecognizers.forEach { cell.removeGestureRecognizer($0) }
//        }
//        cellViews.removeAll()
//        cellViews = models.map { model in
//            let cellView = makeCellView(for: model)
//            cellView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(welcomeActionCellonClick(_:))))
//            vStackView.addArrangedSubview(cellView)
//            return cellView
//        }
//    }

    override func mouseEntered(with event: NSEvent) {
        closeButton.alphaValue = 1
        showOnLaunchCheckbox.alphaValue = 1
    }

    override func mouseExited(with event: NSEvent) {
        closeButton.animator().alphaValue = 0
        showOnLaunchCheckbox.animator().alphaValue = 0
    }

    @objc func showOnLaunchCheckboxAction(_ sender: NSButton) {
//        delegate?.welcomeViewController(self, didCheckShowWhenLaunch: sender.state == .on ? true : false)
    }

    @objc func closeButtonAction(_ sender: NSButton) {
        view.window?.close()
    }
    
    @objc func actionTableViewDidClick(_ sender: NSTableView) {
        let clickedRow = sender.clickedRow
        let allActions = configuration.allActions
        guard clickedRow >= 0, clickedRow < allActions.count else { return }
        let action = allActions[clickedRow]
        action.action?(action)
    }
}

extension WelcomeViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        configuration.allActions.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(ofClass: WelcomeActionCellView.self, owner: nil)
        let action = configuration.allActions[row]
        
        cell.iconImageView.do {
            $0.image = action.image
            $0.contentTintColor = action.imageTintColor
        }
        
        cell.titleLabel.do {
            $0.stringValue = action.title ?? ""
            $0.textColor = action.titleColor ?? .labelColor
            $0.font = action.titleFont ?? .systemFont(ofSize: 13, weight: .bold)
        }
        
        cell.detailLabel.do {
            $0.stringValue = action.subtitle ?? ""
            $0.textColor = action.subtitleColor ?? .labelColor
            $0.font = action.subtitleFont ?? .systemFont(ofSize: 12, weight: .regular)
        }
        
        return cell
    }
    
}


extension Bundle {
    var appName: String {
        infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
    }

    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
}
