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
    
    private init(){}
    
    func toStruct(_ str: String){
        
        let jsonData  = JSON(parseJSON: str)
        self.toAnnotations(Request(obj: jsonData))
    }
    
    
    func toAnnotations(_ rm : Request){
       
        //need to convert the timeinterval tho
        var anns = [Annotation]()
        anns.append(Annotation(title: "Source",
                                      coordinate: CLLocationCoordinate2D(latitude: rm.originLat, longitude: rm.originLong),
                                      purpose: rm.purpose,
                                      type: rm.type,
                                      depTime: rm.departureTime,
                                      id: rm.id))
        anns.append(Annotation(title: "Destination",
                                      coordinate: CLLocationCoordinate2D(latitude: rm.destinationLat, longitude: rm.destinationLong),
                                      purpose: rm.purpose,
                                      type: rm.type,
                                      depTime: rm.departureTime,
                                      id: rm.id))
        
        checkModes(anns)
    }
 
    func checkModes(_ anns: [Annotation]){
        
        if isInteractiveMode {
            print("interactiveMode: enabled")
            (0..<anns.count).forEach { (i) in
                self.annotations.append(anns[i])
            }
            if self.annotations.count > 18 {
                let title = "Session: \(sm.sessions.count + 1)"
                let date = Date()
                var anns = [Annotation]()
                (0 ..< self.annotations.count).forEach { (i) in
                    anns.append(annotations[i])
                }
                let s = Session(title: title, date: date, anns: self.annotations)
                sm.sessions.append(s)
                self.annotations.removeAll()
                NotificationCenter.default.post(name: Notification.Name(rawValue:"reloadData"), object: nil, userInfo: ["session" : s])
                print("session init")
            }
        } else { // prolly async
            mc.mapView.addAnnotations(anns)
        }
       
    }
    
   
    
}
