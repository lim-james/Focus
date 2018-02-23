//
//  MainController.swift
//  Focus.
//
//  Created by James on 22/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

protocol TaskDelegate {
    func addTask(_ task: Task)
    func updateTask(_ task: Task)
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasks: [Task] = []
    var current = 0
    var changed = false
    
    var emptyRows: Int = 0
    var rowHeight: CGFloat = 92
    
    @IBOutlet weak var topMultiplier: NSLayoutConstraint!
    @IBOutlet weak var bottomMultiplier: NSLayoutConstraint!
    
    var topInset: CGFloat = 0
    
    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var centreTableView: UITableView!
    @IBOutlet weak var bottomTableView: UITableView!
    
    var buttonGradient = [UIColor(red: 0, green: 253/255, blue: 254/255, alpha: 1), UIColor(red: 0, green: 250/255, blue: 146/255, alpha: 1)]
    
    @IBOutlet weak var mainButton: UIButton! // new task, confirm edit or creation
    
    @IBOutlet weak var cancelButton: UIButton! // to cancel new tasks
    @IBOutlet weak var cancelEditButton: UIButton! // to cancel edits
    @IBOutlet weak var deleteEditButton: UIButton! // to delete task
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks.append(Task(id: 0, title: "Example of completed event", duration: "1h", status: .DONE))
        tasks.append(Task(id: 1, title: "This was skipped because the person was not determined enough", duration: "3h 30m", status: .SKIPPED))
        tasks.append(Task(id: 2, title: "Timed event", duration: "1h 30m", status: .DOING))
        tasks.append(Task(id: 3, title: "Events that loops unless stopped", duration: "30m", status: .UNDONE))
        tasks.append(Task(id: 4, title: "This could be an event that was skipped by the user", duration: "1h 30m", status: .UNDONE))
        tasks.append(Task(id: 5, title: "More events just to test out the scroll", duration: "5m", status: .UNDONE))
        tasks.append(Task(id: 6, title: "If you're wondering this was made of 3 table views", duration: "1h 30m", status: .UNDONE))
        tasks.append(Task(id: 7, title: "Apple made it the same I just adapted", duration: "30m", status: .UNDONE))
        
        setupTableView(topTableView)
        setupTableView(centreTableView)
        setupTableView(bottomTableView)
        
        centreTableView.alpha = 1
        centreTableView.superview?.bringSubview(toFront: centreTableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMainButton()
        hideButtons()
        
        emptyRows = Int((view.frame.height/rowHeight)/2)
        topMultiplier = topMultiplier.setMultiplier(CGFloat(emptyRows + 1))
        bottomMultiplier = bottomMultiplier.setMultiplier(CGFloat(emptyRows + 1))
        reloadTablesViews()
        
        topInset = 20
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mainAction(_ sender: Any) {
        if mainButton.titleLabel?.text == "New" {
            mainButton.setTitle("Confirm", for: .normal)
            let indexPath = IndexPath(item: tasks.count, section: 0)
            centreTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        } else {
            mainButton.setTitle("New", for: .normal)
        }
    }
}
