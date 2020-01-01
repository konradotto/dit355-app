//
//  MapViewController.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-11.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    
    lazy var model = MapModel(frame: UIScreen.main.bounds)
    lazy var controller : MapController! = MapController.shared
    let mqtt = MqttManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        controller.initialView(animated: false)
    }
    
    override func loadView() {
        self.view = model
        model.delegate = self
        controller.delegate = self
        controller.model = self.model
    }
}
