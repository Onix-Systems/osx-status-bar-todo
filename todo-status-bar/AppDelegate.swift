//
//  AppDelegate.swift
//  todo-status-bar
//
//  Created by derp on 12/21/16.
//  Copyright © 2016 Onix-Systems. All rights reserved.
//

import Cocoa

final class TodoItem {
    let title: String
    var completed = false

    init(title: String) {
        self.title = title
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard let button = statusItem.button else { return }
        button.title = "TODOs"

        let menu = NSMenu()

        let todoItems = generateTodosList()
        todoItems.forEach { todoItem in
            let menuItem = NSMenuItem(title: todoItem.title, action: #selector(AppDelegate.menuTodoItemPressed(_:)), keyEquivalent: "")
            menuItem.representedObject = todoItem
            menu.addItem(menuItem)
        }
        statusItem.menu = menu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    private func generateTodosList() -> [TodoItem] {
        let item1 = TodoItem(title: "Add todos to menu")
        let item2 = TodoItem(title: "Enable checking todos off")
        let item3 = TodoItem(title: "Show remaining todos count in status bar")
        let item4 = TodoItem(title: "Edit todos in separate window")
        return [item1, item2, item3, item4]
    }

    @objc private func menuTodoItemPressed(_ sender: NSMenuItem) {
        guard let todoItem = sender.representedObject as? TodoItem else { return }
        todoItem.completed = !todoItem.completed
        sender.state = todoItem.completed ? NSOnState : NSOffState
    }

}

