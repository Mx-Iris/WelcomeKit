import AppKit

@_implementationOnly import Then

public protocol WelcomePanelDataSource: AnyObject {
    func numberOfActions(_ welcomePanel: WelcomePanelController) -> Int
    func numberOfProjects(_ welcomePanel: WelcomePanelController) -> Int
    func welcomePanel(_ welcomePanel: WelcomePanelController, urlForRecentTableViewAt index: Int) -> URL
    func welcomePanel(_ welcomePanel: WelcomePanelController, modelForWelcomeActionViewAt index: Int) -> WelcomeActionModel
}

public protocol WelcomePanelDelegate: AnyObject {
    func welcomePanel(_ welcomePanel: WelcomePanelController, didClickActionAt index: Int)
    func welcomePanel(_ welcomePanel: WelcomePanelController, didCheckShowPanelWhenLaunch isCheck: Bool)
    func welcomePanel(_ welcomePanel: WelcomePanelController, didSelectRecentProjectAt index: Int)
    func welcomePanel(_ welcomePanel: WelcomePanelController, didDoubleClickRecentProjectAt index: Int)
}

public final class WelcomePanelController: NSWindowController {
    public weak var dataSource: WelcomePanelDataSource? {
        didSet {
            reloadData()
        }
    }

    public weak var delegate: WelcomePanelDelegate?

    public var welcomeLabelText: String? {
        didSet {
            guard let welcomeLabelText else { return }
            welcomeViewController.welcomeLabel.stringValue = welcomeLabelText
        }
    }

    public var versionLabelText: String? {
        didSet {
            guard let versionLabelText else { return }
            welcomeViewController.versionLabel.stringValue = versionLabelText
        }
    }

    public var appIconImage: NSImage? {
        didSet {
            welcomeViewController.appImageView.image = appIconImage
        }
    }

    private lazy var welcomeViewController = WelcomeViewController().then {
        $0.delegate = self
    }

    private lazy var recentViewController = RecentViewController().then {
        $0.delegate = self
    }

    public init() {
        let contentViewController = ViewController().then {
            $0.view.frame = .init(x: 0, y: 0, width: 800, height: 460)
        }
        let window = NSWindow(contentViewController: contentViewController).then {
            $0.titlebarAppearsTransparent = true
            $0.styleMask = [.titled, .fullSizeContentView]
            $0.titleVisibility = .hidden
            $0.center()
            $0.isMovableByWindowBackground = true
        }
        super.init(window: window)
        contentViewController.do {
            $0.view.addSubview(welcomeViewController.view)
            $0.view.addSubview(recentViewController.view)
            $0.addChild(welcomeViewController)
            $0.addChild(recentViewController)
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func reloadData() {
        guard let dataSource = dataSource else { return }

        var maxActionCellCount = dataSource.numberOfActions(self)
        if maxActionCellCount > 3, maxActionCellCount < 0 {
            maxActionCellCount = 3
        }
        let actionModels = (0 ..< maxActionCellCount).map {
            dataSource.welcomePanel(self, modelForWelcomeActionViewAt: $0)
        }
        var numberOfProjects = dataSource.numberOfProjects(self)
        if numberOfProjects < 0 {
            numberOfProjects = 0
        }
        let projectURLs = (0 ..< numberOfProjects).map {
            dataSource.welcomePanel(self, urlForRecentTableViewAt: $0)
        }
        welcomeViewController.reloadData(for: actionModels)
        recentViewController.reloadData(for: projectURLs)
    }
}

extension WelcomePanelController: WelcomeViewControllerDelegate {
    func welcomeViewController(_ welcomeViewController: WelcomeViewController, didCheckShowWhenLaunch isCheck: Bool) {
        delegate?.welcomePanel(self, didCheckShowPanelWhenLaunch: isCheck)
    }

    func welcomeViewController(_ welcomeViewController: WelcomeViewController, didClickCellAt index: Int) {
        delegate?.welcomePanel(self, didClickActionAt: index)
    }
}

extension WelcomePanelController: RecentViewControllerDelegate {
    func recentViewController(_ recentViewController: RecentViewController, didSelectRecentProjectAt index: Int) {
        delegate?.welcomePanel(self, didSelectRecentProjectAt: index)
    }

    func recentViewController(_ recentViewController: RecentViewController, didDoblueClickRecentProjectAt index: Int) {
        delegate?.welcomePanel(self, didDoubleClickRecentProjectAt: index)
    }
}
