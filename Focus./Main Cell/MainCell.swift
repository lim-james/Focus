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
    
    var taskDelegate: TaskDelegate!
    var timeDelegate: TimeDelegate!
    var updateDelegate: UpdateDelegate!
    
    var task: Task! {
        didSet {
            if task.title.isEmpty {
                titleView.textColor = .lightText
                titleView.text = "New task"
            } else {
                titleView.textColor = .white
                titleView.text = task.title
            }
            statusLabel.text = task.getStatus()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleView.delegate = self
        titleView.text = ""
        titleView.textContainer.maximumNumberOfLines = 2
        titleView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        titleView.tintColor = UIColor(red: 0, green: 253/255, blue: 254/255, alpha: 1)
        statusLabel.text = ""
    }
    
    @IBAction func selectTimeAction(_ sender: Any) {
        timeDelegate.openTimePicker(with: task)
        titleView.resignFirstResponder()
    }
    
    func checkTask(_ content: String) {
        if !content.isEmpty {
            let prev = task.title
            task.title = content
            if prev.isEmpty { taskDelegate.addTask(task) }
            else { updateDelegate.reloadTableViews() }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.numberOfLines() > 2 {
            textView.removeTextUntilSatisfying()
            textView.resignFirstResponder()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            checkTask(textView.text)
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightText {
            textView.textColor = .white
            textView.text = ""
            DispatchQueue.main.async {
                self.timeDelegate.closeTimePicker()
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if task.title.isEmpty {
                textView.textColor = .lightText
                textView.text = "New task"
            }
        } else {
            checkTask(textView.text)
        }
    }

}
