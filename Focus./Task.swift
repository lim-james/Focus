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
    var title: String
    var duration: String
    var status: Status
}

extension Task {
    func getStatus() -> String {
        switch status {
        case .DONE:
            return "Done"
        case .DOING:
            return "\(duration) left"
        case .UNDONE:
            return "\(duration)"
        case .SKIPPED:
            return "Skipped"
        }
    }
}
