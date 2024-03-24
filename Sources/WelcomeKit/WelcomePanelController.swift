import AppKit

public protocol WelcomePanelDataSource: AnyObject {
    func welcomePanelUsesRecentDocumentURLs(_ welcomePanel: WelcomePanelController) -> Bool
    func numberOfProjects(in welcomePanel: WelcomePanelController) -> Int
    func welcomePanel(_ welcomePanel: WelcomePanelController, urlForProjectAtIndex index: Int) -> URL
}

public protocol WelcomePanelDelegate: AnyObject {
    func welcomePanel(_ welcomePanel: WelcomePanelController, didCheckShowPanelWhenLaunch isCheck: Bool)
    func welcomePanel(_ welcomePanel: WelcomePanelController, didSelectProjectAtIndex index: Int)
    func welcomePanel(_ welcomePanel: WelcomePanelController, didDoubleClickProjectAtIndex index: Int)
}

public final class WelcomePanelController: NSWindowController {
    public weak var dataSource: WelcomePanelDataSource? {
        didSet {
            reloadData()
        }
    }

    public weak var delegate: WelcomePanelDelegate?

    public var configuration: WelcomeConfiguration {
        didSet {
            welcomeViewController.configuration = configuration
        }
    }

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

    private lazy var contentWindow = NSWindow(contentRect: .init(x: 0, y: 0, width: 802, height: 460), styleMask: [.titled, .fullSizeContentView], backing: .buffered, defer: true).then {
        $0.titlebarAppearsTransparent = true
        $0.titleVisibility = .hidden
        $0.center()
        $0.isMovableByWindowBackground = true
        $0.delegate = self
    }

    private lazy var welcomeViewController = WelcomeViewController()

    private lazy var projectsViewController = ProjectsViewController()

    public init(configuration: WelcomeConfiguration = .init()) {
        self.configuration = configuration
        super.init(window: nil)
    }

    public override var windowNibName: NSNib.Name? { "" }

    public override func loadWindow() {
        window = contentWindow
    }

    public override func windowDidLoad() {
        super.windowDidLoad()

        let contentViewController = ViewController().then {
            $0.view.frame = .init(x: 0, y: 0, width: 800, height: 460)
        }

        contentViewController.do {
            $0.view.addSubview(welcomeViewController.view)
            $0.view.addSubview(projectsViewController.view)
            $0.addChild(welcomeViewController)
            $0.addChild(projectsViewController)
        }

        self.contentViewController = contentViewController

        welcomeViewController.view.makeConstraints { make in
            make.topAnchor.constraint(equalTo: contentViewController.view.topAnchor)
            make.leftAnchor.constraint(equalTo: contentViewController.view.leftAnchor)
            make.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor)
            make.rightAnchor.constraint(equalTo: projectsViewController.view.leftAnchor)
        }

        projectsViewController.view.makeConstraints { make in
            make.widthAnchor.constraint(equalToConstant: 307)
            make.topAnchor.constraint(equalTo: contentViewController.view.topAnchor)
            make.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor)
            make.rightAnchor.constraint(equalTo: contentViewController.view.rightAnchor)
        }

        projectsViewController.didSelect = { [weak self] index in
            guard let self else { return }
            delegate?.welcomePanel(self, didSelectProjectAtIndex: index)
        }
        projectsViewController.didDoubleClick = { [weak self] index in
            guard let self else { return }
            delegate?.welcomePanel(self, didDoubleClickProjectAtIndex: index)
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func reloadData() {
        guard let dataSource else { return }

        if dataSource.welcomePanelUsesRecentDocumentURLs(self) {
            projectsViewController.usesRecentDocumentURLs = true
        } else {
            var numberOfProjects = dataSource.numberOfProjects(in: self)
            if numberOfProjects < 0 {
                numberOfProjects = 0
            }
            let projectURLs = (0 ..< numberOfProjects).map {
                dataSource.welcomePanel(self, urlForProjectAtIndex: $0)
            }
            projectsViewController.usesRecentDocumentURLs = false
            projectsViewController.recentProjectURLs = projectURLs
        }
        welcomeViewController.reloadData()
        projectsViewController.reloadData()
    }
}

extension WelcomePanelController: NSWindowDelegate {
    public func windowDidChangeOcclusionState(_ notification: Notification) {
        if contentWindow.occlusionState.contains(.visible) {
            reloadData()
        }
    }
}
