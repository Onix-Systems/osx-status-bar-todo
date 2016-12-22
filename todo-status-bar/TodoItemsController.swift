//
//  TodoItemsController.swift
//  todo-status-bar
//
//  Created by derp on 12/22/16.
//  Copyright © 2016 Onix-Systems. All rights reserved.
//

import Cocoa

final class TodoItemsController {

    private(set) var todoItems = [TodoItem]()

    init() {
        let item1 = TodoItem(title: "Add todos to menu")
        let item2 = TodoItem(title: "Enable checking todos off")
        let item3 = TodoItem(title: "Show remaining todos count in status bar")
        let item4 = TodoItem(title: "Edit todos in separate window")
        todoItems = [item1, item2, item3, item4]
    }

    func mark(todoItem: TodoItem, completed: Bool) {
        todoItem.completed = completed
    }

    func addTodoItem(title: String) {
        let todoItem = TodoItem(title: title)
        todoItems.append(todoItem)
    }

    func deleteAll() {
        todoItems = []
    }
    
}
