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

public struct WelcomeConfiguration {
    public var welcomeLabelText: String?
    public var welcomeLabelFont: NSFont?
    public var welcomeLabelColor: NSColor?
    public var versionLabelText: String?
    public var versionLabelFont: NSFont?
    public var versionLabelColor: NSColor?
    public var appIconImage: NSImage?
    public var primaryAction: WelcomeAction?
    public var secondaryAction: WelcomeAction?
    public var tertiaryAction: WelcomeAction?
    
    var allActions: [WelcomeAction] {
        [primaryAction, secondaryAction, tertiaryAction].compactMap { $0 }
    }
    
    public init(welcomeLabelText: String? = nil, welcomeLabelFont: NSFont? = nil, welcomeLabelColor: NSColor? = nil, versionLabelText: String? = nil, versionLabelFont: NSFont? = nil, versionLabelColor: NSColor? = nil, appIconImage: NSImage? = nil, primaryAction: WelcomeAction? = nil, secondaryAction: WelcomeAction? = nil, tertiaryAction: WelcomeAction? = nil) {
        self.welcomeLabelText = welcomeLabelText
        self.welcomeLabelFont = welcomeLabelFont
        self.welcomeLabelColor = welcomeLabelColor
        self.versionLabelText = versionLabelText
        self.versionLabelFont = versionLabelFont
        self.versionLabelColor = versionLabelColor
        self.appIconImage = appIconImage
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.tertiaryAction = tertiaryAction
    }
}

public struct WelcomeAction {
    public var image: NSImage?
    public var imageTintColor: NSColor?
    public var title: String?
    public var titleColor: NSColor?
    public var titleFont: NSFont?
    public var subtitle: String?
    public var subtitleColor: NSColor?
    public var subtitleFont: NSFont?
    public var action: ((Self) -> Void)?

    public init(image: NSImage? = nil, imageTintColor: NSColor? = nil, title: String? = nil, titleColor: NSColor? = nil, titleFont: NSFont? = nil, subtitle: String? = nil, subtitleColor: NSColor? = nil, subtitleFont: NSFont? = nil, action: ( (Self) -> Void)? = nil) {
        self.image = image
        self.imageTintColor = imageTintColor
        self.title = title
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.subtitle = subtitle
        self.subtitleColor = subtitleColor
        self.subtitleFont = subtitleFont
        self.action = action
    }
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

    private lazy var welcomeViewController = WelcomeViewController()

    private lazy var projectsViewController = ProjectsViewController()

    public init(configuration: WelcomeConfiguration = .init()) {
        self.configuration = configuration
        
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
            $0.view.addSubview(projectsViewController.view)
            $0.addChild(welcomeViewController)
            $0.addChild(projectsViewController)
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
