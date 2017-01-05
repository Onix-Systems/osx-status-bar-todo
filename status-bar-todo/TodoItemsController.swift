//
//  TodoItemsController.swift
//  todo-status-bar
//
//  Created by Stanislav Derpoliuk on 12/22/16.
//  Copyright © 2016 Onix-Systems. All rights reserved.
//

import Cocoa

final class TodoItemsController {

    private let itemsKey = "TodoItems"
    private(set) var todoItems = [TodoItem]()

    init() {
        guard
            let data = UserDefaults.standard.object(forKey: itemsKey) as? Data,
            let items = NSKeyedUnarchiver.unarchiveObject(with: data) as? [TodoItem] else {
                return
        }
        todoItems = items
    }

    func mark(todoItem: TodoItem, completed: Bool) {
        todoItem.completed = completed
        saveTodoItems()
    }

    func addTodoItem(title: String) {
        let todoItem = TodoItem(title: title)
        todoItems.append(todoItem)
        saveTodoItems()
    }

    func deleteAll() {
        todoItems = []
        saveTodoItems()
    }

    func deleteTodoItem(at index: Int) {
        todoItems.remove(at: index)
        saveTodoItems()
    }

    func update(title: String, forTodoItem todoItem: TodoItem) {
        todoItem.title = title
        saveTodoItems()
    }

    private func saveTodoItems() {
        let data = NSKeyedArchiver.archivedData(withRootObject: todoItems)
        UserDefaults.standard.set(data, forKey: itemsKey)
    }
    
}
