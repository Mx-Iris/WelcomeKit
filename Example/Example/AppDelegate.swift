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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let urls = try? FileManager.default.contentsOfDirectory(at: URL.downloadsDirectory, includingPropertiesForKeys: nil).prefix(10) {
            downloadURLs = Array(urls)
        }
        var welcomeConfiguration = WelcomeConfiguration(style: .xcode15, welcomeLabelText: "WelcomeKit")
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 50
        shadow.shadowOffset = .init(width: 0, height: 2)
        shadow.shadowColor = .init(red: 0.09, green: 0.42, blue: 0.88, alpha: 0.55)
        welcomeConfiguration.appIconImageShadow = shadow
        welcomeConfiguration.primaryAction = .init(image: .symbol(systemName: .plusSquare, pointSize: 17, weight: .semibold), title: "Create New File...")
        welcomeConfiguration.secondaryAction = .init(image: .symbol(systemName: .squareAndArrowDownOnSquare, pointSize: 17, weight: .semibold), title: "Clone Git Repository...")
        welcomeConfiguration.tertiaryAction = .init(image: .symbol(systemName: .folder, pointSize: 17, weight: .semibold), title: "Open File or Folder...")
        let welcomePanelController = WelcomePanelController(configuration: welcomeConfiguration)
        welcomePanelController.showWindow(nil)
        welcomePanelController.dataSource = self
        
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

