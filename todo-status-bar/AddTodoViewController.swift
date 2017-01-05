//
//  AddTodoViewController.swift
//  todo-status-bar
//
//  Created by derp on 12/22/16.
//  Copyright © 2016 Onix-Systems. All rights reserved.
//

import Cocoa

protocol AddTodoViewControllerDelegate: class {
    func addTodoViewController(_ controller: AddTodoViewController, didAddTodoWith title: String)
    func addTodoViewControllerDidCancel(_ controller: AddTodoViewController)
}

class AddTodoViewController: NSViewController, NSControlTextEditingDelegate {

    weak var delegate: AddTodoViewControllerDelegate?

    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        guard let string = fieldEditor.string else { return true }
        delegate?.addTodoViewController(self, didAddTodoWith: string)
        return true
    }

    override func cancelOperation(_ sender: Any?) {
        delegate?.addTodoViewControllerDidCancel(self)
    }
    
}
