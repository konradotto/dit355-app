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
    

    
    override func viewWillAppear(_ animated: Bool) {
        if dataArray.isEmpty{
            dummyData()
        }
    }
    func initTable(){
        dataArray = sm.sessions
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableData(notification:)), name: Notification.Name(rawValue:"reloadData"), object: nil)
    }
    
    @objc func updateTableData(notification: NSNotification){
        self.tableView.reloadData()
    }
    
    
    func dummyData(){
        
        (0...10).forEach { (i) in
            let s = Session()
            s.title = "session \(i)"
            dataArray.append(s)
        }
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let session = dataArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SubtitleTableViewCell
        cell?.textLabel?.text = session.title
        cell?.detailTextLabel?.text = "\(session.annotations.count) requests"
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let session = dataArray[indexPath.row]
        NotificationCenter.default.post(name: Notification.Name(rawValue:"plotAnnottions"), object: nil, userInfo: ["sessionId" : session.id])
        //self.performSegue(withIdentifier: "navContainer", sender: self)
        
    }
    
    
    
}
