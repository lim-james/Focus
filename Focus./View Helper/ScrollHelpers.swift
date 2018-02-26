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
        syncScrolls(scrollView)
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
        let y = targetContentOffset.pointee.y + scrollView.contentInset.top + rowHeight/2
        let cellIndex  = floor(y/rowHeight)
        targetContentOffset.pointee.y = cellIndex * rowHeight - scrollView.contentInset.top
        updateCurrent()
        syncScrolls(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        syncScrolls(scrollView)
        updateCurrent()
        clip(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        syncScrolls(scrollView)
        updateCurrent()
        checkAddRow()
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        syncScrolls(scrollView)
    }
    
    func clip(_ scrollView: UIScrollView) {
        let cellIndex = floor(scrollView.contentOffset.y/rowHeight)
        scrollView.contentOffset.y = cellIndex * rowHeight
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
