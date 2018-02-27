//
//  MainController.swift
//  Focus.
//
//  Created by James on 22/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

protocol ButtonDelegate {
    func focusButtons()
    func dimButtons()
}

protocol UpdateDelegate {
    func reloadTableViews()
}

protocol TaskDelegate {
    func createNewTask()
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
    var rowHeight: CGFloat = 184
    
    @IBOutlet weak var centreHeight: NSLayoutConstraint!
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
    
    var buttonGradient: [CGColor] = [UIColor.primary.cgColor, UIColor.secondary.cgColor]
    
    var previousMessage = "New"
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var mainButtonContainer: UIView!
    @IBOutlet weak var containerBottom: NSLayoutConstraint!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editButtonContainer: UIView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var topCenter: NSLayoutConstraint!
    @IBOutlet weak var bottomCenter: NSLayoutConstraint!
    
    var brightness: CGFloat = 0
    
    var seconds = 0
    var timer = Timer()
    
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
        
        topLine.backgroundColor = .primary
        bottomLine.backgroundColor = .primary
        
        newTask = Task(id: 0, title: "", hours: 1, minutes: 30, status: .UNDONE)
        
        brightness = UIScreen.main.brightness
        UIDevice.current.isProximityMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.brightnessChanged), name: NSNotification.Name.UIScreenBrightnessDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceProximityStateDidChange, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMainButton()
        
        centreHeight.constant = rowHeight
        
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
        focusButtons()
        if mainButton.titleLabel?.text == "New" {
            createNewTask()
        } else if mainButton.titleLabel?.text == "Done" {
            closeTimePicker()
        }
    }
    
    @IBAction func editAction(_ sender: Any) {
        focusButtons()
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
                self.topLine.backgroundColor = .primary
                self.topLine.transform = CGAffineTransform(rotationAngle: 0)
                self.bottomLine.backgroundColor = .primary
                self.bottomLine.transform = CGAffineTransform(rotationAngle: 0)
                self.view.layoutIfNeeded()
            }) { (Bool) in
                self.editTableView.isHidden = true
            }
        }
    }
    
    @objc func brightnessChanged() {
        brightness = UIScreen.main.brightness
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation == .faceDown && UIDevice.current.proximityState && editTableView.isHidden == true && !tasks.isEmpty {
            dimButtons()
            brightness = UIScreen.main.brightness
            UIScreen.main.brightness = 0
            if current == nil {
                current = tasks.first
            }
            if current.title.isEmpty {
                return
            }
            startTimer()
        } else {
            UIScreen.main.brightness = brightness
            stopTimer()
            reloadTableViews()
            if current != nil && !current.title.isEmpty {
                centreTableView.scrollToRow(at: IndexPath(row: current.id, section: 0), at: .top, animated: true)
            }
        }
    }
}
