//
//  AppDelegate.swift
//  todo-status-bar
//
//  Created by Stanislav Derpoliuk on 12/21/16.
//  Copyright © 2016 Onix-Systems. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, EditTodosWindowControllerDelegate {

    @IBOutlet weak var window: NSWindow!

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    lazy var todoItemsController: TodoItemsController = TodoItemsController()
    lazy var editTodosWindowController: EditTodosWindowController = EditTodosWindowController(windowNibName: NSNib.Name("EditTodosWindowController") )

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        updateStatusItem()
    }

    // MARK: - Validate Menu Item

    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if let todoItem = menuItem.representedObject as? TodoItem {
            menuItem.state = todoItem.completed ? NSControl.StateValue.on : NSControl.StateValue.off
            guard let isVisible = editTodosWindowController.window?.isVisible else { return true }
            return !isVisible
        }
        return true
    }

    // MARK: - Setup Status Item

    private func updateStatusItem() {
        updateStatusItemButton()
        updateStatsItemMenu()
    }

    private func updateStatusItemButton() {
        guard let button = statusItem.button else { return }
        let totalCount = todoItemsController.todoItems.count
        let completedCount = todoItemsController.todoItems.filter { $0.completed }.count
        button.title = "☑️\(completedCount)/\(totalCount)"
    }

    private func updateStatsItemMenu() {
        let menu = NSMenu()
        menuItems(todoItems: todoItemsController.todoItems).forEach(menu.addItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(editMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitMenuItem)
        statusItem.menu = menu
    }

    private func menuItems(todoItems: [TodoItem]) -> [NSMenuItem] {
        var items = [NSMenuItem]()
        todoItems.forEach { todoItem in
            let todo = NSMenuItem(title: todoItem.title, action: #selector(menuTodoItemPressed(_:)), keyEquivalent: "")
            todo.representedObject = todoItem
            if todoItem.completed {
                let attributes = [
                    NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue),
                    NSAttributedString.Key.font: NSFont.menuBarFont(ofSize: 0)
                ]
                let attributedString = NSAttributedString(string: todoItem.title, attributes: attributes)
                todo.attributedTitle = attributedString
            }
            items.append(todo)
        }
        return items
    }

    private var editMenuItem: NSMenuItem {
        return NSMenuItem(title: "Edit TODOs...", action: #selector(menuEditItemPressed(_:)), keyEquivalent: "")
    }

    private var quitMenuItem: NSMenuItem {
        return NSMenuItem(title: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "")
    }

    // MARK: - Menu Actions

    @objc private func menuTodoItemPressed(_ sender: NSMenuItem) {
        guard let todoItem = sender.representedObject as? TodoItem else { return }
        todoItem.completed = !todoItem.completed
        updateStatusItem()
    }

    @objc private func menuEditItemPressed(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        editTodosWindowController.delegate = self
        editTodosWindowController.todoItemsController = todoItemsController
        editTodosWindowController.window?.center()
        editTodosWindowController.window?.makeFirstResponder(nil)
        editTodosWindowController.window?.makeKeyAndOrderFront(editTodosWindowController)
        editTodosWindowController.tableView.reloadData()
    }

    func editTodosWindowControllerDidUpdateTodoItems(_ controller: EditTodosWindowController) {
        updateStatusItem()
    }

}
