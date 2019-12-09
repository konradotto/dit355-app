//
//  SessionTableViewController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-14.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import UIKit

class SessionTableViewController: UITableViewController {
    
    private var dataArray: [Session]!
    let sm = SessionManager.shared
    let cellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
    }
    
    func initTable(){
        dataArray = [Session]()
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.tableFooterView = UIView(frame: CGRect.zero)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableData(notification:)), name: Notification.Name(rawValue:"reloadData"), object: nil)
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
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let session = dataArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SubtitleTableViewCell
        cell?.textLabel?.text = session.title
        cell?.detailTextLabel?.text = "\(session.annotations.count/2) requests"
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let session = dataArray[indexPath.row]
        //print("index: ",indexPath.description)
        NotificationCenter.default.post(name: Notification.Name(rawValue:"plotAnnottions"), object: nil, userInfo: ["session" : session])
        self.performSegue(withIdentifier: "navContainer", sender: self)
        
    }
    
    
    
}
