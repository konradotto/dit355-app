//
//  ViewController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-07.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let broker = BrokerCon.shared
        
        broker.establishConnection()
    }


}

