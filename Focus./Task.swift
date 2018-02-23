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

struct Task {
    var id: Int
    var title: String
    var hours: Int
    var minutes: Int
    var status: Status
}

extension Task {
    var getFormattedDuration: String {
        let h = hours == 0 ? "" : "\(hours)h "
        let m = minutes == 0 ? "" : "\(minutes)m"
        return "\(h)\(m)"
    }
    
    func getStatus() -> String {
        switch status {
        case .DONE:
            return "Done"
        case .DOING:
            return "\(getFormattedDuration) left"
        case .UNDONE:
            return "\(getFormattedDuration)"
        case .SKIPPED:
            return "Skipped"
        }
    }
}
