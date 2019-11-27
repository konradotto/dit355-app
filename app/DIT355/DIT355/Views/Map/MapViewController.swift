//
//  MapViewController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-11.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    
    var model = MapModel(frame: UIScreen.main.bounds)
    var controller : MapController!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        controller.initialView(animated: false)
         let b = MqttManager.shared

    }
    
    override func loadView() {
        self.view = model
        model.delegate = self
        controller = MapController.shared
        controller.delegate = self
        controller.model = self.model
    }
    
    
}
