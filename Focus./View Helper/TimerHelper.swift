//
//  TimerHelper.swift
//  Focus.
//
//  Created by James on 26/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit
import AVFoundation

extension ViewController {
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func timerAction() {
        seconds += 1
        
        if seconds == 1 {
            seconds = 0
            if current.status == .DONE {
                current.spent = 0
            }
            current.status = .DOING
            current.spent += 1
            print(current.spent)
            if current.isDone {
                current.status = .DONE
                if current.id < tasks.count - 1 {
                    current = tasks[current.id + 1]
                } else {
                    stopTimer()
                }
            }
        }
    }
}
