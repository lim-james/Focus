//
//  MainCell.swift
//  Focus.
//
//  Created by James on 22/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var titleView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var interactionView: UIView!
    
    var task: Task! {
        didSet {
            titleView.text = task.title
            statusLabel.text =  task.getStatus()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleView.text = ""
        titleView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        titleView.tintColor = UIColor(red: 0, green: 253/255, blue: 254/255, alpha: 1)
        titleView.delegate = self
        statusLabel.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
