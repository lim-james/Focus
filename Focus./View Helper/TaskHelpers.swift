//
//  TaskHelper.swift
//  Focus.
//
//  Created by James on 23/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController: TaskDelegate {
    func updateCurrent() {
        if let cell = centreTableView.visibleCells[0] as? MainCell {
            current = cell.task
        }
    }
    
    func createNewTask() {
        let indexPath = IndexPath(item: tasks.count, section: 0)
        centreTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        if let cell = centreTableView.cellForRow(at: indexPath) as? MainCell {
            cell.titleView.becomeFirstResponder()
        }
    }
    
    func updateId() {
        for i in 0..<tasks.count {
            tasks[i].id = i
        }
    }
    
    // delegate methods
    
    func addTask(_ task: Task) {
        tasks.append(task)
        newTask = Task(id: tasks.count, title: "", hours: 1, minutes: 30, status: .UNDONE)
        reloadTableViews()
    }
}
