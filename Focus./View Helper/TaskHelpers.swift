//
//  TaskHelper.swift
//  Focus.
//
//  Created by James on 23/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController: TaskDelegate {
    func addTask(_ task: Task) {
        tasks.append(task)
        newTask = Task(id: tasks.count, title: "", hours: 1, minutes: 30, status: .UNDONE)
        reloadTableViews()
    }
}
