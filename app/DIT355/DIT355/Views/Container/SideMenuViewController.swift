//
//  SideMenuViewController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-14.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import UIKit
import Charts

struct cellData {
    var isOpened = Bool()
    var session: Session!
    weak var barChartView: BarChartView!
}

class SideMenuViewController: UIViewController {
    

    
    @IBOutlet weak var tramSwitch: UISwitch!
    @IBOutlet weak var busSwitch: UISwitch!
    @IBOutlet weak var ferrySwitch: UISwitch!
    @IBOutlet weak var sessionSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartsButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    
    private lazy var notificationCenter = NotificationCenter.default
    private lazy var annotationManager  = AnnotationManager.shared
    
    private var dataArray: [Session]!
    let cellId = "cell"
    
    var tableViewData = [cellData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
    
    func initTable(){
        self.tableView.isHidden = false
        dataArray = [Session]()
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        notificationCenter.addObserver(self, selector: #selector(updateTableData(notification:)), name: Notification.Name(rawValue:"reloadData"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(deselectTableRow(notification:)), name: Notification.Name(rawValue:"deselectRow"), object: nil)
        annotationManager.isInteractiveMode = true
    }
    
    
    func deinitTable(){
        annotationManager.isInteractiveMode = false
        self.tableView.isHidden = true
        dataArray = nil
        notificationCenter.removeObserver(self, name: Notification.Name(rawValue:"reloadData"), object: nil)
        
    }
    
    @IBAction func tramSwitchAction(_ sender: Any) {
        if !tramSwitch.isOn{
            print("tram filter triggered")
            notificationCenter.post(name: Notification.Name(rawValue:"filterType"), object: nil, userInfo: ["filter" : "tram"])
        }
        else {
            notificationCenter.post(name: Notification.Name(rawValue:"filterType"), object: nil, userInfo: ["filter" : "none-tram"])
        }
        
    }
    
    @IBAction func busSwitchAction(_ sender: Any) {
        if !busSwitch.isOn{
            notificationCenter.post(name: Notification.Name(rawValue:"filterType"), object: nil, userInfo: ["filter" : "bus"])
        }
        else {
            notificationCenter.post(name: Notification.Name(rawValue:"filterType"), object: nil, userInfo: ["filter" : "none-bus"])
        }
    }
    
    @IBAction func ferrySwitchAction(_ sender: Any) {
        if !ferrySwitch.isOn{
            notificationCenter.post(name: Notification.Name(rawValue:"filterType"), object: nil, userInfo: ["filter" : "ferry"])
        }
        else {
            notificationCenter.post(name: Notification.Name(rawValue:"filterType"), object: nil, userInfo: ["filter" : "none-ferry"])
        }
    }
    
    @IBAction func sessionSwitchAction(_ sender: Any) {
        if sessionSwitch.isOn {
            initTable()
        }
        else {
            deinitTable()
        }
    }
    
    @IBAction func chartsbuttonAction(_ sender: Any) {
    }
    
    @IBAction func settingButtonAction(_ sender: Any) {
    }
    
    
    
    
    
    @objc func updateTableData(notification: NSNotification){
       
        if let userInfo = notification.userInfo {
            if let session = userInfo["session"] as? Session {
                
                dataArray.append(session)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func deselectTableRow(notification: NSNotification){
        guard let index = self.tableView.indexPathForSelectedRow else {return}
        self.tableView.deselectRow(at: index, animated: false)
    }
    
    @IBAction func chartsSwipeAction(_ sender: Any) {
        performSegue(withIdentifier: "settings", sender: sender)
    }
    @IBAction func settingSwipeAction(_ sender: Any) {
        performSegue(withIdentifier: "charts", sender: sender)
    }
    
}
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let session = dataArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SubtitleTableViewCell
        cell?.textLabel?.text = session.title
        cell?.detailTextLabel?.text = "\(session.annotations.count/2) requests"
        return cell!
    }
    
      func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

            if editingStyle == .delete {

                let alert = UIAlertController(title: "Are you sure you want to delete this session?", message: "", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
                    let sesh = self.dataArray[indexPath.row]
                    //self.sessions.remove(session: sesh)
                    self.dataArray.remove(at: indexPath.row)

                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

                self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let session = dataArray[indexPath.row]
        notificationCenter.post(name: Notification.Name(rawValue:"closeMenu"), object: nil)
        notificationCenter.post(name: Notification.Name(rawValue:"plotAnnottions"), object: nil, userInfo: ["session" : session])
    }
    
    }
    
}
