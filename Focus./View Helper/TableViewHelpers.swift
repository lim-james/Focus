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
    }
    
    func reloadTablesViews() {
        topTableView.reloadData()
        centreTableView.reloadData()
        bottomTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView != centreTableView {
            return tasks.count + emptyRows + 1
        }
        return tasks.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainCell
        cell.isHidden = false
        cell.delegate = self
        if tableView == centreTableView {
            cell.interactionView.isHidden = true
            cell.backgroundColor = .black
            if indexPath.row < tasks.count {
                cell.task = tasks[indexPath.row]
            } else if indexPath.row == tasks.count {
                cell.task = Task(id: indexPath.row, title: "", duration: "", status: .UNDONE)
            } else {
                cell.isHidden = true
            }
        } else if tableView == topTableView {
            if indexPath.row >= emptyRows && indexPath.row <= emptyRows + tasks.count - 1 {
                cell.task = tasks[indexPath.row - emptyRows]
            } else {
                cell.isHidden = true
            }
        } else if tableView == bottomTableView {
            if indexPath.row < tasks.count {
                cell.task = tasks[indexPath.row]
            } else if indexPath.row == tasks.count {
                cell.task = Task(id: indexPath.row, title: "", duration: "", status: .UNDONE)
            } else {
                cell.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == topTableView {
            centreTableView.scrollToRow(at: IndexPath(row: indexPath.row - emptyRows, section: indexPath.section), at: .top, animated: true)
        } else if tableView == bottomTableView {
            centreTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        } else {
            view.endEditing(true)
        }
    }
}
