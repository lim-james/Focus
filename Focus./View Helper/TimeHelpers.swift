//
//  TimeHelpers.swift
//  Focus.
//
//  Created by James on 23/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController: TimeDelegate {
    func openTimePicker(with task: Task) {
        pickerView.selectRow(task.hours, inComponent: 0, animated: true)
        pickerView.selectRow(task.minutes, inComponent: 2, animated: true)
        
        bottomMultiplier = bottomMultiplier.setMultiplier(1)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.bottomTableView.alpha = 0
            self.pickerContainer.alpha = 1
        }
    }
}
