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

final class WelcomeWindow: NSWindow {
    override var canBecomeKey: Bool {
        true
    }
}

public final class WelcomePanelController: NSWindowController {
    public weak var dataSource: WelcomePanelDataSource? {
        didSet {
            reloadData()
        }
    }

    public weak var delegate: WelcomePanelDelegate?

    public let configuration: WelcomeConfiguration

    private lazy var contentWindow = WelcomeWindow(contentRect: configuration.style.windowRect, styleMask: [], backing: .buffered, defer: true).then {
        $0.titlebarAppearsTransparent = true
        $0.titleVisibility = .hidden
        $0.center()
        $0.isMovableByWindowBackground = true
        $0.delegate = self
    }

    private lazy var welcomeViewController = WelcomeViewController(configuration: configuration)

    private lazy var projectsViewController = ProjectsViewController(configuration: configuration)

    @available(*, unavailable)
    public override var window: NSWindow? {
        set {
            super.window = newValue
        }
        get {
            super.window
        }
    }
    
    @available(*, unavailable)
    public override var contentViewController: NSViewController? {
        set {
            super.contentViewController = newValue
        }
        get {
            super.contentViewController
        }
    }

    public init(configuration: WelcomeConfiguration = .init()) {
        self.configuration = configuration
        super.init(window: nil)
    }

    public override var windowNibName: NSNib.Name? { "" }

    public override func loadWindow() {
        super.window = contentWindow
    }

    public override func windowDidLoad() {
        super.windowDidLoad()

        contentWindow.styleMask = configuration.style.windowStyleMask
        contentWindow.collectionBehavior = [.moveToActiveSpace]
        contentWindow.isMovable = true
        contentWindow.isMovableByWindowBackground = true
        contentWindow.isReleasedWhenClosed = true
        contentWindow.backgroundColor = .clear
        contentWindow.hasShadow = true

        if configuration.style == .xcode15 {
            contentWindow.backgroundColor = .clear
        }

        let contentViewController = ViewController().then {
            $0.contentView.frame = configuration.style.windowRect
            $0.contentView.cornerRadius = configuration.style.windowCornerRadius
        }

        contentViewController.do {
            $0.view.addSubview(welcomeViewController.view)
            $0.view.addSubview(projectsViewController.view)
            $0.addChild(welcomeViewController)
            $0.addChild(projectsViewController)
        }

        super.contentViewController = contentViewController

        welcomeViewController.view.makeConstraints { make in
            make.topAnchor.constraint(equalTo: contentViewController.view.topAnchor)
            make.leftAnchor.constraint(equalTo: contentViewController.view.leftAnchor)
            make.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor)
            make.rightAnchor.constraint(equalTo: projectsViewController.view.leftAnchor)
        }

        projectsViewController.view.makeConstraints { make in
            make.widthAnchor.constraint(equalToConstant: configuration.style.projectViewWidth)
            make.topAnchor.constraint(equalTo: contentViewController.view.topAnchor)
            make.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor)
            make.rightAnchor.constraint(equalTo: contentViewController.view.rightAnchor)
        }

        welcomeViewController.didCheckShowOnLaunchCheckbox = { [weak self] button in
            guard let self else { return }
            delegate?.welcomePanel(self, didCheckShowPanelWhenLaunch: button.state == .on)
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

    public override func showWindow(_ sender: Any?) {
        reloadData()
        super.showWindow(sender)
    }
}

extension WelcomePanelController: NSWindowDelegate {
    public func windowDidChangeOcclusionState(_ notification: Notification) {
        if contentWindow.occlusionState.contains(.visible) {
            reloadData()
        }
    }
}
