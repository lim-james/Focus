//
//  MainController.swift
//  Focus.
//
//  Created by James on 22/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasks: [Task] = []
    var current = 0
    var changed = false
    
    var rowHeight: CGFloat = 92
    
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
        tasks.append(Task(title: "Example of completed event", duration: "1h", status: .DONE))
        tasks.append(Task(title: "This was skipped because the person was not determined enough", duration: "3h 30m", status: .SKIPPED))
        tasks.append(Task(title: "Timed event", duration: "1h 30m", status: .DOING))
        tasks.append(Task(title: "Events that loops unless stopped", duration: "30m", status: .UNDONE))
        tasks.append(Task(title: "This could be an event that was skipped by the user", duration: "1h 30m", status: .UNDONE))
        tasks.append(Task(title: "More events just to test out the scroll", duration: "5m", status: .UNDONE))
        tasks.append(Task(title: "If you're wondering this was made of 3 table views", duration: "1h 30m", status: .UNDONE))
        tasks.append(Task(title: "Apple made it the same I just adapted", duration: "30m", status: .UNDONE))
        
        setupTableView(topTableView)
        setupTableView(centreTableView)
        setupTableView(bottomTableView)
        
        centreTableView.alpha = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMainButton()
        hideButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        syncScrolls(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let y = targetContentOffset.pointee.y + scrollView.contentInset.top + rowHeight/2
        let cellIndex  = floor(y/rowHeight)
        targetContentOffset.pointee.y = cellIndex * rowHeight - scrollView.contentInset.top
        syncScrolls(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        syncScrolls(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        syncScrolls(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        syncScrolls(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        syncScrolls(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        syncScrolls(scrollView)
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        syncScrolls(scrollView)
    }
    
    func syncScrolls(_ scrollView: UIScrollView) {
        switch scrollView {
        case topTableView:
            centreTableView.contentOffset.y = topTableView.contentOffset.y
            bottomTableView.contentOffset.y = topTableView.contentOffset.y
        case centreTableView:
            topTableView.contentOffset.y = centreTableView.contentOffset.y
            bottomTableView.contentOffset.y = centreTableView.contentOffset.y
        case bottomTableView:
            topTableView.contentOffset.y = bottomTableView.contentOffset.y
            centreTableView.contentOffset.y = bottomTableView.contentOffset.y
        default:
            return
        }
    }
    
    @IBAction func mainAction(_ sender: Any) {
        let button = sender as! UIButton
        if button.titleLabel?.text == "New" {
            button.setTitle("Confirm", for: .normal)
//            centreTableView.scrollToRow(at: IndexPath(item: tasks.count, section: <#T##Int#>), at: <#T##UITableViewScrollPosition#>, animated: <#T##Bool#>)
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView != centreTableView {
            return tasks.count + 3
        }
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainCell
        if tableView == centreTableView {
            cell.task = tasks[indexPath.row]
            cell.backgroundColor = .black
            cell.isHidden = false
        } else if tableView == topTableView {
            if indexPath.row > 2 {
                cell.task = tasks[indexPath.row - 3]
                cell.isHidden = false
            } else {
                cell.isHidden = true
            }
        } else if tableView == bottomTableView {
            if indexPath.row < tasks.count {
                cell.task = tasks[indexPath.row]
                cell.isHidden = false
            } else {
                cell.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == topTableView {
            centreTableView.scrollToRow(at: IndexPath(row: indexPath.row - 3, section: indexPath.section), at: .top, animated: true)
        } else if tableView == bottomTableView {
            centreTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func setupTableView(_ tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = true
        tableView.alpha = 0.25
        tableView.backgroundColor  = .black
        tableView.estimatedRowHeight = rowHeight
        tableView.rowHeight = rowHeight
        tableView.register(UINib(nibName: "MainCellView", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    func setupMainButton() {
        // create gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = mainButton.bounds
        gradientLayer.colors = [buttonGradient[0].cgColor, buttonGradient[1].cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        mainButton.layer.insertSublayer(gradientLayer, at: 0)
        
        // create round rect
        mainButton.layer.cornerRadius = mainButton.frame.height/5
        mainButton.clipsToBounds = true
    }
    
    // hide cancel and delete buttons
    func hideButtons() {
        cancelButton.isHidden = true
        cancelEditButton.isHidden = true
        deleteEditButton.isHidden = true
    }

}
