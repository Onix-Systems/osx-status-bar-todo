//
//  EditTodosWindowController.swift
//  todo-status-bar
//
//  Created by Stanislav Derpoliuk on 12/21/16.
//  Copyright © 2016 Onix-Systems. All rights reserved.
//

import Cocoa

protocol EditTodosWindowControllerDelegate: class {
    func editTodosWindowControllerDidUpdateTodoItems(_ controller: EditTodosWindowController)
}

class EditTodosWindowController: NSWindowController, NSTableViewDelegate, NSTableViewDataSource, AddTodoViewControllerDelegate {

    weak var delegate: EditTodosWindowControllerDelegate?
    var todoItemsController: TodoItemsController?
    @IBOutlet var tableView: NSTableView!

    private var addTodoPanel: NSPanel?

    override func windowDidLoad() {
        super.windowDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.doubleAction = #selector(doubleClick(_:))
    }

    private func hideAddTodoPanel() {
        guard let window = window, let panel = addTodoPanel else { return }
        window.endSheet(panel)
    }

    // MAKR: - NSTableViewDataSource

    func numberOfRows(in tableView: NSTableView) -> Int {
        return todoItemsController?.todoItems.count ?? 0
    }

    // MARK: - NSTableViewDelegate

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard
            let todoItem = todoItemsController?.todoItems[row],
            let identifier = tableColumn?.identifier,
            let cellView = tableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else {
                return nil
        }
        if identifier.rawValue == "TextCell" {
            cellView.textField?.stringValue = todoItem.title
            if let cellView = cellView as? TodoItemTableCellView {
                cellView.todoItem = todoItem
            }
        } else if identifier.rawValue == "CheckboxCell" {
            if let cellView = cellView as? CheckboxTableCellView {
                cellView.checkboxButton.state = todoItem.completed ? NSControl.StateValue.on : NSControl.StateValue.off
                cellView.checkboxButton.tag = row
                cellView.checkboxButton.target = self
                cellView.checkboxButton.action = #selector(checkboxButtonStateChanged(_:))
            }
        }
        return cellView
    }

    // MARK: - AddTodoViewControllerDelegate

    func addTodoViewController(_ controller: AddTodoViewController, didAddTodoWith title: String) {
        todoItemsController?.addTodoItem(title: title)
        delegate?.editTodosWindowControllerDidUpdateTodoItems(self)
        tableView.reloadData()
        hideAddTodoPanel()
    }

    func addTodoViewControllerDidCancel(_ controller: AddTodoViewController) {
        hideAddTodoPanel()
    }

    // MARK: - Actions

    @objc private func checkboxButtonStateChanged(_ sender: NSButton) {
        guard let todoItemsController = todoItemsController else { return }
        let todoItem = todoItemsController.todoItems[sender.tag]
        todoItemsController.mark(todoItem: todoItem, completed: sender.state == NSControl.StateValue.on)
        delegate?.editTodosWindowControllerDidUpdateTodoItems(self)
    }

    @IBAction private func addButtonPressed(_ sender: NSButton) {
        let addTodoViewController = AddTodoViewController()
        addTodoViewController.delegate = self
        guard let window = window else { return }
        let panel = NSPanel(contentViewController: addTodoViewController)
        var styleMask = panel.styleMask
        styleMask.remove(.resizable)
        panel.styleMask = styleMask
        self.addTodoPanel = panel
        window.beginSheet(panel)
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
        if response == NSApplication.ModalResponse.alertSecondButtonReturn {
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

    @objc func deleteMenuItemPressed(_ sender: NSMenuItem) {
        guard
            let todoItemsController = todoItemsController,
            let todoItem = sender.representedObject as? TodoItem,
            let index = todoItemsController.todoItems.firstIndex(of: todoItem)
            else {
                return
        }
        todoItemsController.deleteTodoItem(at: index)
        tableView.reloadData()
        delegate?.editTodosWindowControllerDidUpdateTodoItems(self)
    }

    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        return true
    }
    
}
