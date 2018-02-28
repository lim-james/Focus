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
        DispatchQueue.main.async {
            for cell in self.topTableView.visibleCells {
                self.check(tableView: self.topTableView, cell: cell)
            }
            
            for cell in self.centreTableView.visibleCells {
                self.check(tableView: self.centreTableView, cell: cell)
            }
            
            for cell in self.bottomTableView.visibleCells {
                self.check(tableView: self.bottomTableView, cell: cell)
            }
        }
        syncScrolls(scrollView)
        if tutorial == .time {
            setTutorialStatus(to: .none)
        }
    }
    
    func check(tableView: UITableView, cell: UITableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let rectOfCell = tableView.rectForRow(at: indexPath!)
        let rectOfCellInSuperview = tableView.convert(rectOfCell, to: tableView.superview)
        
        var center: CGFloat = 0
        var y: CGFloat = 0
        var scale: CGFloat = 0
        
        var extra: CGFloat = 0 {
            didSet {
                center = (self.view.frame.height + extra - self.rowHeight)/2
                y = rectOfCellInSuperview.minY + extra/2
                scale = center/y
                if scale > 1 { scale = 1/(scale) }
                if scale < 0 { scale = 0 }
            }
        }
        
        extra = self.view.frame.height * 0.05
        cell.contentView.subviews[0].transform = CGAffineTransform(scaleX: sqrt(scale), y: sqrt(scale))
        
        extra = 0
        cell.contentView.alpha = self.sq(scale)
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
        view.endEditing(true)
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
        }
    }
    
    func syncScrolls(_ scrollView: UIScrollView) {
        switch scrollView {
        case topTableView:
            centreTableView.contentOffset.y = topTableView.contentOffset.y
            bottomTableView.contentOffset.y = topTableView.contentOffset.y
            editTableView.contentOffset.y = topTableView.contentOffset.y
        case centreTableView:
            topTableView.contentOffset.y = centreTableView.contentOffset.y
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
