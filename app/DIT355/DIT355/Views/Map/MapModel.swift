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
    
    //MARK: - UI Elements
    var mapView: MKMapView!
    var resetButton: UIButton!
    var clearButton: UIButton!
    var leftSwipeRecogniser: UISwipeGestureRecognizer!
    var upSwipeRecogniser: UISwipeGestureRecognizer!
    
    //MARK: - Composed objects
    var delegate : UIViewController!
    var controller : MapController!
    
    //MARK: - Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        mapView = MKMapView(frame: frame)
        self.addSubview(mapView)
        controller = MapController.shared
        controller.mapView = self.mapView
        initMap()
        showCompass()
        initButtons()
        initGestures()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Class Functions
    /// Setup the mapView.
    func initMap(){
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isZoomEnabled   = true
        mapView.isPitchEnabled  = true
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = true
        mapView.overrideUserInterfaceStyle = .dark
        mapView.delegate = controller
    }
    /// Setup and display the compass on the tope left of the mapView.
    func showCompass(){
            mapView.showsCompass = false
            let compassButton = MKCompassButton(mapView:mapView)
            compassButton.compassVisibility = .visible
            self.addSubview(compassButton)
            compassButton.translatesAutoresizingMaskIntoConstraints = false
            compassButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 15).isActive = true
            compassButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 100).isActive = true
            
        }
    /// Setup and configure the mapView buttons.
    func initButtons(){
        
        resetButton = .init(type: .roundedRect)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.addTarget(self, action: #selector(resetButtonAction), for: .touchUpInside)
        resetButton.isHidden = true
        resetButton.setImage(UIImage(named: "arrow"), for: .normal)
        self.addSubview(resetButton)
        resetButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -15).isActive = true
        resetButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 100).isActive = true
        
        clearButton = .init(type: .roundedRect)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.addTarget(self, action: #selector(clearButtonAction), for: .touchUpInside)
        clearButton.isHidden = true
        clearButton.setImage(UIImage(named: "clear"), for: .normal)
        self.addSubview(clearButton)
        clearButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -15).isActive = true
        clearButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 150).isActive = true
        
    }
    /// Setup and configure the swipe gesture.
    func initGestures(){
        
        let rect = CGRect(x: self.mapView.frame.maxX - 25, y: 0.0, width: 25, height: self.mapView.frame.height)
        let v = UIView(frame: rect)
        self.leftSwipeRecogniser = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeGestureAction))
        leftSwipeRecogniser.direction = .left
        v.addGestureRecognizer(leftSwipeRecogniser)
        self.addSubview(v)
    }
    
    //MARK: - Selector Methods
    @objc func resetButtonAction(sender: UIButton){
        controller.initialView(animated: true)
        resetButton.isHidden = true
    }
    @objc func clearButtonAction(sender: UIButton){
        controller.clearAnnotations(isSession: true)
        clearButton.isHidden = true
        
    }
    @objc func leftSwipeGestureAction(){
        NotificationCenter.default.post(name: Notification.Name("openMenu"), object: nil)
    }
  
}
