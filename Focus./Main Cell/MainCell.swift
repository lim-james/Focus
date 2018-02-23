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
    
    var delegate: TaskDelegate!
    
    var task: Task! {
        didSet {
            titleView.text = task.title
            statusLabel.text =  task.getStatus()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleView.delegate = self
        titleView.text = ""
        titleView.textContainer.maximumNumberOfLines = 2
//        titleView.textContainer.lineBreakMode = .byWordWrapping
        titleView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        titleView.tintColor = UIColor(red: 0, green: 253/255, blue: 254/255, alpha: 1)
        statusLabel.text = ""
    }
    
    func checkTask(_ content: String) {
        let prev = task.title
        task = Task(id: task.id, title: content, duration: task.duration, status: task.status)
        if prev.isEmpty { delegate.addTask(task) }
        else { delegate.updateTask(task) }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.numberOfLines() > 2 {
            titleView.removeTextUntilSatisfying()
            titleView.resignFirstResponder()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            checkTask(textView.text)
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        checkTask(textView.text)
    }

}
