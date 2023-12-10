@_implementationOnly import Then
import AppKit
@_implementationOnly import SnapKit

protocol WelcomeViewControllerDelegate: AnyObject {
    func welcomeViewController(_ welcomeViewController: WelcomeViewController, didClickCellAt index: Int)
    func welcomeViewController(_ welcomeViewController: WelcomeViewController, didCheckShowWhenLaunch isCheck: Bool)
}

final class WelcomeViewController: ViewController {
    lazy var appImageView: NSImageView = .init().then {
        $0.image = NSApplication.shared.applicationIconImage
    }

    lazy var welcomeLabel: NSTextField = .init(labelWithString: "Welcome to \(Bundle.main.appName)").then {
        $0.font = .systemFont(ofSize: 36)
    }

    lazy var versionLabel: NSTextField = .init(labelWithString: "Version \(Bundle.main.appVersion)").then {
        $0.textColor = .secondaryLabelColor
        $0.font = .systemFont(ofSize: 13)
    }

    lazy var vStackView: NSStackView = .init().then {
        $0.alignment = .centerY
        $0.orientation = .vertical
    }

    lazy var showOnLaunchCheckbox: NSButton = .init(checkboxWithTitle: "Show this window when \(Bundle.main.appName) launches", target: self, action: #selector(showOnLaunchCheckboxAction(_:))).then {
        $0.state = .on
    }

    lazy var closeButton: HoverButton = .init().then {
        $0.hoveringImage = Bundle.module.image(forResource: "close_hover")
        $0.notHoveringImage = Bundle.module.image(forResource: "close")
        $0.target = self
        $0.action = #selector(closeButtonAction(_:))
        $0.isBordered = false
    }

    var cellViews: [WelcomeActionCellView] = []

    weak var delegate: WelcomeViewControllerDelegate?

    override func loadView() {
        view = View(frame: .init(x: 0, y: 0, width: 500, height: 460))
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NSTrackingArea(rect: .zero, options: [.mouseEnteredAndExited, .activeAlways, .inVisibleRect], owner: self, userInfo: nil).do {
            view.addTrackingArea($0)
        }
    }

    func setup() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.left.equalTo(15)
        }

        view.addSubview(appImageView)
        appImageView.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
        }

        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(appImageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }

        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        view.addSubview(vStackView)
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(30)
            make.left.equalTo(56)
            make.right.equalTo(-56)
            make.height.equalTo(135)
        }

        view.addSubview(showOnLaunchCheckbox)
        showOnLaunchCheckbox.snp.makeConstraints { make in
            make.left.equalTo(vStackView)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    @objc func welcomeActionCellonClick(_ sender: NSClickGestureRecognizer) {
        guard let cell = sender.view as? WelcomeActionCellView, let index = cellViews.firstIndex(where: {
            $0 === cell
        }) else { return }

        delegate?.welcomeViewController(self, didClickCellAt: index)
    }

    func reloadData(for models: [WelcomeActionModel]) {
        cellViews.forEach { cell in
            vStackView.removeArrangedSubview(cell)
            cell.gestureRecognizers.forEach { cell.removeGestureRecognizer($0) }
        }
        cellViews.removeAll()
        cellViews = models.map { model in
            let cellView = makeCellView(for: model)
            cellView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(welcomeActionCellonClick(_:))))
            vStackView.addArrangedSubview(cellView)
            return cellView
        }
    }

    func makeCellView(for model: WelcomeActionModel) -> WelcomeActionCellView {
        WelcomeActionCellView().then {
            $0.iconImageView.image = model.iconImage
            $0.titleLabel.stringValue = model.title
            $0.detailLabel.stringValue = model.detail
        }
    }

    override func mouseEntered(with event: NSEvent) {
        closeButton.alphaValue = 1
        showOnLaunchCheckbox.alphaValue = 1
    }

    override func mouseExited(with event: NSEvent) {
        closeButton.animator().alphaValue = 0
        showOnLaunchCheckbox.animator().alphaValue = 0
    }

    @objc func showOnLaunchCheckboxAction(_ sender: NSButton) {
        delegate?.welcomeViewController(self, didCheckShowWhenLaunch: sender.state == .on ? true : false)
    }
    
    @objc func closeButtonAction(_ sender: NSButton) {
        view.window?.close()
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
