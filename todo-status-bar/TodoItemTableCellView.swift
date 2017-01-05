//
//  TodoItemTableCellView.swift
//  todo-status-bar
//
//  Created by derp on 1/5/17.
//  Copyright © 2017 Onix-Systems. All rights reserved.
//

import Cocoa

final class TodoItemTableCellView: NSTableCellView {

    var todoItem: TodoItem?

    override func menu(for event: NSEvent) -> NSMenu? {
        let delete = NSMenuItem(title: "Delete", action: #selector(EditTodosWindowController.deleteMenuItemPressed(_:)), keyEquivalent: "")
        delete.representedObject = todoItem
        let menu = NSMenu()
        menu.addItem(delete)
        return menu
    }
    
}
