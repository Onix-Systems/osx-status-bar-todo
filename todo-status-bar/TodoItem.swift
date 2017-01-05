//
//  TodoItem.swift
//  todo-status-bar
//
//  Created by Stanislav Derpoliuk on 12/22/16.
//  Copyright © 2016 Onix-Systems. All rights reserved.
//

import Cocoa

final class TodoItem: NSObject, NSCoding {
    var title: String
    var completed = false

    init(title: String) {
        self.title = title
    }

    init?(coder aDecoder: NSCoder) {
        self.title = (aDecoder.decodeObject(forKey: "title") as? String) ?? ""
        self.completed = aDecoder.decodeBool(forKey: "completed")
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(completed, forKey: "completed")
    }
}
