//
//  SideMenuViewController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-14.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    
    
    @IBOutlet weak var tramSwitch: UISwitch!
    @IBOutlet weak var busSwitch: UISwitch!
    @IBOutlet weak var ferrySwitch: UISwitch!
    
    private lazy var notificationCenter = NotificationCenter.default
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}
