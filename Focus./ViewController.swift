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
    
    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var centreTableView: UITableView!
    @IBOutlet weak var bottomTableView: UITableView!
    
    var current: Task!
    var newTask: Task!
    @IBOutlet weak var pickerContainer: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var buttonGradient = [UIColor(red: 0, green: 253/255, blue: 254/255, alpha: 1), UIColor(red: 0, green: 250/255, blue: 146/255, alpha: 1)]
    
    var previousMessage = "New"
    @IBOutlet weak var mainButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView(topTableView)
        setupTableView(centreTableView)
        setupTableView(bottomTableView)
        
        pickerContainer.alpha = 0
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        centreTableView.alpha = 1
        centreTableView.superview?.bringSubview(toFront: centreTableView)
        
        newTask = Task(id: tasks.count, title: "", hours: 1, minutes: 30, status: .UNDONE)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMainButton()
        
        emptyRows = Int((view.frame.height/rowHeight)/2)
        topMultiplier = topMultiplier.setMultiplier(CGFloat(emptyRows + 1))
        bottomMultiplier = bottomMultiplier.setMultiplier(CGFloat(emptyRows + 1))
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
}
