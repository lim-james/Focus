//
//  Task.swift
//  Focus.
//
//  Created by James on 22/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

enum Status {
    case DONE
    case DOING
    case UNDONE
    case SKIPPED
}

class Task {
    var id: Int
    var title: String
    var hours: Int
    var minutes: Int
    var spent: Int
    var status: Status
    
    init() {
        id = 0
        title = ""
        hours = 0
        minutes = 0
        spent = 0
        status = .UNDONE
    }
    
    init(id: Int, title: String, hours: Int, minutes: Int, status: Status) {
        self.id = id
        self.title = title
        self.hours = hours
        self.minutes = minutes
        self.spent = 0
        self.status = status
    }
    
    var getFormattedDuration: String {
        return formatTime(hours, minutes)
    }
    
    var getTimeLeft: String {
        let total = hours * 60 + minutes
        let left = total - spent
        let h = Int(left/60)
        let m = left - h*60
        return formatTime(h, m)
    }
    
    private func formatTime(_ h: Int, _ m: Int) -> String {
        let hStr = h == 0 ? "" : "\(h)h "
        let mStr = m == 0 ? "" : "\(m)m"
        return "\(hStr)\(mStr)"
    }
    
    var isDone: Bool {
        return hours * 60 + minutes == spent
    }
    
    func getStatus() -> String {
        switch status {
        case .DONE:
            return "Done"
        case .DOING:
            return "\(getTimeLeft) left"
        case .UNDONE:
            return "\(getFormattedDuration)"
        case .SKIPPED:
            return "Skipped"
        }
    }
}
