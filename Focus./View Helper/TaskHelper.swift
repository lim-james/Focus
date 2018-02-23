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
        reloadTablesViews()
    }
    
    func updateTask(_ task: Task) {
        tasks[task.id] = task
        reloadTablesViews()
    }
}
