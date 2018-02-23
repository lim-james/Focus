//
//  TaskHelper.swift
//  Focus.
//
//  Created by James on 23/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController: TaskDelegate {
    func setCurrentTask(_ task: Task) {
        current = task
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        reloadTableViews()
    }
}
