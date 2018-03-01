//
//  ScrollToTopHelper.swift
//  Focus.
//
//  Created by James on 1/3/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController {
    func setupScrollButton() {
        scrollToTopContainer.layer.cornerRadius = scrollToTopContainer.frame.height / 2
        scrollToTopContainer.backgroundColor = .secondary
        scrollToTopLabel.textColor = .black
        hideScrollButton()
    }
    
    func showScrollButton() {
        scrollToTopContainer.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.scrollToTopContainer.alpha = 1
        }
    }
    
    func hideScrollButton() {
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollToTopContainer.alpha = 0
        }) { (Bool) in
            self.scrollToTopContainer.isHidden = true
        }
    }
    
    @IBAction func scrollToTopAction(_ sender: Any) {
        centreTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        hideScrollButton()
    }
}
