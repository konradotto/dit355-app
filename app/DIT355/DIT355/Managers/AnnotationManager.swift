//
//  ConversionManager.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-27.
//  Copyright © 2019 DIT355-group. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

class AnnotationManager {
    
    static let shared = AnnotationManager()
    var annotations = [Annotation]()
    private lazy var sm = SessionManager.shared
    private lazy var mc = MapController.shared
    var isInteractiveMode : Bool!
    
    private init(){
        NotificationCenter.default.addObserver(self, selector: #selector(dataMode(notification:)), name: Notification.Name(rawValue:"dataMode"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(interactiveMode(notification:)), name: Notification.Name(rawValue:"interactiveMode"), object: nil)
    }
    
    func toStruct(_ str: String){
        
        let jsonData  = JSON(parseJSON: str)
        let jsonObjet = jsonData["travelRequest"]
        self.toAnnotations(Request(obj: jsonObjet))
    }
    
    
    func toAnnotations(_ rm : Request){
       
        //need to convert the timeinterval tho
        var anns = [Annotation]()
        anns.append(Annotation(title: "Source",
                                      coordinate: CLLocationCoordinate2D(latitude: rm.originLat, longitude: rm.originLong),
                                      type: rm.type,
                                      purpose: rm.purpose,
                                      depTime: rm.departureTime,
                                      id: rm.id))
        anns.append(Annotation(title: "Destination",
                                      coordinate: CLLocationCoordinate2D(latitude: rm.destinationLat, longitude: rm.destinationLong),
                                      type: rm.type,
                                      purpose: rm.purpose,
                                      depTime: rm.departureTime,
                                      id: rm.id))
        
        checkModes(anns)
    }
 
    func checkModes(_ anns: [Annotation]){
        
        if isInteractiveMode {
            (0..<anns.count).forEach { (i) in
                self.annotations.append(anns[i])
            }
            if self.annotations.count > 1999 {
                let title = "Session: \(sm.sessions.count + 1)"
                let date = Date()
                sm.sessions.append(Session(title: title, date: date, anns: self.annotations))
                self.annotations.removeAll()
                NotificationCenter.default.post(name: Notification.Name(rawValue:"reloadData"), object: nil)
            }
        } else {
            mc.mapView.addAnnotations(anns)
        }
       
    }
    
    @objc func interactiveMode(notification: NSNotification){
        self.isInteractiveMode = true
    }
    
    @objc func dataMode(notification: NSNotification){
        self.isInteractiveMode = false
    }
    
}
