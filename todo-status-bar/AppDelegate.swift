//
//  AppDelegate.swift
//  todo-status-bar
//
//  Created by derp on 12/21/16.
//  Copyright © 2016 Onix-Systems. All rights reserved.
//

import Cocoa

struct TodoItem {
    let title: String
    var completed = false
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let button = statusItem.button else { return }
        button.title = "TODO"
        let menu = NSMenu()
        let item1 = NSMenuItem(title: "1 title", action: #selector(AppDelegate.some(_:)), keyEquivalent: "P")
        item1.state = NSOnState
        let item2 = NSMenuItem(title: "2 title", action: nil, keyEquivalent: "q")
        menu.addItem(item1)
        menu.addItem(item2)

        statusItem.menu = menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func some(_ sender: NSStatusBarButton) {
        print("111")
    }

}

