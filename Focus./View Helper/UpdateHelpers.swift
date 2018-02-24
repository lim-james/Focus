//
//  UpdateHelpers.swift
//  Focus.
//
//  Created by James on 23/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController: UpdateDelegate {
    func reloadTableViews() {
        topTableView.reloadData()
        centreTableView.reloadData()
        bottomTableView.reloadData()
        editTableView.reloadData()
    }
}
