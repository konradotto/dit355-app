//
//  MapModel.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-11.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import MapKit

class MapModel: UIView {
    
    var delegate : MapViewController!
    var controller : MapController!
    
    //static let shared = MapModel()
    
    
    var mapView: MKMapView!
    var resetButton: UIButton!
    var subscribeButton: UIButton!
    var requestLabel: UILabel!
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mapView = MKMapView(frame: frame)
        self.addSubview(mapView)
        controller = MapController.shared
        controller.mapView = self.mapView
        initMap()
        showCompass()
        initButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initMap(){
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isZoomEnabled   = true
        mapView.isPitchEnabled  = false
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = controller
    }
    
    func showCompass(){
            mapView.showsCompass = false
            let compassButton = MKCompassButton(mapView:mapView)
            compassButton.compassVisibility = .visible
            self.addSubview(compassButton)
            compassButton.translatesAutoresizingMaskIntoConstraints = false
            compassButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 15).isActive = true
            compassButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 30).isActive = true
            
        }
    
    func initButtons(){
        
        resetButton = .init(type: .roundedRect)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.addTarget(self, action: #selector(resetButtonAction), for: .touchUpInside)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.isHidden = true
        resetButton.layer.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.layer.borderWidth = 1
        resetButton.layer.cornerRadius = 10
        self.addSubview(resetButton)
        resetButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -40).isActive = true
        resetButton.centerXAnchor.constraint(equalTo: self.centerXAnchor,constant: 0).isActive = true
        
        subscribeButton = .init(type: .roundedRect)
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        subscribeButton.addTarget(self, action: #selector(subscribeButtonAction), for: .touchUpInside)
        subscribeButton.setTitle("subscribe", for: .normal)
        subscribeButton.layer.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        subscribeButton.setTitleColor(.white, for: .normal)
        subscribeButton.layer.borderWidth = 1
        subscribeButton.layer.cornerRadius = 10
        self.addSubview(subscribeButton)
        subscribeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        subscribeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 0).isActive = true
        
    
        
    }
    
    @objc func resetButtonAction(sender: UIButton){
        controller.initialView(animated: true)
        resetButton.isHidden = true
    }
    
    @objc func subscribeButtonAction(sender: UIButton){
//           controller.initialView(animated: true)
//           resetButton.isHidden = true
//           broker.establishConnection()
        MqttManager.shared.subscribeTopic()
       }
    
    
    
    
}
