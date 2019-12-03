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
    
    var delegate : UIViewController!
    var controller : MapController!
    var mapView: MKMapView!
    var resetButton: UIButton!
        
    
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
        //mapView.overrideUserInterfaceStyle = .dark
        mapView.delegate = controller
    }
    
    func showCompass(){
            mapView.showsCompass = false
            let compassButton = MKCompassButton(mapView:mapView)
            compassButton.compassVisibility = .visible
            self.addSubview(compassButton)
            compassButton.translatesAutoresizingMaskIntoConstraints = false
            compassButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 15).isActive = true
            compassButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 100).isActive = true
            
        }
    
    func initButtons(){
        
        resetButton = .init(type: .roundedRect)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.addTarget(self, action: #selector(resetButtonAction), for: .touchUpInside)
        resetButton.isHidden = true
        resetButton.setImage(UIImage(named: "arrow"), for: .normal)
        self.addSubview(resetButton)
        resetButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -15).isActive = true
        resetButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 100).isActive = true
        
    }
    
    @objc func resetButtonAction(sender: UIButton){
        controller.initialView(animated: true)
        resetButton.isHidden = true
    }
    
    
}
