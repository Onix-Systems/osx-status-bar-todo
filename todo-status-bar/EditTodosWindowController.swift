//
//  EditTodosWindowController.swift
//  todo-status-bar
//
//  Created by derp on 12/21/16.
//  Copyright © 2016 Onix-Systems. All rights reserved.
//

import Cocoa

class EditTodosWindowController: NSWindowController, NSTableViewDelegate, NSTableViewDataSource {

    var todoItemsController: TodoItemsController?
    @IBOutlet var tableView: NSTableView!

    override func windowDidLoad() {
        super.windowDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return todoItemsController?.todoItems.count ?? 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard
            let todoItem = todoItemsController?.todoItems[row],
            let identifier = tableColumn?.identifier,
            let cellView = tableView.make(withIdentifier: identifier, owner: self) as? NSTableCellView else {
                return nil
        }
        if identifier == "TextCell" {
            cellView.textField?.stringValue = todoItem.title
        } else if identifier == "CheckboxCell" {
            if let cellView = cellView as? CheckboxTableCellView {
                cellView.checkboxButton.state = todoItem.completed ? NSOnState : NSOffState
                cellView.checkboxButton.tag = row
                cellView.checkboxButton.target = self
                cellView.checkboxButton.action = #selector(EditTodosWindowController.checkboxButtonStateChanged(_:))
            }
        }
        return cellView
    }

    @objc private func checkboxButtonStateChanged(_ sender: NSButton) {
        guard let todoItemsController = todoItemsController else { return }
        let todoItem = todoItemsController.todoItems[sender.tag]
        todoItemsController.mark(todoItem: todoItem, completed: sender.state == NSOnState)
    }

    @IBAction private func addButtonPressed(_ sender: NSButton) {

    }

    @IBAction private func clearAllButtonPressed(_ sender: NSButton) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = "Are you sure you want to delete all TODOs from the list?"
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "OK")
        let response = alert.runModal()
        if response == NSAlertSecondButtonReturn {
            todoItemsController?.deleteAll()
            tableView.reloadData()
        }
    }
    
}

final class CheckboxTableCellView: NSTableCellView {
    @IBOutlet var checkboxButton: NSButton!
}
