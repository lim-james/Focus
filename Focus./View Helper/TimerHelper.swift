//
//  TimerHelper.swift
//  Focus.
//
//  Created by James on 26/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController {
    func startTimer() {
        if let cell = centreTableView.visibleCells[0] as? MainCell {
            current = cell.task
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func timerAction() {
        seconds += 1
        
        if seconds == 1 {
            seconds = 0
            current.status = .DOING
            current.spent += 1
            print(current.spent)
            if current.isDone {
                // vibrate device
                current.status = .DONE
                if current.id < tasks.count {
                    current = tasks[current.id + 1]
                } else {
                    stopTimer()
                }
            }
        }
    }
}
