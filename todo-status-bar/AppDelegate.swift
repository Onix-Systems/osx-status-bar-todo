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

    let statusItem = NSStatusBar.system().statusItem(withLength: -2)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        guard let button = statusItem.button else { return }
        button.image = #imageLiteral(resourceName: "StatusBarButtonImage")
//        button.action = #selector(AppDelegate.some(_:))

        /*
         let menu = NSMenu()

         menu.addItem(NSMenuItem(title: "Print Quote", action: Selector("printQuote:"), keyEquivalent: "P"))
         menu.addItem(NSMenuItem.separatorItem())
         menu.addItem(NSMenuItem(title: "Quit Quotes", action: Selector("terminate:"), keyEquivalent: "q"))
         
         statusItem.menu = menu
 */
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

