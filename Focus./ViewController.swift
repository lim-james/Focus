//
//  MainController.swift
//  Focus.
//
//  Created by James on 22/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

protocol UpdateDelegate {
    func reloadTableViews()
}

protocol TaskDelegate {
    func addTask(_ task: Task)
}

protocol TimeDelegate {
    func openTimePicker(with task: Task)
    func updateTime()
    func closeTimePicker()
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var tasks: [Task] = []
    
    var emptyRows: Int = 0
    var rowHeight: CGFloat = 92
    
    @IBOutlet weak var topMultiplier: NSLayoutConstraint!
    @IBOutlet weak var bottomMultiplier: NSLayoutConstraint!
    @IBOutlet weak var editMultiplier: NSLayoutConstraint!
    
    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var centreTableView: UITableView!
    @IBOutlet weak var bottomTableView: UITableView!
    @IBOutlet weak var editTableView: UITableView!
    
    var current: Task!
    var newTask: Task!
    @IBOutlet weak var pickerContainer: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var buttonGradient = [UIColor(red: 0, green: 253/255, blue: 254/255, alpha: 1), UIColor(red: 0, green: 250/255, blue: 146/255, alpha: 1)]
    
    var previousMessage = "New"
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var containerBottom: NSLayoutConstraint!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var topCenter: NSLayoutConstraint!
    @IBOutlet weak var bottomCenter: NSLayoutConstraint!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView(topTableView)
        setupTableView(centreTableView)
        setupTableView(bottomTableView)
        setupTableView(editTableView)
        
        pickerContainer.alpha = 0
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        centreTableView.alpha = 1
        
        editTableView.alpha = 0
        editTableView.isHidden = true
        editTableView.isEditing = true
        
        topLine.backgroundColor = buttonGradient[0]
        bottomLine.backgroundColor = buttonGradient[0]
        
        newTask = Task(title: "", hours: 1, minutes: 30, status: .UNDONE)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMainButton()
        
        emptyRows = Int((view.frame.height/rowHeight)/2) - 1
        topMultiplier = topMultiplier.setMultiplier(CGFloat(emptyRows + 1))
        bottomMultiplier = bottomMultiplier.setMultiplier(CGFloat(emptyRows + 1))
        editMultiplier = editMultiplier.setMultiplier(CGFloat(2 * emptyRows + 1))
        
        reloadTableViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mainAction(_ sender: Any) {
        if mainButton.titleLabel?.text == "New" {
            let indexPath = IndexPath(item: tasks.count, section: 0)
            centreTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            if let cell = centreTableView.cellForRow(at: indexPath) as? MainCell {
                cell.titleView.becomeFirstResponder()
            }
        } else if mainButton.titleLabel?.text == "Done" {
            closeTimePicker()
        }
    }
    
    @IBAction func editAction(_ sender: Any) {
        if editTableView.isHidden {
            view.endEditing(true)
            reloadTableViews()
            editTableView.isHidden = false
            containerBottom.constant = containerHeight.constant
            topCenter.constant = 0
            bottomCenter.constant = 0
            UIView.animate(withDuration: 0.25) {
                self.editTableView.alpha = 1
                self.topLine.backgroundColor = .red
                self.topLine.transform = CGAffineTransform(rotationAngle: .pi/4)
                self.bottomLine.backgroundColor = .red
                self.bottomLine.transform = CGAffineTransform(rotationAngle: -.pi/4)
                self.view.layoutIfNeeded()
            }
        } else {
            reloadTableViews()
            topCenter.constant = -4
            bottomCenter.constant = 4
            containerBottom.constant = 0
            UIView.animate(withDuration: 0.25, animations: {
                self.editTableView.alpha = 0
                self.topLine.backgroundColor = self.buttonGradient[0]
                self.topLine.transform = CGAffineTransform(rotationAngle: 0)
                self.bottomLine.backgroundColor = self.buttonGradient[0]
                self.bottomLine.transform = CGAffineTransform(rotationAngle: 0)
                self.view.layoutIfNeeded()
            }) { (Bool) in
                self.editTableView.isHidden = true
            }
        }
    }
}
