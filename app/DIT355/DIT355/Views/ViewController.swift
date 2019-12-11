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
    
    var mqtt: MqttManager!
    var annotationManager: AnnotationManager!
    var mapController: MapController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        annotationManager = AnnotationManager.shared
        mapController = MapController.shared
        self.navigationItem.title = "Main"
        self.dataDrivenMode.layer.cornerRadius = 10
        self.interactiveMode.layer.cornerRadius = 10
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard mqtt != nil else { return mqtt = MqttManager.shared }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !mapController.annotations.isEmpty {
            mapController.dismiss()
        }
        guard mqtt == nil else {return mqtt = nil }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func dataDrivenButtonAction(_ sender: Any) {
        annotationManager.isInteractiveMode = false
        
        
    }
    
    @IBAction func interactiveButtonAction(_ sender: Any) {
        annotationManager.isInteractiveMode = true
    }
   
   

    
    
}
