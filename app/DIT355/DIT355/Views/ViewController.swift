//
//  ViewController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-28.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dataDrivenMode: UIButton!
    @IBOutlet weak var interactiveMode: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Main"
        self.dataDrivenMode.layer.cornerRadius = 10
        self.interactiveMode.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dataDrivenButtonAction(_ sender: Any) {
        AnnotationManager.shared.isInteractiveMode = false
        let _ = MqttManager.shared
    }
    
    @IBAction func interactiveButtonAction(_ sender: Any) {
        AnnotationManager.shared.isInteractiveMode = true
        let _ = MqttManager.shared
    }
   
   

    
    
}
