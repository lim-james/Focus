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
        
        if previousMessage != mainButton.titleLabel?.text {
            previousMessage =   (mainButton.titleLabel?.text)!
        }
        mainButton.setTitle("Done", for: .normal)
        
        current = task
        
        topTableView.isScrollEnabled = false
        centreTableView.isScrollEnabled = false
        bottomTableView.isScrollEnabled = false
        
        bottomMultiplier = bottomMultiplier.setMultiplier(1)
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            self.bottomTableView.alpha = 0
            self.pickerContainer.alpha = 1
        }
    }
    
    // seems hacky gotta fix it soon.
    func updateTime() {
        current.hours = pickerView.selectedRow(inComponent: 0)
        current.minutes = pickerView.selectedRow(inComponent: 2)
        if current.getFormattedDuration == "" {
            current.minutes = 1
            pickerView.selectRow(current.minutes, inComponent: 2, animated: true)
        }
        reloadTableViews()
    }
    
    func closeTimePicker() {
        topTableView.isScrollEnabled = true
        centreTableView.isScrollEnabled = true
        bottomTableView.isScrollEnabled = true
        
        mainButton.setTitle(previousMessage, for: .normal)
        bottomMultiplier = bottomMultiplier.setMultiplier(CGFloat(emptyRows + 1))
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            self.bottomTableView.alpha = 0.25
            self.pickerContainer.alpha = 0
        }
    }

}
