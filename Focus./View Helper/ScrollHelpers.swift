//
//  ScrollHelpers.swift
//  Focus.
//
//  Created by James on 23/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in topTableView.visibleCells {
            check(tableView: topTableView, cell: cell)
        }
        
        for cell in centreTableView.visibleCells {
            check(tableView: centreTableView, cell: cell)
        }
        
        for cell in bottomTableView.visibleCells {
            check(tableView: bottomTableView, cell: cell)
        }
        syncScrolls(scrollView)
    }
    
    func check(tableView: UITableView, cell: UITableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let rectOfCell = tableView.rectForRow(at: indexPath!)
        let rectOfCellInSuperview = tableView.convert(rectOfCell, to: tableView.superview)
        let extra = view.frame.height * 0.5
        let center = (view.frame.height + extra - rowHeight)/2
        let y = rectOfCellInSuperview.minY + extra/2
        var scale = center/y
        if scale > 1 {
            scale = 1/(scale)
        }
        if scale < 0 {
            scale = 0
        }
        cell.contentView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    func sq(_ x: CGFloat) -> CGFloat {
        return x*x
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        syncScrolls(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        syncScrolls(scrollView)
        updateCurrent()
        checkAddRow()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        syncScrolls(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let y = targetContentOffset.pointee.y + rowHeight/2
        let cellIndex  = floor(y/rowHeight)
        targetContentOffset.pointee.y = cellIndex * rowHeight

        updateCurrent()
        syncScrolls(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        syncScrolls(scrollView)
        updateCurrent()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        syncScrolls(scrollView)
        updateCurrent()
        checkAddRow()
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        syncScrolls(scrollView)
    }
    
    func checkAddRow() {
        let indexPath = IndexPath(item: tasks.count, section: 0)
        if centreTableView.contentOffset.y/rowHeight == CGFloat(tasks.count) {
            let cell = centreTableView.cellForRow(at: indexPath) as! MainCell
            cell.titleView.becomeFirstResponder()
        } else {
            mainButton.setTitle("New", for: .normal)
        }
    }
    
    func syncScrolls(_ scrollView: UIScrollView) {
        view.endEditing(true)
        switch scrollView {
        case topTableView:
            centreTableView.contentOffset.y = topTableView.contentOffset.y
            bottomTableView.contentOffset.y = topTableView.contentOffset.y
            editTableView.contentOffset.y = topTableView.contentOffset.y
        case centreTableView:
            topTableView.contentOffset.y = centreTableView.contentOffset.y // == nil ? centreTableView.contentOffset.y : centreTableView.contentOffset.y + 20
            bottomTableView.contentOffset.y = centreTableView.contentOffset.y
            editTableView.contentOffset.y = centreTableView.contentOffset.y
        case bottomTableView:
            topTableView.contentOffset.y = bottomTableView.contentOffset.y
            centreTableView.contentOffset.y = bottomTableView.contentOffset.y
            editTableView.contentOffset.y = bottomTableView.contentOffset.y
        case editTableView:
            topTableView.contentOffset.y = editTableView.contentOffset.y
            centreTableView.contentOffset.y = editTableView.contentOffset.y
            bottomTableView.contentOffset.y = editTableView.contentOffset.y
        default:
            return
        }
    }
}
