//
//  EditTodosWindowController.swift
//  todo-status-bar
//
//  Created by derp on 12/21/16.
//  Copyright © 2016 Onix-Systems. All rights reserved.
//

import Cocoa

protocol EditTodosWindowControllerDelegate: class {
    func editTodosWindowControllerDidUpdateTodoItems(_ controller: EditTodosWindowController)
}

class EditTodosWindowController: NSWindowController, NSTableViewDelegate, NSTableViewDataSource, AddTodoViewControllerDelegate {

    lazy var addTodoViewController: AddTodoViewController = AddTodoViewController()
    var panel: NSPanel?

    weak var delegate: EditTodosWindowControllerDelegate?
    var todoItemsController: TodoItemsController?
    @IBOutlet var tableView: NSTableView!

    override func windowDidLoad() {
        super.windowDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.doubleAction = #selector(doubleClick(_:))
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
                cellView.checkboxButton.action = #selector(checkboxButtonStateChanged(_:))
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
        addTodoViewController.delegate = self
        guard let window = window else { return }
        let panel = NSPanel(contentViewController: addTodoViewController)
        var styleMask = panel.styleMask
        styleMask.remove(.resizable)
        panel.styleMask = styleMask
        self.panel = panel
        window.beginSheet(panel)
    }

    func addTodoViewController(_ controller: AddTodoViewController, didAddTodoWith title: String) {
        todoItemsController?.addTodoItem(title: title)
        delegate?.editTodosWindowControllerDidUpdateTodoItems(self)
        tableView.reloadData()
        guard let window = window, let panel = panel else { return }
        window.endSheet(panel)
    }

    @IBAction private func doubleClick(_ tableView: NSTableView) {
        let row = tableView.clickedRow
        guard let view = tableView.view(atColumn: 1, row: row, makeIfNecessary: false) as? NSTableCellView, let textField = view.textField else {
            return
        }
        textField.isEditable = true
        textField.target = self
        textField.action = #selector(todoTextFieldDidEndEditing(_:))
        textField.tag = row
        if textField.acceptsFirstResponder {
            window?.makeFirstResponder(textField)
        }
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
            delegate?.editTodosWindowControllerDidUpdateTodoItems(self)
        }
    }

    @IBAction private func todoTextFieldDidEndEditing(_ sender: NSTextField) {
        defer {
            sender.isEditable = false
        }
        guard let todoItemsController = todoItemsController else { return }
        let todoItem = todoItemsController.todoItems[sender.tag]
        todoItemsController.update(title: sender.stringValue, forTodoItem: todoItem)
        delegate?.editTodosWindowControllerDidUpdateTodoItems(self)
    }
    
}

final class CheckboxTableCellView: NSTableCellView {
    @IBOutlet var checkboxButton: NSButton!
}
