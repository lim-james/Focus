//
//  TableViewHelpers.swift
//  Focus.
//
//  Created by James on 23/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController {
    func setupTableView(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = true
        tableView.alpha = 0.25
        tableView.backgroundColor  = .black
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = rowHeight
        tableView.register(UINib(nibName: "MainCellView", bundle: nil), forCellReuseIdentifier: "Cell")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() { view.endEditing(true) }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == bottomTableView || tableView == topTableView {
            return tasks.count + emptyRows + 1
        } else if tableView == editTableView {
            return tasks.count + 2 * emptyRows
        }
        return tasks.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainCell
        cell.isHidden = false
        cell.taskDelegate = self
        cell.timeDelegate = self
        cell.updateDelegate = self
        cell.backgroundColor = view.backgroundColor
        if tableView == centreTableView {
            cell.interactionView.isHidden = true
            cell.backgroundColor = .black
            if indexPath.row < tasks.count {
                cell.task = tasks[indexPath.row]
            } else if indexPath.row == tasks.count {
                cell.task = newTask
            } else {
                cell.isHidden = true
            }
        } else if tableView == topTableView {
            if indexPath.row >= emptyRows && indexPath.row <= emptyRows + tasks.count - 1 {
                cell.task = tasks[indexPath.row - emptyRows]
            } else if indexPath.row == tasks.count + emptyRows {
                cell.task = newTask
            } else {
                cell.isHidden = true
            }
        } else if tableView == bottomTableView {
            if indexPath.row < tasks.count {
                cell.task = tasks[indexPath.row]
            } else if indexPath.row == tasks.count {
                cell.task = newTask
            } else {
                cell.isHidden = true
            }
        } else if tableView == editTableView {
            if indexPath.row >= emptyRows && indexPath.row < tasks.count + emptyRows {
                cell.task = tasks[indexPath.row - emptyRows]
            } else {
                cell.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row - emptyRows)
            editTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = tasks[sourceIndexPath.row - emptyRows]
        tasks.remove(at: sourceIndexPath.row - emptyRows)
        tasks.insert(movedObject, at: destinationIndexPath.row  - emptyRows)
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row < emptyRows || proposedDestinationIndexPath.row >= tasks.count + emptyRows {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row >= emptyRows && indexPath.row < tasks.count + emptyRows
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closeTimePicker()
        let cell = tableView.cellForRow(at: indexPath) as! MainCell
//        current = cell.task
        if tableView == topTableView {
            centreTableView.scrollToRow(at: IndexPath(row: indexPath.row - emptyRows, section: indexPath.section), at: .top, animated: true)
        } else if tableView == bottomTableView {
            centreTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        } else if tableView == editTableView {
            editTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        } else {
            view.endEditing(true)
        }
    }
}
