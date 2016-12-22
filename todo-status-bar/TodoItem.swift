//
//  TodoItem.swift
//  todo-status-bar
//
//  Created by derp on 12/22/16.
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
