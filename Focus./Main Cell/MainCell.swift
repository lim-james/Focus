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
    var buttonDelegate: ButtonDelegate!
    
    var task: Task! {
        didSet {
            if task.title.isEmpty {
                titleView.textColor = .lightText
                titleView.text = "New task"
                titleView.returnKeyType = .next
            } else {
                titleView.textColor = .white
                titleView.text = task.title
                titleView.returnKeyType = .done
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
        titleView.tintColor = .primary
        statusLabel.text = ""
    }
    
    @IBAction func selectTimeAction(_ sender: Any) {
        titleView.resignFirstResponder()
        timeDelegate.openTimePicker(with: task)
        buttonDelegate.focusButtons()
    }
    
    func updateTitle(to content: String) {
        if !content.isEmpty {
            task.title = content
            if titleView.returnKeyType == .next { taskDelegate.addTask(task) }
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
            textView.resignFirstResponder()
            if titleView.returnKeyType == .next {
                taskDelegate.createNewTask()
            }
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightText {
            textView.textColor = .white
            textView.text = ""
            UIView.animate(withDuration: 0.25, animations: {
                self.statusLabel.textColor = .primary
            })
        }
        
        DispatchQueue.main.async {
            self.timeDelegate.closeTimePicker()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.25, animations: {
            self.statusLabel.textColor = .white
        })
        if textView.text.isEmpty {
            if task.title.isEmpty {
                textView.textColor = .lightText
                textView.text = "New task"
            }
        } else {
            updateTitle(to: textView.text)
        }
    }

}
