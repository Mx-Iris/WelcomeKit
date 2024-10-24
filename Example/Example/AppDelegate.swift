//
//  AppDelegate.swift
//  Example
//
//  Created by JH on 2024/10/23.
//

import Cocoa
import WelcomeKit
import SFSymbol

@main
class AppDelegate: NSObject, NSApplicationDelegate, WelcomePanelDataSource {
    var downloadURLs: [URL] = []

    lazy var xcode14Configuration: WelcomeConfiguration = {
        var welcomeConfiguration = WelcomeConfiguration(style: .xcode14, welcomeLabelText: "Welcome to WelcomeKit")
        welcomeConfiguration.primaryAction = .init(
            image: .symbol(systemName: .plusSquare, pointSize: 28, weight: .medium),
            imageTintColor: .controlAccentColor,
            title: "Create a new Xcode project",
            subtitle: "Create an app for iPhone, iPad, Mac, Apple Watch, or Apple TV."
        )
        welcomeConfiguration.secondaryAction = .init(
            image: .symbol(systemName: .squareAndArrowDownOnSquare, pointSize: 28, weight: .medium),
            imageTintColor: .controlAccentColor,
            title: "Clone an existing project",
            subtitle: "Start working on something from a Git repository."
        )
        welcomeConfiguration.tertiaryAction = .init(
            image: .symbol(systemName: .folder, pointSize: 28, weight: .medium),
            imageTintColor: .controlAccentColor,
            title: "Open a project or file",
            subtitle: "Open an existing project or file on your Mac."
        )
        return welcomeConfiguration
    }()

    lazy var xcode15Configuration: WelcomeConfiguration = {
        var welcomeConfiguration = WelcomeConfiguration(style: .xcode15, welcomeLabelText: "WelcomeKit")
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 50
        shadow.shadowOffset = .init(width: 0, height: 2)
        shadow.shadowColor = .init(red: 0.09, green: 0.42, blue: 0.88, alpha: 0.55)
        welcomeConfiguration.appIconImageShadow = shadow
        welcomeConfiguration.primaryAction = .init(image: .symbol(systemName: .plusSquare, pointSize: 17, weight: .semibold), title: "Create New File...")
        welcomeConfiguration.secondaryAction = .init(image: .symbol(systemName: .squareAndArrowDownOnSquare, pointSize: 17, weight: .semibold), title: "Clone Git Repository...")
        welcomeConfiguration.tertiaryAction = .init(image: .symbol(systemName: .folder, pointSize: 17, weight: .semibold), title: "Open File or Folder...")
        return welcomeConfiguration
    }()

    lazy var xcode14WelcomePanelController: WelcomePanelController = {
        let xcode14WelcomePanelController = WelcomePanelController(configuration: xcode14Configuration)
        xcode14WelcomePanelController.showWindow(nil)
        xcode14WelcomePanelController.dataSource = self
        return xcode14WelcomePanelController
    }()

    lazy var xcode15WelcomePanelController: WelcomePanelController = {
        let xcode15WelcomePanelController = WelcomePanelController(configuration: xcode15Configuration)
        xcode15WelcomePanelController.showWindow(nil)
        xcode15WelcomePanelController.dataSource = self
        return xcode15WelcomePanelController
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let urls = try? FileManager.default.contentsOfDirectory(at: URL.downloadsDirectory, includingPropertiesForKeys: nil).prefix(10) {
            downloadURLs = Array(urls)
        }
        xcode14WelcomePanelController.showWindow(nil)
        xcode15WelcomePanelController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func welcomePanelUsesRecentDocumentURLs(_ welcomePanel: WelcomePanelController) -> Bool {
        false
    }

    func numberOfProjects(in welcomePanel: WelcomePanelController) -> Int {
        downloadURLs.count
    }

    func welcomePanel(_ welcomePanel: WelcomePanelController, urlForProjectAtIndex index: Int) -> URL {
        downloadURLs[index]
    }
}
